//
//  SignInViewController.swift
//  Vaccess
//
//  Created by emil on 2019-10-26.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse
class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet fileprivate weak var firstNameTextField: UITextField!
    @IBOutlet fileprivate weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        self.modalPresentationStyle = .fullScreen
        super.viewDidLoad()
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Listen for keyboard events
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
         
         firstNameTextField.delegate = self
        firstNameTextField.tag = 0
         lastNameTextField.delegate = self
        lastNameTextField.tag = 1
        emailTextField.delegate = self
        emailTextField.tag = 2
        passwordTextField.delegate = self
        passwordTextField.tag = 3
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.tag = 4
        

        let tryckGest = UITapGestureRecognizer(target: self, action: #selector(VaccineViewController.tapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tryckGest)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            loadHomeScreen()
        }
    }

    
    deinit {
        //Stop listening to keyboard events

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        
        view.endEditing(true)
        
        
        
    }
    
    
    func loadHomeScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationTabBarController")
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        //Checking some things before signing up
        
        if firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayErrorMessage(message: "Alla fält måste vara ifyllda.")
        }
        
        
        
        if passwordTextField.text! != confirmPasswordTextField.text! {
            displayErrorMessage(message: "Lösenorden matchar inte.")
            return
        }
        
        if passwordTextField.text!.count < 8 {
            displayErrorMessage(message: "Lösenordet måste vara minns 8 karaktärer långt.")
            return
        }
        
        if !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty {
            let user = PFUser()
            user.username = emailTextField.text!
            user.email = emailTextField.text!
            let name = firstNameTextField.text! + " " + lastNameTextField.text!
            user.setObject(name, forKey: "Name")
            user.password = passwordTextField.text!
            let sv = UIViewController.displaySpinner(onView: self.view)
            user.signUpInBackground { (success, error) in
                UIViewController.removeSpinner(spinner: sv)
                if success {
                    self.loadHomeScreen()
                }
                else {
                    if var descrip = error?.localizedDescription {
                        if descrip == "Email address format is invalid." {
                            descrip = "Email-addressen är i felaktigt format."
                        }
                        else if descrip == "bad or missing username" {
                            descrip = "Alla fält måste fyllas i."
                        }
                        else if descrip == "Account already exists for this username." {
                            descrip = "Ett konto med denna email-address finns redan."
                        }
                        
                        self.displayErrorMessage(message: descrip)
                    }
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
