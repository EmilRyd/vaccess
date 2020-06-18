//
//  ResetPasswordViewController.swift
//  Vaccess
//
//  Created by emil on 2020-06-16.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import Parse

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: MDCTextField!
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
    //MARK: Actions

    @IBAction func resetPassword(_ sender: UIButton) {
        let email = emailTextField.text!
        
        if email.isEmpty {
            //Display message
            return
        }
        
        PFUser.requestPasswordResetForEmail(inBackground: email, block: { (success, error) -> Void in
            
            if error != nil {
                //Display message
            }
            else {
                //Display good message of success
            }
            
            

        })
        
    
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
