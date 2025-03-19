//
//  Explore.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI

struct Item {
    let name: String
    let imageName: String
    let link: String
}

let movies = [
    Item(name: "Ilo Ilo", imageName: "ilo_ilo", link: "https://en.wikipedia.org/wiki/Ilo_Ilo_(film)"),
    Item(name: "881", imageName: "881", link: "https://en.wikipedia.org/wiki/881_(film)"),
    Item(name: "Ah Boys to Men", imageName: "abtm", link: "https://en.wikipedia.org/wiki/Ah_Boys_to_Men"),
    Item(name: "Singapore Dreaming", imageName: "sg_dreaming", link: "https://en.wikipedia.org/wiki/Singapore_Dreaming"),
    Item(name: "Shirkers", imageName: "shirkers", link: "https://en.wikipedia.org/wiki/Shirkers"),
    Item(name: "12 Storeys", imageName: "12storeys", link: "https://en.wikipedia.org/wiki/12_Storeys"),
    Item(name: "Be with Me", imageName: "bwm", link: "https://en.wikipedia.org/wiki/Be_with_Me_(film)"),
    Item(name: "Forever \n Fever", imageName: "ff", link: "https://en.wikipedia.org/wiki/Forever_Fever"),
    Item(name: "My Magic", imageName: "my_magic", link: "https://en.wikipedia.org/wiki/My_Magic"),
    Item(name: "Sandcastle", imageName: "sandcastle", link: "https://en.wikipedia.org/wiki/Sandcastle_(2010_film)")
]

let artists = [
    Item(name: "JJ Lin", imageName: "jjl", link: "https://en.wikipedia.org/wiki/JJ_Lin"),
    Item(name: "Stefanie Sun", imageName: "ss", link: "https://en.wikipedia.org/wiki/Stefanie_Sun"),
    Item(name: "Dick Lee", imageName: "dl", link: "https://en.wikipedia.org/wiki/Dick_Lee"),
    Item(name: "Kit Chan", imageName: "kc", link: "https://en.wikipedia.org/wiki/Kit_Chan"),
    Item(name: "Tanya Chua", imageName: "tc", link: "https://en.wikipedia.org/wiki/Tanya_Chua"),
    Item(name: "Nathan Hartono", imageName: "nh", link: "https://en.wikipedia.org/wiki/Nathan_Hartono"),
    Item(name: "Gentle Bones", imageName: "gb", link: "https://en.wikipedia.org/wiki/Gentle_Bones"),
    Item(name: "The Sam Willows", imageName: "tsw", link: "https://en.wikipedia.org/wiki/The_Sam_Willows"),
    Item(name: "Olivia Ong", imageName: "oo", link: "https://en.wikipedia.org/wiki/Olivia_Ong"),
    Item(name: "Charlie Lim", imageName: "cl", link: "https://en.wikipedia.org/wiki/Charlie_Lim")
]

let foods = [
    Item(name: "Bak Kut Teh", imageName: "bak_kut_teh", link: "https://en.wikipedia.org/wiki/Bak_kut-teh"),
    Item(name: "Char Kway Teow", imageName: "char_kway_teow", link: "https://en.wikipedia.org/wiki/Char_kway_teow"),
    Item(name: "Chicken Rice", imageName: "chicken_rice", link: "https://en.wikipedia.org/wiki/Hainanese_chicken_rice"),
    Item(name: "Chilli Crab", imageName: "crab", link: "https://en.wikipedia.org/wiki/Chilli_crab"),
    Item(name: "Hokkien Mee", imageName: "hokkien_mee", link: "https://en.wikipedia.org/wiki/Hokkien_mee"),
    Item(name: "Kaya", imageName: "kaya", link: "https://en.wikipedia.org/wiki/Kaya_(spread)"),
    Item(name: "Laksa", imageName: "laksa", link: "https://en.wikipedia.org/wiki/Laksa"),
    Item(name: "Mee Siam", imageName: "mee_siam", link: "https://en.wikipedia.org/wiki/Mee_siam"),
    Item(name: "Nasi Lemak", imageName: "nasi_lemak", link: "https://en.wikipedia.org/wiki/Nasi_lemak"),
    Item(name: "Satay", imageName: "satay", link: "https://en.wikipedia.org/wiki/Satay")
]

