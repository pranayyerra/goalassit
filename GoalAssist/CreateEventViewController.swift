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
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    var events: [EventDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CreateEventViewController successfully launched")
        
//        setupScrollView()
        generateRandomEvents()
        displayEvents()
    }
    
    // MARK: - Generate Random Events
    func generateRandomEvents() {
        var randomEvents: [EventDetails] = []
        
        for i in 0..<10 { // Generate 10 random events
            let title = "Event \(i + 1)"
            let startDate = Date().addingTimeInterval(TimeInterval(i * 86400)) // 1 day apart
            let endDate = startDate.addingTimeInterval(3600) // 1 hour duration
            let recurrence = i % 2 == 0 ? "Weekly" : "Daily"
            
            let eventDetails = EventDetails(
                title: title,
                startDate: startDate,
                endDate: endDate,
                recurrenceRule: createRecurrenceRule(frequency: recurrence)
            )
            randomEvents.append(eventDetails)
        }
        
        events = randomEvents
    }
    
    // MARK: - Create Recurrence Rule
    func createRecurrenceRule(frequency: String) -> RecurrenceRule? {
        switch frequency {
        case "Weekly":
            return RecurrenceRule(
                frequency: .weekly,
                interval: 1,
                daysOfTheWeek: [EKRecurrenceDayOfWeek(.monday)], // Can be customized
                occurrenceCount: nil,
                endDate: nil
            )
        case "Daily":
            return RecurrenceRule(
                frequency: .daily,
                interval: 1,
                daysOfTheWeek: nil,
                occurrenceCount: nil,
                endDate: nil
            )
        default:
            return nil
        }
    }
    
    // MARK: - Display Events in ScrollView
    func displayEvents() {
        var yOffset: CGFloat = 20
        
        // Create a UILabel for each event
        for event in events {
            let eventView = createEventView(for: event, yOffset: yOffset)
            scrollView.addSubview(eventView)
            yOffset += eventView.frame.height + 10
        }
        
        // Set contentSize of scrollView so it can scroll
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: yOffset)
    }
    
    // MARK: - Create Event View
    func createEventView(for event: EventDetails, yOffset: CGFloat) -> UIView {
        let eventView = UIView(frame: CGRect(x: 20, y: yOffset, width: self.view.frame.width - 40, height: 100))
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: eventView.frame.width, height: 30))
        titleLabel.text = event.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        eventView.addSubview(titleLabel)
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 30, width: eventView.frame.width, height: 30))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateLabel.text = "Start: \(dateFormatter.string(from: event.startDate))"
        eventView.addSubview(dateLabel)
        
        let endDateLabel = UILabel(frame: CGRect(x: 0, y: 60, width: eventView.frame.width, height: 30))
        endDateLabel.text = "End: \(dateFormatter.string(from: event.endDate))"
        eventView.addSubview(endDateLabel)
        
        return eventView
    }

    
    @IBAction func saveEventsToCalendar(_ sender: UIButton) {
        eventStore.requestFullAccessToEvents() { [weak self] (granted, error) in
            guard let self = self else { return }
            
            if granted {
                // Save all events sequentially
                for eventDetails in self.events {
                    let ekEvent = EKEvent(eventStore: self.eventStore)
                    ekEvent.title = eventDetails.title
                    ekEvent.startDate = eventDetails.startDate
                    ekEvent.endDate = eventDetails.endDate
                    ekEvent.calendar = self.eventStore.defaultCalendarForNewEvents
                    
                    // Handle recurrence if any
//                    if let recurrenceRule = eventDetails.recurrenceRule {
//                        ekEvent.addRecurrenceRule(recurrenceRule)
//                    }
                    
                    do {
                        try self.eventStore.save(ekEvent, span: .thisEvent)
                        print("Event saved: \(ekEvent.title!)")
                    } catch {
                        print("Error saving event: \(error.localizedDescription)")
                    }
                }
                
                DispatchQueue.main.async {
                    self.showAlert(message: "All events saved successfully!")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Access to calendar was denied.")
                }
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
