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
    let dataGenerator = DataGenerator()
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    var events: [EventDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CreateEventViewController successfully launched")

        events = dataGenerator.generateEventDetails(count: 15)
        displayEvents()
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
    
    
}
