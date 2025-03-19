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
                    // First event card
                    EventCard(
                        title: "National Day Parade",
                        location: "Padang",
                        date: "9/8/24",
                        imageName: "Events"
                    )
                    
                    // Next event cards
                    ForEach(0..<3) { _ in
                        EventCard(
                            title: "Emu Otori Lookalike contest",
                            location: "SST",
                            date: "9/8/24",
                            imageName: "Events"
                        )
                    }
                }
                .padding(.vertical)
            }
            }.navigationTitle("Upcoming Events")
        }
    }
}
