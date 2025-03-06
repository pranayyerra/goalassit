//
//  DetailsTabHostingController.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 06/03/25.
//

import UIKit
import SwiftUI

class DetailsTabHostingController: UIHostingController<GoalStack> {
    required init?(coder: NSCoder) {
            super.init(coder: coder, rootView: GoalStack())
        }
}
