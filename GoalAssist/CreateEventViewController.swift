//
//  CreateEventViewController.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 3/6/25.
//

import Foundation
import UIKit
import EventKit

class CreateEventViewController: UIViewController {
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CreateEventViewController successfully launched")
    }
    
    @IBAction func addEventButtonTapped(_ sender: UIButton) {
        requestCalendarAccess { [weak self] granted in
            if granted {
                print("added event by pressing button!")
                let events = self?.createSampleEventDetails()
                self?.addEvents(events!)
                
                // Show a success alert
                self?.showAlert(message: "Events added successfully")
            } else {
                print("do not have the required permissions")
                
                self?.showAlert(message: "Please provide required permissions to access calendar")
            }
            
        }
    }
    
    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestFullAccessToEvents() { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
        
    }
    
    func showAlert(message: String, title: String = "Event Status") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add an "OK" button to dismiss the alert
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    
    func createSampleEventDetails() -> [EventDetails] {
         var events: [EventDetails] = []
         
         let recurrenceRule1 = RecurrenceRule(
             frequency: .weekly,
             interval: 1,
             daysOfTheWeek: [EKRecurrenceDayOfWeek(.monday)],
             occurrenceCount: 5,
             endDate: nil
         )
         
         let event1 = EventDetails(
             title: "NBOSE TEST Weekly Team Meeting",
             startDate: Date(),
             endDate: Date().addingTimeInterval(60 * 60), // 1 hour
             recurrenceRule: recurrenceRule1
         )
         
         let recurrenceRule2 = RecurrenceRule(
             frequency: .daily,
             interval: 1,
             daysOfTheWeek: nil, // Daily recurrence doesn't need specific days
             occurrenceCount: 7,
             endDate: nil
         )
         
         let event2 = EventDetails(
             title: "NBOSE TEST Daily Check-In",
             startDate: Date().addingTimeInterval(60 * 60 * 2), // 2 hours later
             endDate: Date().addingTimeInterval(60 * 60 * 3), // 1 hour duration
             recurrenceRule: recurrenceRule2
         )
         
         events.append(event1)
         events.append(event2)
         
         return events
     }

     // Function to map EventDetails to EKEvent and add them to the calendar
    // Function to map EventDetails to EKEvent and add them to the calendar
    func addEvents(_ eventDetailsArray: [EventDetails]) {
        for eventDetails in eventDetailsArray {
            let event = EKEvent(eventStore: eventStore)
            event.title = eventDetails.title
            event.startDate = eventDetails.startDate
            event.endDate = eventDetails.endDate
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            let recurrenceRule = eventDetails.recurrenceRule
            
            // Add recurrence rule to the event if needed
            if let recurrenceRule = eventDetails.recurrenceRule {
                let recurrenceEnd: EKRecurrenceEnd
                
                if let occurrenceCount = recurrenceRule.occurrenceCount {
                    recurrenceEnd = EKRecurrenceEnd(occurrenceCount: occurrenceCount)
                } else if let endDate = recurrenceRule.endDate {
                    recurrenceEnd = EKRecurrenceEnd(end: endDate)
                } else {
                    recurrenceEnd = EKRecurrenceEnd(occurrenceCount: 100) // default if no count or end date is provided
                }
                
                let recurrence = EKRecurrenceRule(
                    recurrenceWith: recurrenceRule.frequency,
                    interval: recurrenceRule.interval,
                    daysOfTheWeek: recurrenceRule.daysOfTheWeek ?? [],
                    daysOfTheMonth: nil,
                    monthsOfTheYear: nil,
                    weeksOfTheYear: nil,
                    daysOfTheYear: nil,
                    setPositions: nil,
                    end: recurrenceEnd
                )
                
                event.addRecurrenceRule(recurrence)
            }

            // Save the event to the calendar
            do {
                try eventStore.save(event, span: .futureEvents)
                print("Event \(event.title ?? "") added to calendar successfully.")
            } catch let error as NSError {
                print("Failed to save event: \(error.localizedDescription)")
            }
        }
    }
    
    
}
