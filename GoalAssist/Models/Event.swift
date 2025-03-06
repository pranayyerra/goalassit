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
struct Event: Hashable, Codable {
    let title: String
    let schedule: Schedule
    let location: String?
}
