//
//  Timeline.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import Foundation

struct TimelineEntry: Identifiable {
    let id = UUID()
    let year: String
    let image: String
    let description: String
}

// Sample timeline data
let timelineData = [
    TimelineEntry(year: "1965", image: "SG60", description: "Singapore gains independence from Malaysia on 9 August."),
    TimelineEntry(year: "1968", image: "SG60", description: "First parliamentary election after independence."),
    TimelineEntry(year: "1981", image: "SG60", description: "Changi Airport opens."),
    TimelineEntry(year: "1987", image: "SG60", description: "The first MRT line begins operations."),
    TimelineEntry(year: "1997", image: "SG60", description: "Asian Financial Crisis impacts Singapore’s economy."),
    TimelineEntry(year: "2003", image: "SG60", description: "SARS outbreak hits Singapore."),
    TimelineEntry(year: "2015", image: "SG60", description: "Singapore celebrates SG50 (50 years of independence); passing of Lee Kuan Yew."),
    TimelineEntry(year: "2019", image: "SG60", description: "COVID-19 pandemic begins to impact Singapore."),
    TimelineEntry(year: "2022", image: "SG60", description: "First post-COVID National Day Parade."),
    TimelineEntry(year: "2025", image: "SG60", description: "Singapore celebrates SG60 (60 years of independence)")
]
