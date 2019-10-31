//
//  VaccineLogInViewController.swift
//  Vaccess
//
//  Created by emil on 2019-10-24.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse


class VaccineLogInViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var signInEmailTextField: UITextField!
    @IBOutlet weak var signInPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    var activeTextField: UITextField?
    
    
    var isLoggedIn = false
    
    override func viewDidLoad() {
        self.modalPresentationStyle = .fullScreen

        super.viewDidLoad()
        
        navigationItem.title = "Registrera konto"
        
        signUpButton.layer.cornerRadius = 15;
        signUpButton.layer.masksToBounds = true;
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        signInPasswordTextField.delegate = self
        signInEmailTextField.delegate = self
        
        
        
        let currentUser = PFUser.current()
        if currentUser != nil {
            isLoggedIn = true
        }
        // Do any additional setup after loading the view.
        
        let tryckGest = UITapGestureRecognizer(target: self, action: #selector(VaccineViewController.tapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tryckGest)
        
        signInEmailTextField.delegate = self
        signInEmailTextField.tag = 0
        signInPasswordTextField.delegate = self
        signInPasswordTextField.tag = 1
    }
    
    deinit {
        //Stop listening to keyboard events

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if isLoggedIn {
            loadHomeScreen()

        }
        isLoggedIn = false
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Try to find the next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
    }
        else {
            textField.resignFirstResponder()
        }
    
        return false
    }
    
    
    
    
    
    @objc func keyboardWillChange (notification: Notification) {

        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame  {
            view.frame.origin.y = -50
            
        }
        else {
            view.frame.origin.y = 0
        }
    }
    
    
    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
           
           view.endEditing(true)
           
       }
    
    //MARK: Actions
    
    @IBAction func signIn(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logInWithUsername(inBackground: signInEmailTextField.text!, password: signInPasswordTextField.text!) { (user, error) in
            UIViewController.removeSpinner(spinner: sv)
            if user != nil {
                self.loadHomeScreen()
            }else{
                if var descrip = error?.localizedDescription{
                    if descrip == "username/email is required." {
                        descrip = "Email-address krävs för att kunna logga in."
                    }
                    else if descrip == "password is required." {
                        descrip = "Lösenord krävs."
                    }
                    else if descrip == "Invalid username/password." {
                        descrip = "Kunde inte logga in."
                    }
                    self.displayErrorMessage(message: (descrip))
                }
            }
        }
    }
    

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signInScreen = storyBoard.instantiateViewController(withIdentifier: "SignInViewController")
        signInScreen.modalPresentationStyle = .fullScreen
        self.present(signInScreen, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private methods
    
    func loadHomeScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationTabBarController")
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
        
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
