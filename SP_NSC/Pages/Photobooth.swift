//
//  Photobooth.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI
import AVFoundation
import Photos
import Vision

struct Photobooth: View {
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack{
            CameraPreview(camera: camera)
                .ignoresSafeArea()
                .overlay(
                    FaceDetectionOverlayView(
                        faces: camera.detectedFaces,
                        imageSize: UIScreen.main.bounds.size
                    )
                )
            VStack{
                Spacer()
                if camera.isTaken{
                    HStack{
                        Button{
                            camera.reTake()
                        }label:{
                            ZStack{
                                Circle()
                                    .fill(Color.black)
                                Image(systemName: "trash.circle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .scaledToFit()
                            }
                        }.frame(width: 70, height: 70)
                        Spacer()
                        Button{
                            if !camera.isSaved{
                                camera.savePic()
                            }
                        }label: {
                            if camera.isSaved{
                                Text("Saved")
                                    .padding()
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .background(.white)
                                    .foregroundStyle(.black)
                                    .cornerRadius(25)
                            }
                            else{
                                ZStack{
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 70, height: 70)
                                    Image(systemName: "square.and.arrow.down")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(.black)
                                        .scaledToFit()
                                        .padding(.bottom, 9)
                                        .frame(width: 57, height: 57)
                                }
                            }
                        }
                    }.padding(30)
                }
                else{
                    ZStack{
                        HStack{
                            Spacer()
                            Button{
                                camera.takePic()
                            }label:{
                                ZStack{
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 67, height: 67)
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                        .frame(width: 75, height: 75)
                                }
                            }
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Button{
                                camera.toggleCam()
                            }label:{
                                ZStack{
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(.black)
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                }
                            }
                            Spacer()
                        }
                    }.padding()
                }
            }
        }
        .onAppear(perform: {camera.AuthCheck()})
    }
}

