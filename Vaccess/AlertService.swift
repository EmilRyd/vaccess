//
//  AlertService.swift
//  Vaccess
//
//  Created by emil on 2020-03-12.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    
    func alert(title: String, message: String, buttonTitle: String, alertType: AlertViewController.AlertType, completionWithAction: @escaping () -> Void, completionWithCancel: @escaping () -> Void) -> AlertViewController {
        
        let storyBoard = UIStoryboard(name: "AlertStoryBoard", bundle: .main)
        
        let alertViewController = storyBoard.instantiateViewController(identifier: "AlertViewController") as! AlertViewController
        
        alertViewController.alertTitle = title
        
        alertViewController.alertMessage = message
        
        alertViewController.actionButtontitle = buttonTitle
        
        alertViewController.buttonAction = completionWithAction
        
        alertViewController.cancelButtonAction = completionWithCancel
        
        alertViewController.successOrWarning = alertType
        return alertViewController
    }
    
    
    
}
