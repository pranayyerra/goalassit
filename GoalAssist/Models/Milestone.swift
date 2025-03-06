//
//  Milestone.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 06/03/25.
//

import Foundation
import SwiftUI

struct Milestone: Hashable, Codable {
    var id: Int64?
    let title: String
    let events: [Event]
    let progress: Float
    
    static func sampleMilestones() -> [Milestone] {
        return [
            Milestone(id: 1, title: "Book Flights", events: [], progress: 0.7),
            Milestone(id: 2, title: "Book Accommodation ", events: [], progress: 0.2),
            Milestone(id: 3, title: "Plan Itinerary", events: [], progress: 0.2),
            Milestone(id: 4, title: "Actual Trip", events: [], progress: 0.5),
            Milestone(id: 5, title: "Back Home", events: [], progress: 0.0)
        ]
    }
}
