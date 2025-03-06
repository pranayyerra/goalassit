//
//  GoalElement.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 06/03/25.
//

import SwiftUI

struct GoalElement: View {
    
    @State private var isTapped = false
    let goal: Goal
    
    var body: some View {
        VStack() {
            HStack() {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                ProgressView(value: goal.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(maxWidth: 100, alignment: .leading)
                    .tint(.blue)
                    .padding()
            }
            
            if isTapped {
                VStack(alignment: .leading) {
                    ForEach(goal.milestones, id: \.self) {
                        milestone in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(milestone.title)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color(.systemGray2))
//                .shadow(color: .black.opacity(0.5), radius: 2)
        }
        .onTapGesture {
            isTapped.toggle() // Toggle color on tap
        }
    }
}

#Preview {
    GoalElement(goal: Goal.sampleGoals().first!)
}
