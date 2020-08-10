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
    
    
    let alertService = AlertService()

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
        let query = PFQuery(className: "VaccinationTabBarController")
        let updatedQuery = query.whereKey("user", equalTo: email)
        var objects: [PFObject]? = nil
        
        do {
            objects = try updatedQuery.findObjects()
            
        }
        catch {
            
        }
        if objects == nil {
            print("FRAUD!")
            return
        }
        self.recursivelyRequestPassword(email: email)
                
    
    }
    
    func recursivelyRequestPassword(email: String) {
        PFUser.requestPasswordResetForEmail(inBackground: email, block: { (success, error) -> Void in
            
            if error != nil {
                //Display message
                let alertViewController = self.alertService.alert(title: "Email-adress inte igenkänd", message: "Email-adressen du skrivs inte igen har inget konto.", button1Title: "Ok", button2Title: nil, alertType: .error, completionWithAction: {
                    () in
                    
                }, completionWithCancel: {
                    () in
                })
                self.present(alertViewController, animated: true)

            }
            else {
                //Display good message of success
                let alertViewController = self.alertService.alert(title: "Email skickat", message: "Ett mail har skickats till din mail-adress.", button1Title: "Skicka om", button2Title: nil, alertType: .twobuttonsuccess, completionWithAction: {
                    () in
                    
                    self.recursivelyRequestPassword(email: email)
                    
                }, completionWithCancel: {
                    () in
                })
                self.present(alertViewController, animated: true)

            }
            
            

        })

    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