enum Category {
    case movies, foods, artists
    
    var title: String {
        switch self {
        case .movies: return "Singaporean Movies"
        case .foods: return "Foods"
        case .artists: return "Artists"
        }
    }
}

struct Explore: View {
    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var dragOpacity: Double = 1.0
    @State private var dragRotation: Double = 0
    
    @State private var currentCategory: Category = .movies
    
    // 1. A flag that determines if the notice bar is shown
    @State private var showNotice = true
    @State private var showSecondNotice = true

    // Convenience to pick items from the enum
    var items: [Item] {
        switch currentCategory {
        case .movies:
            return movies
        case .foods:
            return foods
        case .artists:
            return artists
        }
    }
    
    var body: some View {
        // 2. Use a top-level VStack, and conditionally show the notice bar
        VStack(spacing: 0) {
            
            // 3. Conditionally show the notice bar at the top
            if showNotice {
                NoticeBar(showNotice: $showNotice, notice: "Swipe to see more items, tap to learn more!")
            }
            if showSecondNotice {
                NoticeBar(showNotice: $showSecondNotice, notice: "Tap on the title to switch categories")
                }
            
            // 4. Existing content
            Text(currentCategory.title)
                .font(.system(size: 32, weight: .bold))
                .padding()
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        switch currentCategory {
                        case .movies:
                            currentCategory = .foods
                        case .foods:
                            currentCategory = .artists
                        case .artists:
                            currentCategory = .movies
                        }
                        currentIndex = 0
                    }
                }
            
            ZStack {
                // Next card behind
                if currentIndex + 1 < items.count {
                    ZStack {
                        Image(items[(currentIndex + 1) % items.count].imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 371, height: 452)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(Color.black.opacity(0.3))
                            )
                            .scaleEffect(0.95)
                            .opacity(0.6)
                            .offset(y: 20)
                    }
                    .zIndex(-1)
                }
                
                // Current card
                if currentIndex < items.count {
                    ZStack {
                        Image(items[currentIndex].imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 371, height: 452)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(Color.black.opacity(0.4))
                            )
                            .scaleEffect(dragOffset == .zero ? 1 : 0.95)
                            .rotationEffect(.degrees(dragRotation))
                            .opacity(dragOpacity)
                            .offset(dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                        dragRotation = Double(value.translation.width / 20)
                                        dragOpacity = 1 - min(abs(value.translation.width) / CGFloat(1000), 0.2)
                                    }
                                    .onEnded { value in
                                        if abs(value.translation.width) > 150 {
                                            withAnimation(.spring()) {
                                                let isRightSwipe = value.translation.width > 0
                                                dragOffset = CGSize(
                                                    width: isRightSwipe ? 600 : -600,
                                                    height: value.translation.height
                                                )
                                                dragRotation = isRightSwipe ? 25 : -25
                                                dragOpacity = 0
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                currentIndex = (currentIndex + 1) % items.count
                                                resetDragState()
                                            }
                                        } else {
                                            withAnimation(.spring()) {
                                                resetDragState()
                                            }
                                        }
                                    }
                            )
                        
                        Text(items[currentIndex].name)
                            .font(.system(size: 64, weight: .bold))
                            .foregroundColor(.white)
                            .onTapGesture {
                                if let url = URL(string: items[currentIndex].link) {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                    .zIndex(1)
                }
            }
            .padding()
        }
    }
    
    private func resetDragState() {
        dragOffset = .zero
        dragOpacity = 1
        dragRotation = 0
    }
}

struct NoticeBar: View {
    @Binding var showNotice: Bool
    var notice: String
    var body: some View {
        HStack {
            Text(notice)
                .foregroundColor(.white)
                .font(.subheadline)
            
            Spacer()
            
            // An 'X' button to dismiss the notice
            Button {
                withAnimation {
                    showNotice = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.title2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        // Customize background color
        .background(Color.blue)
    }
}


#Preview {
    Explore()
}
