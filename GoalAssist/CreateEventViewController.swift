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
                self?.addEventToCalendar()
            } else {
                print("do not have the required permissions")
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
    
    
    func addEventToCalendar() {
        let event = EKEvent(eventStore: eventStore)
        
        // Set the event details
        event.title = "Yerra Group test event"
        event.startDate = Date() // Current time or any desired start time
        event.endDate = event.startDate.addingTimeInterval(60 * 60) // 1 hour duration
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            // Save the event to the calendar
            try eventStore.save(event, span: .thisEvent)
            print("Event added successfully")
        } catch let error as NSError {
            print("Failed to save event: \(error)")
        }
    }
}
