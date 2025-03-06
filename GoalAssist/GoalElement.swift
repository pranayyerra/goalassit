//
//  GoalElement.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 06/03/25.
//

import SwiftUI

struct GoalElement: View {
    
    let goal: Goal
    
    var body: some View {
        VStack() {
            HStack() {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                Text(goal.milestones.count)
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            ProgressView(value: 0.5)
                .padding()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color(.systemGray2))
                .shadow(color: .black.opacity(0.5), radius: 2)
        }
    }
}

#Preview {
    GoalElement(goal: Goal.sampleGoals().first!)
}
