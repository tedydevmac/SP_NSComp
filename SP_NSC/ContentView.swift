//
//  ContentView.swift
//  SP_NSC
//
//  Created by Ted Goh on 18/3/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    init() {
            // Set the color for unselected tab bar icons:
        UITabBar.appearance().unselectedItemTintColor = UIColor(hex: "#ed4749")
    }
    var body: some View {
        NavigationStack {
            TabView {
                MainView().tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                Photobooth().tabItem {
                    Image(systemName: "person.crop.square.badge.camera.fill")
                    Text("Photobooth")
                }
                Events().tabItem{
                    Image(systemName: "calendar.badge.clock")
                    Text("Schedule")
                }
                Explore().tabItem {
                    Image(systemName: "popcorn.fill")
                    Text("Explore")
                }
                Countdown().tabItem {
                    Image(systemName: "timer")
                    Text("Countdown")
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {Image("SG60-normal").resizable().scaledToFit().frame(width: 100)}
                ToolbarItem(placement: .navigationBarTrailing) {Image(systemName: "list.dash")}
            }.tint(Color.blue)
        }
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
