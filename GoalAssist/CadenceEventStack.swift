//
//  GoalStack.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 06/03/25.
//

import SwiftUI

struct CadenceEventStack: View {
    
    var eventsByCadence: [Cadence: [Event]] = [:] // Events grouped by cadence
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 4) {
                    ForEach(Cadence.allCases, id: \.self) { cadence in
                        if eventsByCadence.keys.contains(cadence) { EventStack(header: cadence.rawValue, events: eventsByCadence[cadence]!)
                        }
                    }
                }
            }
            
            Button(action: {
                print("Button tapped!")
            }) {
                Text("Don't Tap Me")
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
    CadenceEventStack(eventsByCadence: [Cadence.DAILY: Event.sampleEvents(), Cadence.WEEKLY: Event.sampleEvents()])
}
