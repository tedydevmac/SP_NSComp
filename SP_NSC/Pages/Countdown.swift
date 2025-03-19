//
//  Countdown.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI
import UserNotifications

struct Countdown: View {
    @State private var countdownDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 5) // Replace with the actual SG60 event date
    @State private var timeRemaining: (days: Int, hours: Int, minutes: Int, seconds: Int) = (0, 0, 0, 0)
    @State private var notificationScheduled = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SG60 Countdown")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            ZStack {
                Circle()
                    .stroke(Color.red, lineWidth: 7.5)
                    .frame(width: 300, height: 300)
                
                VStack {
                    Text(String(format: "%02d:%02d:%02d:%02d", timeRemaining.days, timeRemaining.hours, timeRemaining.minutes, timeRemaining.seconds))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 10) {
                        VStack {
                            Text("Days")
                        }
                        VStack {
                            Text("Hours")
                        }
                        VStack {
                            Text("Minutes")
                        }
                        VStack {
                            Text("Seconds")
                        }
                    }
                    .font(.caption)
                    .onAppear(perform: startCountdown)
                }
            }
            
            Button(action: scheduleNotification) {
                Group {
                    if notificationScheduled {
                        Image(systemName: "checkmark")
                            .font(.title2)
                    } else {
                        Text("Schedule Notification")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

        }
        .padding()
    }
    
    func startCountdown() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let currentTime = Date()
            let timeInterval = countdownDate.timeIntervalSince(currentTime)
            
            if timeInterval > 0 {
                let days = Int(timeInterval) / 86400
                let hours = Int(timeInterval) % 86400 / 3600
                let minutes = Int(timeInterval) % 3600 / 60
                let seconds = Int(timeInterval) % 60
                
                timeRemaining = (days, hours, minutes, seconds)
            } else {
                timeRemaining = (0, 0, 0, 0)
            }
        }
        timer.fire()
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "SG60 Event"
                content.body = "SG60 event is happening tomorrow!"
                content.sound = UNNotificationSound.default
                
                // Calculate the notification time (one day before the event)
                let notificationDate = Calendar.current.date(byAdding: .day, value: -1, to: countdownDate)!
                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // Add the notification request
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            notificationScheduled = true
                        }
                    }
                }
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
}

#Preview {
    Countdown()
}
