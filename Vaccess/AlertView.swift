//
//  AlertView.swift
//  Vaccess
//
//  Created by emil on 2020-03-11.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import Foundation
import UIKit

class AlertView: UIView {
    
    //static let instance = AlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deterButton: UIButton!
    var completionHandler: (() -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    
     init(frame: CGRect, handler: (() -> Void)?) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)
        completionHandler = handler

        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)

        commonInit()
    }
    
    
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    
    
    
    private func commonInit() {
        image.layer.cornerRadius = 30
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        
        alertView.layer.cornerRadius  = 10
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
    
    }
    enum AlertType {
        case success
        case error
    }
    
    func showAlert(title: String, message: String, alertType: AlertType) {
        
        self.titleLabel.text = title
        self.messageLabel.text = message

        switch alertType {
        case .success:
            image.image = UIImage(named: "SuccessIcon")
            doneButton.backgroundColor = Theme.primary
            deterButton.removeFromSuperview()
            let margins = alertView.layoutMarginsGuide
             
            // Pin the leading edge of myView to the margin's leading edge
            doneButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
            
            
            
        case .error:
            image.image = UIImage(named: "ErrorIcon")
            doneButton.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1.0)
            
            
                            
        }
        
        //UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        if completionHandler != nil {
            completionHandler!()

        }
        self.superview!.superview!.removeFromSuperview()

        
    }
   
}
