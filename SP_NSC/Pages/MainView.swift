//
//  MainView.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//
import SwiftUI
struct MainView: View {
    var body: some View {
        VStack {
            TimelineView(entries: timelineData)
        }
    }
}
