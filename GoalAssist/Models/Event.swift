//
//  EventDetails.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 3/6/25.
//

import EventKit
import Foundation
import UIKit

// Define the EventDetails structure
struct Event: Hashable, Codable {
    let title: String
    let schedule: Schedule
    let location: String?

    static func sampleEvents() -> [Event] {
        let schedule = Schedule(startTime: Date.now, endTime: Date.init(timeIntervalSinceNow: 3600), regularity: Cadence.DAILY)

        return [
            Event(title: "Team Meeting", schedule: schedule, location: "Conference Room A"),
            Event(title: "Lunch Break",schedule: schedule, location: "Cafeteria"),
            Event(title: "Code Review", schedule: schedule, location: "Zoom"),
            Event(title: "Marketing Strategy Presentation", schedule: schedule, location: "Boardroom"),
            Event(title: "Product Launch Meeting", schedule: schedule, location: "Main Hall")
        ]
    }
}
