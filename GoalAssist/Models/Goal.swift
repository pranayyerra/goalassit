//
//  Goal.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 06/03/25.
//

import Foundation
import SwiftUI

struct Goal: Hashable, Codable {
    var id: Int64?
    let title: String
    let milestones: [Milestone]
    let progress: Float
    
    static func sampleGoals() -> [Goal] {
        return [
            Goal(id: 1, title: "Travel the World", milestones: [], progress: 0.7),
            Goal(id: 2, title: "Squash Rating", milestones: [], progress: 0.2),
            Goal(id: 3, title: "Fitness Level", milestones: [], progress: 0.5),
            Goal(id: 4, title: "Grocery Getter", milestones: [], progress: 0.8),
            Goal(id: 5, title: "Master Swift", milestones: [], progress: 0.1)
        ]
    }
}
