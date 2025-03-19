//
//  TimelineView.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI

struct TimelineView: View {
    let entries: [TimelineEntry]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Building Our\nSingapore Together")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                
                ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                    TimelineItemView(entry: entry, isLeft: index % 2 == 0)
                }
            }
            .padding()
        }
    }
}

struct TimelineItemView: View {
    let entry: TimelineEntry
    let isLeft: Bool
    @State private var showingModal = false
    
    var body: some View {
        HStack(spacing: 0) {
            if isLeft {
                yearView
                timelineCenter
                imageView
            } else {
                imageView
                timelineCenter
                yearView
            }
        }
        .frame(height: 120)
        .sheet(isPresented: $showingModal) {
                    ModalView(entry: entry)
                }
    }
    
    private var yearView: some View {
        Text(entry.year)
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .onTapGesture {
                showingModal = true
        }
    }
    
    private var imageView: some View {
        Image(entry.image)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color(hex: "#CA021A"), lineWidth: 2))
            .frame(maxWidth: .infinity)
            .onTapGesture {
                showingModal = true
        }
    }
    
    private var timelineCenter: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.red)
                .frame(width: 7.5)
            
            Circle()
                .fill(Color.red)
                .frame(width: 22.5, height: 22.5)
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 7.5)
        }
        .frame(width: 40)
    }
}

struct ModalView: View {
    let entry: TimelineEntry
    
    var body: some View {
        VStack {
            Image(entry.image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(hex: "#CA021A"), lineWidth: 2))
                .padding()
            Text(entry.year)
                .font(.title)
                .fontWeight(.bold)
            
            Text(entry.description).font(.subheadline)
                .fontWeight(.medium)
        }
        .padding()
    }
}

#Preview {
    TimelineView(entries: timelineData)
}
