//
//  CreateEventViewController.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 3/6/25.
//

import Foundation
import UIKit
import EventKit
import SwiftUI

class ScheduleTabViewController: UIViewController {
    let eventStore = EKEventStore()
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    var goals: [Goal] = [] // List of goals
    var groupedEvents: [String: [Event]] = [:] // Events grouped by cadence
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         print("SchedulerViewController successfully launched")
         
         // Generate sample goals (or get them from your data source)
         goals = DataGenerator.goals(count: 1) // Example: This returns a list of goals
         
         // Extract events from milestones and group them by cadence
         let allEvents = extractEventsFromGoals(goals)
         groupedEvents = groupEventsByCadence(events: allEvents)
         
         // Display the grouped events
         displayEvents()
     }
     
     // MARK: - Extract Events from Goals and Milestones
     func extractEventsFromGoals(_ goals: [Goal]) -> [Event] {
         var allEvents: [Event] = []
         
         // Iterate over goals and their milestones to extract all events
         for goal in goals {
             for milestone in goal.milestones {
                 allEvents.append(contentsOf: milestone.events)
             }
         }
         
         return allEvents
     }
     
     // MARK: - Group Events by Cadence and Sort by StartTime
     func groupEventsByCadence(events: [Event]) -> [String: [Event]] {
         var groupedEvents: [String: [Event]] = [:]
         
         // Group events by cadence
         for event in events {
             let cadence = event.schedule.regularity.rawValue
             if groupedEvents[cadence] == nil {
                 groupedEvents[cadence] = []
             }
             groupedEvents[cadence]?.append(event)
         }
         
         // Sort events within each cadence by startTime
         for (cadence, eventList) in groupedEvents {
             groupedEvents[cadence] = eventList.sorted { $0.schedule.startTime! < $1.schedule.startTime! }
         }
         
         return groupedEvents
     }
     
     // MARK: - Display Events in ScrollView
     func displayEvents() {
         let eventStackView = EventStack(header: "Header", events: groupedEvents[Cadence.MONTHLY.rawValue]!)
         
         // Create a UIHostingController to host the EventStack SwiftUI view
         let hostingController = UIHostingController(rootView: eventStackView)
         
         // Add the hosting controller as a child view controller
         // Add the hosting controller as a child view controller
         self.addChild(hostingController)
         
         // Add the hosting controller's view to the UIScrollView
         hostingController.view.translatesAutoresizingMaskIntoConstraints = false
         scrollView.addSubview(hostingController.view)
//         var yOffset: CGFloat = 20
//         
//         // Iterate over each cadence group
//         for (cadence, eventsInCadence) in groupedEvents {
//             let cadenceHeader = createCadenceHeader(cadence)
//             scrollView.addSubview(cadenceHeader)
//             yOffset += cadenceHeader.frame.height + 10
//             
//             // Create a card for each event
//             for event in eventsInCadence {
//                 let eventCard = createEventCard(for: event, yOffset: yOffset)
//                 scrollView.addSubview(eventCard)
//                 yOffset += eventCard.frame.height + 10
//             }
//         }
//         
//         // Set contentSize of scrollView so it can scroll
//         scrollView.contentSize = CGSize(width: self.view.frame.width, height: yOffset)
     }
     
     // MARK: - Create Cadence Header
     func createCadenceHeader(_ cadence: String) -> UIView {
         let headerView = UIView()
         let headerLabel = UILabel()
         headerLabel.text = "Cadence: \(cadence)"
         headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
         headerLabel.textColor = .black
         headerLabel.translatesAutoresizingMaskIntoConstraints = false
         headerView.addSubview(headerLabel)
         
         // Constraints for headerLabel
//         NSLayoutConstraint.activate([
//             headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
//             headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//             headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
//             headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
//         ])
         
         return headerView
     }
     
     // MARK: - Create Event Card
     func createEventCard(for event: Event, yOffset: CGFloat) -> UIView {
         let eventCard = UIView()
         eventCard.backgroundColor = .white
         eventCard.layer.cornerRadius = 10
         eventCard.layer.shadowColor = UIColor.black.cgColor
         eventCard.layer.shadowOpacity = 0.1
         eventCard.layer.shadowRadius = 5
         eventCard.layer.shadowOffset = CGSize(width: 0, height: 2)
         
         let stackView = UIStackView()
         stackView.axis = .vertical
         stackView.spacing = 8
         stackView.alignment = .leading
         stackView.translatesAutoresizingMaskIntoConstraints = false
         
         eventCard.addSubview(stackView)
         
         // Constraints for stackView
//         NSLayoutConstraint.activate([
//             stackView.topAnchor.constraint(equalTo: eventCard.topAnchor, constant: 10),
//             stackView.leadingAnchor.constraint(equalTo: eventCard.leadingAnchor, constant: 10),
//             stackView.trailingAnchor.constraint(equalTo: eventCard.trailingAnchor, constant: -10),
//             stackView.bottomAnchor.constraint(equalTo: eventCard.bottomAnchor, constant: -10)
//         ])
         
         let titleLabel = UILabel()
         titleLabel.text = event.title
         titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
         stackView.addArrangedSubview(titleLabel)
         
         // Iterate through the milestones in the goal to display the goal and milestone information
         for goal in goals {
             for milestone in goal.milestones {
                 if milestone.events.contains(event) {
                     let goalLabel = UILabel()
                     goalLabel.text = "Goal: \(goal.title) - Milestone: \(milestone.title)"
                     goalLabel.font = UIFont.systemFont(ofSize: 12)
                     goalLabel.textColor = .gray
                     stackView.addArrangedSubview(goalLabel)
                     break
                 }
             }
         }
         
         let cadenceLabel = UILabel()
         cadenceLabel.text = "Cadence: \(event.schedule.regularity.rawValue)"
         stackView.addArrangedSubview(cadenceLabel)
         
         let startDateLabel = UILabel()
         startDateLabel.text = "Start: \(event.schedule.startTime?.formatted())"
         stackView.addArrangedSubview(startDateLabel)
         
         let endDateLabel = UILabel()
         endDateLabel.text = "End: \(event.schedule.endTime?.formatted())"
         stackView.addArrangedSubview(endDateLabel)
         
         return eventCard
     }
     
     // MARK: - Drag-and-Drop for Reordering Events
     // To make the event cards draggable, you can implement drag-and-drop using gesture recognizers.
     // This can be done using `UICollectionView` with drag-and-drop or custom gestures.
     // Here's a very simple starting point:
     
     func addDragGesture(to view: UIView) {
         let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
         view.addGestureRecognizer(panGesture)
     }
     
     @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
         let translation = sender.translation(in: self.view)
         guard let draggedView = sender.view else { return }
         
         draggedView.center = CGPoint(x: draggedView.center.x + translation.x, y: draggedView.center.y + translation.y)
         sender.setTranslation(.zero, in: self.view)
         
         if sender.state == .ended {
             // Update the event position in the model (groupedEvents) as needed
             // Here you would want to update your event's position based on the drag
         }
     }
    
    
    // MARK: - Save Events to Calendar
    @IBAction func saveEventsToCalendar(_ sender: UIButton) {
        eventStore.requestFullAccessToEvents() { [weak self] (granted, error) in
            guard let self = self else { return }
            
            if granted {
                // Save all events sequentially
                for goal in self.goals {
                    for milestone in goal.milestones {
                        for event in milestone.events {
                            let ekEvent = EKEvent(eventStore: self.eventStore)
                            ekEvent.title = event.title
                            ekEvent.startDate = event.schedule.startTime
                            ekEvent.endDate = event.schedule.endTime
                            ekEvent.calendar = self.eventStore.defaultCalendarForNewEvents
                            
                            do {
                                try self.eventStore.save(ekEvent, span: .thisEvent)
                                print("Event saved: \(ekEvent.title!)")
                            } catch {
                                print("Error saving event: \(error.localizedDescription)")
                            }
                        }
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

    private func showAlert(message: String) {
        AlertUtils.showAlert(in: self, title: "Event Creation Status", message: message)
    }
}
