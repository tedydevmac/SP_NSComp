//
//  LandingPageView.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//
import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
    let gifName: String?
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color(red: 202 / 255, green: 1 / 255, blue: 25 / 255) : Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.bottom, 20)
    }
}

struct OnboardingPageContent: View {
    let page: OnboardingPage
    let index: Int
    let isLastPage: Bool
    let isFirstPage: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if !isFirstPage {
                if let gifName = page.gifName, let url = Bundle.main.url(forResource: gifName, withExtension: "lottie") {
                    LottieView(url: url)
                        .frame(width: 250, height: 250)
                        .offset(y: -80)
                } else {
                    // Fallback image or empty space if no gifName is available
                    Image("SG60")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .offset(y: -80)
                }
            } else {
                Image("SG60")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .offset(y: -80)
            }
            
            Text(page.title)
                .fontWeight(.bold)
                .font(.largeTitle)
                .foregroundColor(isFirstPage ? .white : .black)
                .multilineTextAlignment(.center)
                .offset(y: -80)
            
            if !isFirstPage {
                Text(page.description)
                    .font(.custom("Lato", size: 18))
                    .foregroundColor(isFirstPage ? .white : .black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .offset(y: -60)
            }
            
            if isLastPage {
                NavigationLink {
                    SignupView().navigationBarBackButtonHidden(true)
                } label: {
                    Text("Enter")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                        .frame(width: 312, height: 70)
                        .background(Color(red: 202 / 255, green: 1 / 255, blue: 25 / 255))
                        .cornerRadius(10)
                }
                .offset(y: -40)
            }
        }
    }
}


struct LandingPageView: View {
    @State private var currentPage = 0
    
    let onboardingPages = [
        OnboardingPage(
            image: "SG60",
            title: "Welcome to\nSG60's App Portal",
            description: "Your gateway to building a better Singapore together",
            gifName: nil
        ),
        OnboardingPage(
            image: "LandingPageBG",
            title: "Smart Features",
            description: "Usage of AI and Computer vision to make your app experience more fun and interactive",
            gifName: "placeholder"
        ),
        OnboardingPage(
            image: "SG60",
            title: "Easy Navigation",
            description: "Easily swap between features and pages",
            gifName: "travel"
        ),
        OnboardingPage(
            image: "SG60",
            title: "Get Started",
            description: "Join us in diving into Singapores SG60 culture",
            gifName: "starting"
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("LandingPageBG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .brightness(currentPage == 0 ? -0.375 : 0)
                    .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                // White background
                Color.white
                    .ignoresSafeArea()
                    .opacity(currentPage == 0 ? 0 : 1)
                    .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack {
                    TabView(selection: $currentPage) {
                        ForEach(Array(onboardingPages.enumerated()), id: \.element.id) { index, page in
                            OnboardingPageContent(
                                page: page,
                                index: index,
                                isLastPage: index == onboardingPages.count - 1,
                                isFirstPage: index == 0
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Custom Page Indicator
                    PageIndicator(currentPage: currentPage, totalPages: onboardingPages.count)
                        .offset(y: -20)
                }
            }
        }
    }
}

#Preview {
    LandingPageView()
}
