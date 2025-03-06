//
//  GoalElement.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 06/03/25.
//

import SwiftUI

struct EventElement: View {
    
    let event: Event
//    let milestone: Milestone
//    let goal: Goal
    
    var body: some View {
        VStack() {

        Text(event.title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
        Spacer()
//                Text("\(goal.title): \(milestone.title)")
//                    .font(.headline)
//                    .foregroundColor(.red)
//                Spacer()
            Text("\(formatTime(date: event.schedule.startTime!)) - \(formatTime(date: event.schedule.endTime!))")
            .font(.subheadline)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color(.systemGray2))
//                .shadow(color: .black.opacity(0.5), radius: 2)
        }
    }
}

func formatTime(date: Date) -> String {
    let timeFormatter = DateFormatter()
    timeFormatter.dateStyle = .none
    timeFormatter.timeStyle = .short
    
    return timeFormatter.string(from: date)
}

#Preview {
//    EventElement(event: Event.sampleEvents().first!, milestone: Milestone.sampleMilestones().first!, goal: Goal.sampleGoals().first!)
    EventElement(event: Event.sampleEvents().first!)
}
