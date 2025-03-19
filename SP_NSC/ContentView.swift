//
//  ContentView.swift
//  SP_NSC
//
//  Created by Ted Goh on 18/3/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
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
                Countdown().tabItem {
                    Image(systemName: "timer")
                    Text("Countdown")
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {Image("SG60").resizable().scaledToFit().frame(width: 90)}
                ToolbarItem(placement: .navigationBarTrailing) {Image(systemName: "list.dash")}
            }
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
