//
//  EventDetails.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 3/6/25.
//

import Foundation

import UIKit
import EventKit

// Define the EventDetails structure
struct EventDetails {
    var title: String
    var startDate: Date
    var endDate: Date
    var recurrenceRule: RecurrenceRule? // Recurrence rule structure to define recurrence
}

// Define RecurrenceRule to customize the recurrence pattern
struct RecurrenceRule {
    var frequency: EKRecurrenceFrequency
    var interval: Int
    var daysOfTheWeek: [EKRecurrenceDayOfWeek]?
    var occurrenceCount: Int?
    var endDate: Date?
}
