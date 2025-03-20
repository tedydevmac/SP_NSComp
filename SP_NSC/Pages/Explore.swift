//
//  Explore.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI

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
    @StateObject private var userManager = UserManager.shared
    
    // 1. A flag that determines if the notice bar is shown
    @State private var showNotice = true
    @State private var showSecondNotice = true

    // Track if points have been awarded for current category
    @State private var hasAwardedPoints = false

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
                        hasAwardedPoints = false
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
        .onChange(of: currentIndex) { oldIndex, newIndex in
            // Award points when user views multiple items in a category
            if newIndex > 0 && !hasAwardedPoints {
                userManager.addPoints(30, for: "explore")
                hasAwardedPoints = true
            }
        }
    }
    
    private func resetDragState() {
        dragOffset = .zero
        dragOpacity = 1
        dragRotation = 0
    }
}

#Preview {
    Explore()
}
