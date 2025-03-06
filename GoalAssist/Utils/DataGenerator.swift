//
//  DataGenerator.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 3/6/25.
//

import Foundation

class DataGenerator {
    
    // Define the function to generate random events
    func generateEventDetails(count: Int) -> [EventDetails] {
        var events = [EventDetails]()
        
        // Generate random events
        for _ in 0..<count {
            let randomTitle = randomTitle()
            let randomStartDate = randomDate()
            let randomEndDate = randomEndDate(from: randomStartDate)
            
            let event = EventDetails(title: randomTitle, startDate: randomStartDate, endDate: randomEndDate)
            
            events.append(event)
        }
        
        return events
    }
    
    // Helper function to generate random event titles
    private func randomTitle() -> String {
        let titles = ["Meeting", "Workout", "Conference", "Birthday", "Project Deadline", "Dinner"]
        return titles.randomElement() ?? "Event"
    }
    
    // Helper function to generate a random start date
    private func randomDate() -> Date {
        let randomTimeInterval = TimeInterval(arc4random_uniform(100000000)) // Random time in the future
        return Date().addingTimeInterval(randomTimeInterval)
    }
    
    // Helper function to generate random end date (1 hour after the start date)
    private func randomEndDate(from startDate: Date) -> Date {
        return startDate.addingTimeInterval(3600) // 1 hour later
    }
}
