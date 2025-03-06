//
//  AlertUtils.swift
//  GoalAssist
//
//  Created by Pranay Hasan Yerra on 3/6/25.
//

import Foundation
import UIKit

class AlertUtils {
    
    static func showAlert(in viewController: UIViewController, title: String, message: String) {
        
        // Create the alert controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the action for the button
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        // Add the action to the alert
        alert.addAction(action)

        // Present the alert
        viewController.present(alert, animated: true, completion: nil)
    }
}
