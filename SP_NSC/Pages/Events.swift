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
                    // Give the card a fixed height
                    .frame(height: 200)
                    .clipped()
                
                // A gradient overlay (optional) to darken the bottom area for text legibility
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.5)]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                
                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    // Location and date row
                    HStack {
                        HStack(spacing: 2) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.white)
                            Text(location)
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                            Text(date)
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                }
                .padding() // Padding for the text inside the ZStack
            }
            // Round the corners slightly
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
                                            imageName: "Events"
                                        )
                                        EventCard(
                                            title: "SG Volunteer Management Conference",
                                            location: "Sands Expo and Convention",
                                            date: "28/3/25",
                                            imageName: "Events"
                                        )
                                        EventCard(
                                            title: "Start Small Dream Big Walkathon",
                                            location: "Sentosa",
                                            date: "11/5/25",
                                            imageName: "Events"
                                        )
                                        EventCard(
                                            title: "National Family Festival",
                                            location: "Gardens by the bay",
                                            date: "31/5/25",
                                            imageName: "Events"
                                        )
                                        EventCard(
                                            title: "International Conference on Cohesive Societies",
                                            location: "Raffles Convention Center",
                                            date: "24/6/25",
                                            imageName: "Events"
                                        )
                }
                .padding(.vertical)
            }
            }.navigationTitle("Upcoming Events").foregroundStyle(Color.white)
        }
    }
}
