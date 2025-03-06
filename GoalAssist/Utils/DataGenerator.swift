//
//  DataGenerator.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 3/6/25.
//

import Foundation

class DataGenerator {
    
    static func goals(count: Int) -> [Goal] {
        var goals: [Goal] = []
        
        // Random data generators
        let goalTitles = ["Health Goal", "Career Goal", "Personal Development", "Fitness Challenge", "Study Plan"]
        let milestoneTitles = ["Beginner Milestone", "Intermediate Milestone", "Advanced Milestone", "Final Milestone"]
        let eventTitles = ["Morning Run", "Study Session", "Project Meeting", "Gym Workout", "Code Review"]
        let locations = ["Conference Room", "Office", "Gym", "Home", "Cafe"]
        
        // Helper function to generate random dates within the last month
        func randomDate() -> Date {
            let now = Date()
            let randomTimeInterval = TimeInterval(arc4random_uniform(60 * 60 * 24 * 30)) // Random date within the last month
            return now.addingTimeInterval(-randomTimeInterval)
        }
        
        // Helper function to generate a random Cadence
        func randomCadence() -> Cadence {
            let cadenceValues: [Cadence] = [.ONCE, .DAILY, .WEEKLY, .BIWEEKLY, .MONTHLY, .QUARTERLY, .YEARLY]
            return cadenceValues.randomElement()!
        }
        
        // Generate the events for each milestone
        func events(count: Int) -> [Event] {
            var events: [Event] = []
            
            for _ in 0..<count {
                let title = eventTitles.randomElement()!
                let startTime = randomDate()
                let endTime = randomDate()
                let cadence = randomCadence()
                
                let schedule = Schedule(startTime: startTime, endTime: endTime, regularity: cadence)
                let location = locations.randomElement()
                
                let event = Event(title: title, schedule: schedule, location: location)
                events.append(event)
            }
            
            return events
        }
        
        // Generate goals with milestones
        for i in 0..<count {
            let goalTitle = goalTitles.randomElement()!
            let progress = Float(arc4random_uniform(101)) / 100.0 // Random progress between 0.0 and 1.0
            var milestones: [Milestone] = []
            
            // Generate milestones for each goal
            for j in 0..<3 { // Let's assume 3 milestones for each goal
                let milestoneTitle = milestoneTitles[j]
                let milestoneProgress = Float(arc4random_uniform(101)) / 100.0 // Random progress for the milestone
                let events = events(count: 3) // Each milestone has 3 events
                
                let milestone = Milestone(id: Int64(j), title: milestoneTitle, events: events, progress: milestoneProgress)
                milestones.append(milestone)
            }
            
            let goal = Goal(id: Int64(i), title: goalTitle, milestones: milestones, progress: progress)
            goals.append(goal)
        }
        
        return goals
    }
}
