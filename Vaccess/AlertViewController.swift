//
//  AlertViewController.swift
//  Vaccess
//
//  Created by emil on 2020-03-12.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var alertTitle = String()
    
    var alertMessage = String()
    
    var actionButtontitle = String()
    
    var successOrWarning: AlertType = .error
    
    var buttonAction: (() -> Void)?
    
    var cancelButtonAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        // Do any additional setup after loading the view.
    }
    
    func setUpView() {
        
        self.view.subviews[0].layer.cornerRadius = 10
        
        titleLabel.text = alertTitle
        
        messageLabel.text = alertMessage
        
        actionButton.setTitle(actionButtontitle, for: .normal)
        
        actionButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 15)
        
        cancelButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 15)
        
        switch successOrWarning {
        case .error:
            imageView.image = UIImage(named: "ErrorIcon")
        case .success:
            imageView.image = UIImage(named: "SuccessIcon")
            cancelButton.removeFromSuperview()
             
            // Pin the leading edge of myView to the margin's leading edge
            
        }
    
        
        
    }
    
    enum AlertType {
        case success
        case error
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didtapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        cancelButtonAction?()
        
    }
    @IBAction func didTapActionButton(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)

        buttonAction?()
    }
    
}
