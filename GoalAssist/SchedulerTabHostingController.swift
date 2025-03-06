//
//  SchedulerViewController.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 3/7/25.
//

import UIKit
import SwiftUI

class SchedulerTabHostingController: UIHostingController<CadenceEventStack> {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: CadenceEventStack(eventsByCadence: [Cadence.DAILY: Event.sampleEvents(), Cadence.WEEKLY: Event.sampleEvents()]))
    }

}
