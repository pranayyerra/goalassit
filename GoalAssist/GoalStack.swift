//
//  GoalStack.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 06/03/25.
//

import SwiftUI

struct GoalStack: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Goals")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading) // Align this text to leading
            
            Spacer()
            
//            ForEach(goalId: 0..<5) { _ in
//                GoalElement(goalId)
//            }

            Button(action: {
                print("Button tapped!")
            }) {
                Text("Tap Me")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    GoalStack()
}
