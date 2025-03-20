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
    TimelineEntry(year: "1965", image: "1965", description: "Singapore gains independence from Malaysia on 9 August, marking the birth of a sovereign nation under the leadership of Lee Kuan Yew."),
    TimelineEntry(year: "1968", image: "1968", description: "First parliamentary election after independence, with the People's Action Party (PAP) securing a decisive victory."),
    TimelineEntry(year: "1981", image: "1981", description: "Changi Airport opens, becoming a key hub for international travel and setting the stage for Singapore's rise as a global aviation center."),
    TimelineEntry(year: "1987", image: "1987", description: "The first MRT line begins operations between Yio Chu Kang and Toa Payoh, revolutionizing public transport in Singapore."),
    TimelineEntry(year: "1997", image: "1997", description: "Asian Financial Crisis impacts Singapore’s economy, leading to a recession and prompting economic restructuring efforts."),
    TimelineEntry(year: "2003", image: "2003", description: "SARS outbreak hits Singapore, leading to widespread public health measures and the establishment of the Disease Outbreak Response System Condition (DORSCON)."),
    TimelineEntry(year: "2015", image: "2015", description: "Singapore celebrates SG50 (50 years of independence) with a grand National Day Parade; the nation also mourns the passing of founding Prime Minister Lee Kuan Yew in March."),
    TimelineEntry(year: "2019", image: "2019", description: "COVID-19 pandemic begins to impact Singapore, prompting lockdowns (circuit breaker) and widespread adoption of remote working and learning."),
    TimelineEntry(year: "2022", image: "2022", description: "First post-COVID National Day Parade, marking a return to large-scale public gatherings and national celebrations."),
    TimelineEntry(year: "2025", image: "2025", description: "Singapore celebrates SG60 (60 years of independence) with a series of nationwide events highlighting the nation's progress and unity.")
]
