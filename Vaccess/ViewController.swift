//
//  ViewController.swift
//  QuickStartExampleApp
//
//  Created by Joren Winge on 11/8/17.
//  Copyright © 2017 Back4App. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var signInUsernameField: UITextField!
    @IBOutlet fileprivate weak var signInPasswordField: UITextField!
    @IBOutlet fileprivate weak var signUpUsernameField: UITextField!
    @IBOutlet fileprivate weak var signUpPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInUsernameField.text = ""
        signInPasswordField.text = ""
        signUpUsernameField.text = ""
        signUpPasswordField.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            loadHomeScreen()
        }
    }

    func loadHomeScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationTabBarController")
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let user = PFUser()
        user.username = signUpUsernameField.text
        user.password = signUpPasswordField.text
        let sv = UIViewController.displaySpinner(onView: self.view)
        user.signUpInBackground { (success, error) in
            UIViewController.removeSpinner(spinner: sv)
            if success {
                self.loadHomeScreen()
            }
            else {
                if let descrip = error?.localizedDescription {
                    self.displayErrorMessage(message: descrip)
                }
            }
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logInWithUsername(inBackground: signInUsernameField.text!, password: signInPasswordField.text!) { (user, error) in
            
            UIViewController.removeSpinner(spinner: sv)
            if user != nil {
                self.loadHomeScreen()
            }
            else {
                if let descrip = error?.localizedDescription {
                    self.displayErrorMessage(message: descrip)
                }
            }
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("Login button tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayErrorMessage(message: String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            
        }
        
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion: nil)
    }
}

