//
//  Events.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//
import SwiftUI

struct EventCard: View {
    let title: String
    let location: String
    let date: String
    let imageName: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 375, height: 200) // Fixed size
                .clipped()
                .overlay(
                    Color.black.opacity(0.5) // Adjust opacity as needed
                )
            
            // A gradient overlay (optional) to darken the bottom area for text legibility
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.5)]),
                startPoint: .center,
                endPoint: .bottom
            )
            
            // Text content
            VStack(alignment: .leading, spacing: 4) {
                // Title with truncation
                if !title.isEmpty {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading) // Dynamic width
                }
                
                // Location and date row (only shown if data is available)
                HStack {
                    if !location.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.white)
                            Text(location)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    
                    if !date.isEmpty {
                        Spacer(minLength: location.isEmpty ? 0 : 8) // Remove extra space if location is empty
                        
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                            Text(date)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
            }
            .padding()
        }
        .frame(width: 375) // Fixed width
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.horizontal)
    }
}



struct Events: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
            // Scrollable list of events
            ScrollView {
                VStack(spacing: 16) {
                    EventCard(
                                            title: "Singapore Maritime Week",
                                            location: "EXPO@SMW",
                                            date: "22/3/25",
                                            imageName: "maritime"
                                        )
                                        EventCard(
                                            title: "SG Volunteer Management Conference",
                                            location: "Sands Expo and Convention",
                                            date: "28/3/25",
                                            imageName: "volunteer"
                                        )
                                        EventCard(
                                            title: "Start Small Dream Big Walkathon",
                                            location: "Sentosa",
                                            date: "11/5/25",
                                            imageName: "walkathon"
                                        )
                                        EventCard(
                                            title: "National Family Festival",
                                            location: "Gardens by the bay",
                                            date: "31/5/25",
                                            imageName: "family"
                                        )
                                        EventCard(
                                            title: "International Conference on Cohesive Societies",
                                            location: "Raffles Convention Center",
                                            date: "24/6/25",
                                            imageName: "cohesive"
                                        )
                }
                .padding(.vertical)
            }
            }.navigationTitle("Upcoming Events").foregroundStyle(Color.white)
        }
    }
}
