//
//  GoalStack.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 06/03/25.
//

import SwiftUI

struct EventStack: View {
    
    let header: String
    let events: [Event]
    
    var body: some View {
        VStack(spacing: 20) {
            Text(header)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading) // Align this text to leading
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 4) {
                    ForEach(events, id: \.self) { event in EventElement(event: event)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    EventStack(header: "Events", events: Event.sampleEvents())
}
