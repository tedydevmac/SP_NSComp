//
//  ContentView.swift
//  SP_NSC
//
//  Created by Ted Goh on 18/3/25.
//

import SwiftUI
import SwiftData

struct DashboardOption: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: AnyView
}

struct DashboardCard: View {
    let option: DashboardOption
    let singaporeRed: Color
    let singaporeWhite: Color
    
    var body: some View {
        NavigationLink(destination: option.destination) {
            VStack(spacing: 15) {
                Image(systemName: option.icon)
                    .font(.system(size: 35))
                    .foregroundColor(singaporeRed)
                    .frame(width: 70, height: 70)
                    .background(singaporeRed.opacity(0.1))
                    .clipShape(Circle())
                
                Text(option.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(singaporeWhite)
            .cornerRadius(20)
            .shadow(color: singaporeRed.opacity(0.2), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(singaporeRed.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct ContentView: View {
    @State private var selectedOption: DashboardOption?
    
    // Singapore national colors
    let singaporeRed = Color(hex: "#ED1C24")
    let singaporeWhite = Color.white
    
    let dashboardOptions = [
        DashboardOption(title: "See Our Past", icon: "books.vertical.fill", destination: AnyView(TimelineView(entries: timelineData))),
        DashboardOption(title: "Photobooth", icon: "person.crop.square.badge.camera.fill", destination: AnyView(Photobooth())),
        DashboardOption(title: "Upcoming Events", icon: "calendar.badge.clock", destination: AnyView(Events())),
        DashboardOption(title: "Our Stars", icon: "popcorn.fill", destination: AnyView(Explore())),
        DashboardOption(title: "Countdown", icon: "timer", destination: AnyView(Countdown()))
    ]
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(hex: "#ed4749")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background pattern
                Color(hex: "#F8F8F8")
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header section
                            VStack(spacing: 10) {
                                Text("Welcome to")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                Text("SG60")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(singaporeRed)
                            }
                            .padding(.top)
                            
                            // Grid of options
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 15),
                                GridItem(.flexible(), spacing: 15)
                            ], spacing: 15) {
                                ForEach(dashboardOptions) { option in
                                    DashboardCard(option: option, singaporeRed: singaporeRed, singaporeWhite: singaporeWhite)
                                        .frame(height: geometry.size.width * 0.4)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("SG60-normal")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "list.dash")
                        .foregroundColor(singaporeRed)
                }
            }
        }.accentColor(singaporeRed)
    }
}

@main
struct MyApp: App {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    var testing = false
    func requestNotificationPermissions() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Notification permission error: \(error)")
                }
            }
    }
    var body: some Scene {
        WindowGroup {
            if testing {ContentView()}
            else {
                LandingPageView()
                .onAppear {
                    hasLaunchedBefore = true
                    requestNotificationPermissions()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