struct FaceDetectionOverlayView: View {
    let faces: [VNFaceObservation]
    let imageSize: CGSize
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(faces, id: \.uuid) { face in
                let boundingBox = face.boundingBox
                let rect = CGRect(
                    x: boundingBox.minX * geometry.size.width,
                    y: (1 - boundingBox.maxY) * geometry.size.height,
                    width: boundingBox.width * geometry.size.width,
                    height: boundingBox.height * geometry.size.height
                )
                
                // Face rectangle
                Rectangle()
                    .stroke(Color.green, lineWidth: 2)
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
                
                // Sunglasses overlay with animation and position adjustment
                Image("sunglasses")
                    .resizable()
                    .scaledToFit()
                    .frame(width: rect.width * 1.1)
                    .position(
                        x: rect.midX + (rect.width * 0.05), // Move slightly to the right
                        y: rect.midY - (rect.height * 0.2)
                    )
                    .animation(.interpolatingSpring(stiffness: 100, damping: 15), value: rect)
            }
        }
    }
}

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var isTaken = false
    @Published var backCam = false
    @Published var device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    @Published var detectedFaces: [VNFaceObservation] = []
    @StateObject private var userManager = UserManager.shared
    
    private var videoDataOutput: AVCaptureVideoDataOutput?
    
    // Add smoothing for face detection
    private var lastDetectedFaces: [VNFaceObservation] = []
    private let smoothingFactor: CGFloat = 0.7
    
    func AuthCheck(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case.authorized:
            libCheck()
        case.notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ (status) in
                if status{
                    self.libCheck()
                }
            }
        case.denied:
            self.alert.toggle()
            return
        default: return
        }
    }
    
    func libCheck(){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status{
        case.authorized:
            self.setUp()
            return
        case.restricted:
            self.setUp()
            return
        case.notDetermined:
            PHPhotoLibrary.requestAuthorization{ newStatus in
                if newStatus == .authorized||newStatus == .restricted{
                    self.setUp()
                }
            }
        case.denied:
            self.alert.toggle()
            return
        default:return
        }
    }
    
    func setUp(){
        do{
            self.session.beginConfiguration()
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            else{
                if let currentInput = self.session.inputs.first as? AVCaptureDeviceInput{
                    self.session.removeInput(currentInput)
                }
                if self.session.canAddInput(input){
                    self.session.addInput(input)
                }
            }
            
            // Setup video output for face detection
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            if self.session.canAddOutput(videoOutput) {
                self.session.addOutput(videoOutput)
                self.videoDataOutput = videoOutput
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            // Configure video orientation and mirroring
            if let connection = videoOutput.connection(with: .video) {
                connection.videoOrientation = .portrait
                if connection.isVideoMirroringSupported {
                    connection.isVideoMirrored = !backCam
                }
            }
            
            self.session.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func toggleCam(){
        self.backCam.toggle()
        
        if backCam{
            self.device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        else{
            self.device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        }
        
        self.session.stopRunning()
        setUp()
        self.session.startRunning()
    }
    
    func takePic(){
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
    
    func reTake(){
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                self.objectWillChange.send()
                self.isSaved = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil { return }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.picData = imageData
        
        // Award points for taking a photo
        userManager.addPoints(50, for: "photobooth")
        
        withAnimation { self.isTaken.toggle() }
    }
    
    // Create composite image with sunglasses
    private func createCompositeImage(originalImage: UIImage, faces: [VNFaceObservation]) -> UIImage? {
        let imageSize = originalImage.size
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        return renderer.image { context in
            // Save the current graphics state
            context.cgContext.saveGState()
            
            // Mirror the context for front camera
            if !backCam {
                context.cgContext.translateBy(x: imageSize.width, y: 0)
                context.cgContext.scaleBy(x: -1, y: 1)
            }
            
            // Draw original image
            originalImage.draw(in: CGRect(origin: .zero, size: imageSize))
            
            // Draw sunglasses for each detected face
            for face in faces {
                let boundingBox = face.boundingBox
                let rect = CGRect(
                    x: boundingBox.minX * imageSize.width,
                    y: (1 - boundingBox.maxY) * imageSize.height,
                    width: boundingBox.width * imageSize.width,
                    height: boundingBox.height * imageSize.height
                )
                
                // Load and draw sunglasses
                if let sunglasses = UIImage(named: "sunglasses") {
                    let sunglassesSize = CGSize(
                        width: rect.width * 1.1,
                        height: rect.width * 1.1 * (sunglasses.size.height / sunglasses.size.width)
                    )
                    
                    // Calculate x position with mirroring for front camera
                    let xOffset = rect.width * 0.05
                    let xPosition = !backCam ?
                        imageSize.width - (rect.midX + xOffset) - sunglassesSize.width/2 : // Front camera: mirror the position
                        rect.midX + xOffset - sunglassesSize.width/2   // Back camera: original position
                    
                    let sunglassesRect = CGRect(
                        x: xPosition,
                        y: rect.midY - (rect.height * 0.2) - sunglassesSize.height/2,
                        width: sunglassesSize.width,
                        height: sunglassesSize.height
                    )
                    
                    // Save state for sunglasses
                    context.cgContext.saveGState()
                    
                    // Mirror sunglasses for front camera
                    if !backCam {
                        context.cgContext.translateBy(x: sunglassesRect.midX, y: sunglassesRect.midY)
                        context.cgContext.scaleBy(x: -1, y: 1)
                        context.cgContext.translateBy(x: -sunglassesRect.midX, y: -sunglassesRect.midY)
                    }
                    
                    sunglasses.draw(in: sunglassesRect)
                    
                    // Restore state for sunglasses
                    context.cgContext.restoreGState()
                }
            }
            
            // Restore the graphics state
            context.cgContext.restoreGState()
        }
    }
    
    // Update the face detection request to include landmarks
    private func createFaceDetectionRequest() -> VNDetectFaceLandmarksRequest {
        let request = VNDetectFaceLandmarksRequest { [weak self] request, error in
            guard let observations = request.results as? [VNFaceObservation] else { return }
            DispatchQueue.main.async {
                self?.detectedFaces = observations
            }
        }
        return request
    }
    
    // Real-time face detection with smoothing
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = createFaceDetectionRequest()
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
        // Apply smoothing to face detection
        if let newFaces = request.results as? [VNFaceObservation] {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // Smooth the face positions
                let smoothedFaces = newFaces.enumerated().map { index, newFace in
                    if index < self.lastDetectedFaces.count {
                        let lastFace = self.lastDetectedFaces[index]
                        return self.smoothFaceObservation(newFace, lastFace)
                    }
                    return newFace
                }
                
                self.detectedFaces = smoothedFaces
                self.lastDetectedFaces = smoothedFaces
            }
        }
    }
    
    // Smooth face observation
    private func smoothFaceObservation(_ new: VNFaceObservation, _ last: VNFaceObservation) -> VNFaceObservation {
        let smoothedBoundingBox = CGRect(
            x: last.boundingBox.minX + (new.boundingBox.minX - last.boundingBox.minX) * smoothingFactor,
            y: last.boundingBox.minY + (new.boundingBox.minY - last.boundingBox.minY) * smoothingFactor,
            width: last.boundingBox.width + (new.boundingBox.width - last.boundingBox.width) * smoothingFactor,
            height: last.boundingBox.height + (new.boundingBox.height - last.boundingBox.height) * smoothingFactor
        )
        
        let smoothedObservation = VNFaceObservation(boundingBox: smoothedBoundingBox)
        return smoothedObservation
    }
    
    // Face detection on captured photo
    private func detectFaces(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = createFaceDetectionRequest()
        try? VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request])
    }
    
    func savePic(){
        let image = UIImage(data: picData)!
        self.objectWillChange.send()
        self.isSaved = true
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("Saved pic")
    }
}

struct CameraPreview: UIViewRepresentable{
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()

        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
