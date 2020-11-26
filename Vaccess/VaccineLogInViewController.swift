//
//  VaccineLogInViewController.swift
//  Vaccess
//
//  Created by emil on 2019-10-24.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse
import MaterialComponents
import Lottie


class VaccineLogInViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    let alertService = AlertService()
    @IBOutlet weak var signInEmailTextField: MDCTextField!
    @IBOutlet weak var signInPasswordTextField: MDCTextField!
    @IBOutlet weak var signUpButton: UIButton!
    var activeTextField: UITextField?
    @IBOutlet weak var signInButton: UIButton!
    var signInPasswordTextFieldController: MDCTextInputControllerFilled?
    var signInEmailTextFieldController: MDCTextInputControllerFilled?
    
    
    
    var isLoggedIn = false
    var animationView: AnimationView?
    
    override func viewDidLoad() {
        self.modalPresentationStyle = .fullScreen

        super.viewDidLoad()
        
        
        
        navigationItem.title = "Logga in"
        
        signUpButton.layer.cornerRadius = signUpButton.frame.height/2;
       
            signUpButton.layer.borderColor = Theme.primaryCG
        
            // Fallback on earlier versions
        
        signUpButton.layer.borderWidth = 5
        signUpButton.layer.masksToBounds = true;
        signInButton.layer.cornerRadius = signInButton.frame.height/2;
        signInButton.layer.masksToBounds = true;
        print(signUpButton.titleLabel?.font.fontName)
        
        signInEmailTextField.font = UIFont(name: "Futura-Medium", size: 17.0)
        if #available(iOS 13.0, *) {
            signInEmailTextField.textColor = .label
        } else {
            // Fallback on earlier versions

        }
        
        signInPasswordTextField.font = UIFont(name: "Futura-Medium", size: 17.0)
        if #available(iOS 13.0, *) {
            signInPasswordTextField.textColor = .label
        } else {
            // Fallback on earlier versions

        }
        
        signInEmailTextFieldController = MDCTextInputControllerFilled(textInput: signInEmailTextField)// Hold on as a property
        signInPasswordTextFieldController = MDCTextInputControllerFilled(textInput: signInPasswordTextField)// Hold on as a property
        
        signInEmailTextFieldController?.activeColor = Theme.secondary
        signInEmailTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        signInEmailTextFieldController?.inlinePlaceholderColor = Theme.secondary
        signInEmailTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
               
        signInPasswordTextFieldController?.activeColor = Theme.secondary
        signInPasswordTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        signInPasswordTextFieldController?.inlinePlaceholderColor = Theme.secondary
        signInPasswordTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
        
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
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

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLoggedIn {
            let emptyView = UIView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyView.backgroundColor = .red
            print("Emptyview:  \(emptyView.frame)")
            self.view.addSubview(emptyView)
            //loadHomeScreen()
            emptyView.removeFromSuperview()

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

        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
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
                if (user!["emailVerified"] as? Bool ?? true) == true  {
                    if user?.value(forKey: "VaccinationProgramIndicator") == nil {
                        self.loadVaccinationProgramScreen()
                    }
                    else {
                        self.loadHomeScreen()
                    }
                    
                } else {
                    // User needs to verify email address before continuing
                    
                    
                    let alertViewController = self.alertService.alert(title: "Email-verifiering", message: "Vi har skickat ett email till dig. Vänligen gå dit och verifiera din email-adress", button1Title: "Ok", button2Title: "Skicka om", alertType: .success, completionWithAction: { () in self.processSignOut()}, completionWithCancel: {() in
                        let sv = UIViewController.displaySpinner(onView: self.view)
                        user?.signUpInBackground { (success, error) in
                            UIViewController.removeSpinner(spinner: sv)
                            if success {
                                let alertViewController = self.alertService.alert(title: "Email-verifiering", message: "Vi har skickat ett email till dig. Vänligen gå dit och verifiera din email-adress", button1Title: "Ok", button2Title: "Skicka om", alertType: .success, completionWithAction: { () in self.processSignOut()}, completionWithCancel: {() in})
                                
                                
                                self.present(alertViewController, animated: true)                   // self.loadHomeScreen()
                            }
                            else {
                                if var descrip = error?.localizedDescription {
                                    if descrip == "Email address format is invalid." {
                                        descrip = "Email-adressen är i felaktigt format."
                                    }
                                    else if descrip == "bad or missing username" {
                                        descrip = "Alla fält måste fyllas i."
                                    }
                                    //else if descrip == "Account already exists for this username." {
                                      //  descrip = "Ett konto med denna email-address finns redan."
                                    //}
                                    
                                    self.displayErrorMessage(message: descrip)
                                }
                            }
                        }
                        
                        
                    })
                    
                    
                    self.present(alertViewController, animated: true)
                }
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            if user != nil {
                self.loadHomeScreen()
            }else{
                if var descrip = error?.localizedDescription{
                    if descrip == "username/email is required." {
                        descrip = "Email-adress krävs för att kunna logga in."
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
    
    func loadVaccinationProgramScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationProgramViewController")
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
    
    func processSignOut() {
    
        // // Sign out
        PFUser.logOut()
        
        // Display sign in / up view controller
        
    }

}
