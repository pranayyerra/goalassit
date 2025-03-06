//
//  Schedule.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 06/03/25.
//

import Foundation
import SwiftUI

struct Schedule: Hashable, Codable {
    let startTime: Date?
    let endTime: Date?
    let regularity: Cadence
    
    static func sampleSchedules() -> [Schedule] {
        return [
            Schedule(startTime: Date.now, endTime: Date.init(timeIntervalSinceNow: 3600), regularity: Cadence.DAILY),
            Schedule(startTime: Date.now, endTime: Date.init(timeIntervalSinceNow: 3485), regularity: Cadence.WEEKLY),
            Schedule(startTime: Date.now, endTime: Date.init(timeIntervalSinceNow: 3454), regularity: Cadence.MONTHLY),
            Schedule(startTime: Date.now, endTime: Date.init(timeIntervalSinceNow: 64356), regularity: Cadence.YEARLY),
            Schedule(startTime: Date.now, endTime: Date.init(timeIntervalSinceNow: 8643), regularity: Cadence.BIWEEKLY)
        ]
    }
}
