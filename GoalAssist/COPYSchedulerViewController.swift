//
//  COPYSchedulerViewController.swift - ignore for now, but may contain some useful logic that can be reused later on
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 3/6/25.
//

import Foundation
import UIKit
import EventKit

class COPYSchedulerViewController: UIViewController {
    let eventStore = EKEventStore()
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SchedulerViewController successfully launched")
        
        // Assuming you have a data generator for goals
        goals = DataGenerator.goals(count: 5) // Generate 5 random goals
        
        displayGoals()
    }
    
    // MARK: - Display Goals, Milestones, and Events in ScrollView
    func displayGoals() {
        var yOffset: CGFloat = 20
        
        // Loop through each goal
        for goal in goals {
            let goalView = createGoalView(for: goal, yOffset: yOffset)
            scrollView.addSubview(goalView)
            yOffset += goalView.frame.height + 10
        }
        
        // Set contentSize of scrollView so it can scroll
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: yOffset)
    }
    
    // MARK: - Create Goal View
    func createGoalView(for goal: Goal, yOffset: CGFloat) -> UIView {
        let goalView = UIView(frame: CGRect(x: 20, y: yOffset, width: self.view.frame.width - 40, height: 200))
        
        let goalTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: goalView.frame.width, height: 30))
        goalTitleLabel.text = goal.title
        goalTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        goalView.addSubview(goalTitleLabel)
        
        var yOffsetForMilestones: CGFloat = 40
        
        // Loop through each milestone within the goal
        for milestone in goal.milestones {
            let milestoneView = createMilestoneView(for: milestone, yOffset: yOffsetForMilestones)
            goalView.addSubview(milestoneView)
            yOffsetForMilestones += milestoneView.frame.height + 10
        }
        
        goalView.frame.size.height = yOffsetForMilestones
        
        return goalView
    }
    
    // MARK: - Create Milestone View
    func createMilestoneView(for milestone: Milestone, yOffset: CGFloat) -> UIView {
        let milestoneView = UIView(frame: CGRect(x: 0, y: yOffset, width: self.view.frame.width - 40, height: 150))
        
        let milestoneTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: milestoneView.frame.width, height: 30))
        milestoneTitleLabel.text = milestone.title
        milestoneTitleLabel.font = UIFont.systemFont(ofSize: 16)
        milestoneView.addSubview(milestoneTitleLabel)
        
        var yOffsetForEvents: CGFloat = 30
        
        // Loop through each event within the milestone
        for event in milestone.events {
            let eventView = createEventView(for: event, yOffset: yOffsetForEvents)
            milestoneView.addSubview(eventView)
            yOffsetForEvents += eventView.frame.height + 10
        }
        
        milestoneView.frame.size.height = yOffsetForEvents
        
        return milestoneView
    }
    
    // MARK: - Create Event View
    func createEventView(for event: Event, yOffset: CGFloat) -> UIView {
        let eventView = UIView(frame: CGRect(x: 20, y: yOffset, width: self.view.frame.width - 40, height: 120))
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: eventView.frame.width, height: 30))
        titleLabel.text = event.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        eventView.addSubview(titleLabel)
        
        let cadenceLabel = UILabel(frame: CGRect(x: 0, y: 30, width: eventView.frame.width, height: 20))
        cadenceLabel.text = "Cadence: \(event.schedule.regularity.rawValue)"
        cadenceLabel.font = UIFont.systemFont(ofSize: 12)
        eventView.addSubview(cadenceLabel)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 50, width: eventView.frame.width, height: 20))
        dateLabel.text =  "\(dateFormatter.string(from: event.schedule.startTime!)) - \(dateFormatter.string(from: event.schedule.endTime!))"
        eventView.addSubview(dateLabel)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        let timeLabel = UILabel(frame: CGRect(x: 0, y: 80, width: eventView.frame.width, height: 20))
        timeLabel.text = "\(timeFormatter.string(from: event.schedule.startTime!)) - \(timeFormatter.string(from: event.schedule.endTime!))"
        eventView.addSubview(timeLabel)
        
        return eventView
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
