//
//  LandingPageView.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//
import SwiftUI
struct LandingPageView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("SG60")
                Text("Building Our Singapore Together").font(.custom("Lato", size: 36)).foregroundStyle(.black)
                NavigationLink {
                    ContentView().navigationBarBackButtonHidden(true)
                } label: {
                    Text("Start")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(hex: "#CA0119"))
                        .cornerRadius(10)
                }
            }.background(Image("LandingPageBG").resizable().scaledToFill().ignoresSafeArea().opacity(0.6))
        }
    }
}

