//
//  SignInViewController.swift
//  Vaccess
//
//  Created by emil on 2019-10-26.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse
import MaterialComponents



class SignInViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    let alertService = AlertService()
    @IBOutlet weak var firstNameTextField: MDCTextField!
    @IBOutlet weak var lastNameTextField: MDCTextField!
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var confirmPasswordTextField: MDCTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var birthDateTextField: MDCTextField!
    @IBOutlet weak var genderTextField: MDCTextField!
    
    var firstNameTextFieldController: MDCTextInputControllerFilled?
    var lastNameTextFieldController: MDCTextInputControllerFilled?
    var emailTextFieldController: MDCTextInputControllerFilled?
    var passwordTextFieldController: MDCTextInputControllerFilled?
    var confirmPasswordTextFieldController: MDCTextInputControllerFilled?
    var birthDateTextFieldController: MDCTextInputControllerFilled?
    var genderTextFieldController: MDCTextInputControllerFilled?
    var birthDatePicker = UIDatePicker()
    var genderPicker = UIPickerView()
    let dateFormatter = DateFormatter()
    let genderTitlesArray: [String] = ["Man", "Kvinna", "Annat", "Vill inte uppge"]
    
    
    
    override func viewDidLoad() {
        self.modalPresentationStyle = .fullScreen
        super.viewDidLoad()
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        
        
        //Fix some layout
        signUpButton.layer.cornerRadius = signUpButton.frame.height/2
        signInButton.layer.borderWidth = 5
        
            signInButton.layer.borderColor = Theme.primaryCG
    
            // Fallback on earlier versions
        
        signInButton.layer.cornerRadius = signInButton.frame.height/2
        
        firstNameTextField.font = UIFont(name: "Futura-Medium", size: 15.0)
        if #available(iOS 13.0, *) {
            firstNameTextField.textColor = .label
        } else {
            // Fallback on earlier versions

        }
        
        lastNameTextField.font = UIFont(name: "Futura-Medium", size: 15)
        if #available(iOS 13.0, *) {
            lastNameTextField.textColor = .label
        } else {
            // Fallback on earlier versions

        }
        
        emailTextField.font = UIFont(name: "Futura-Medium", size: 15.0)
        if #available(iOS 13.0, *) {
            emailTextField.textColor = .label
        } else {
            // Fallback on earlier versions

        }
        
        passwordTextField.font = UIFont(name: "Futura-Medium", size: 15.0)
        if #available(iOS 13.0, *) {
            passwordTextField.textColor = .label
        } else {
            // Fallback on earlier versions

        }
        
        confirmPasswordTextField.font = UIFont(name: "Futura-Medium", size: 15)
        if #available(iOS 13.0, *) {
            confirmPasswordTextField.textColor = .label
        } else {
            // Fallback on earlier versions

        }
        
        birthDateTextField.font = UIFont(name: "Futura-Medium", size: 15)
        if #available(iOS 13.0, *) {
            birthDateTextField.textColor = .label
        } else {
            // Fallback on earlier versions

        }
        
        genderTextField.font = UIFont(name: "Futura-Medium", size: 15)
        if #available(iOS 13.0, *) {
            genderTextField.textColor = .label
        } else {
            // Fallback on earlier versions

        }
        
        
        firstNameTextFieldController = MDCTextInputControllerFilled(textInput: firstNameTextField)// Hold on as a property
        lastNameTextFieldController = MDCTextInputControllerFilled(textInput: lastNameTextField)// Hold on as a property
        emailTextFieldController = MDCTextInputControllerFilled(textInput: emailTextField)// Hold on as a property
        passwordTextFieldController = MDCTextInputControllerFilled(textInput: passwordTextField)// Hold on as a property
        confirmPasswordTextFieldController = MDCTextInputControllerFilled(textInput: confirmPasswordTextField)// Hold on as a property
         birthDateTextFieldController = MDCTextInputControllerFilled(textInput: birthDateTextField)// Hold on as a property
        genderTextFieldController = MDCTextInputControllerFilled(textInput: genderTextField)// Hold on as a property
        
        lastNameTextFieldController?.activeColor = Theme.secondary
        lastNameTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        lastNameTextFieldController?.inlinePlaceholderColor = Theme.secondary
        lastNameTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
        
        firstNameTextFieldController?.activeColor = Theme.secondary
        firstNameTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        firstNameTextFieldController?.inlinePlaceholderColor = Theme.secondary
        firstNameTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
        
        emailTextFieldController?.activeColor = Theme.secondary
        emailTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        emailTextFieldController?.inlinePlaceholderColor = Theme.secondary
        emailTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
        
        passwordTextFieldController?.activeColor = Theme.secondary
        passwordTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        passwordTextFieldController?.inlinePlaceholderColor = Theme.secondary
        passwordTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
        
        confirmPasswordTextFieldController?.activeColor = Theme.secondary
        confirmPasswordTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        confirmPasswordTextFieldController?.inlinePlaceholderColor = Theme.secondary
        confirmPasswordTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
        
        birthDateTextFieldController?.activeColor = Theme.secondary
        birthDateTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        birthDateTextFieldController?.inlinePlaceholderColor = Theme.secondary
        birthDateTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
        
        genderTextFieldController?.activeColor = Theme.secondary
        genderTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        genderTextFieldController?.inlinePlaceholderColor = Theme.secondary
        genderTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
        
        birthDatePicker.datePickerMode = .date
        birthDatePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            birthDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        let loc = Locale(identifier: "sv")
        birthDatePicker.locale = loc
        // Se till att textrutan påverkas när datumet ändras av användaren
        birthDatePicker.addTarget(self, action: #selector(VaccineViewController.dateChanged(datumVäljare:)), for: .valueChanged)
        
        // Gör det möjligt för användaren att stänga av väljaren
        
        
        // Sätt datumVäljare som input till textrutan
        birthDateTextField.inputView = birthDatePicker
        genderTextField.inputView = genderPicker

        genderPicker.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
         
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
            //loadHomeScreen()
        }
    }

    
    deinit {
        //Stop listening to keyboard events

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
          
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification  {
              view.frame.origin.y = -38 //50
              
          }
          else {
              view.frame.origin.y = 0
          }
      }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UIDatePicker methods
    @objc func dateChanged (datumVäljare: UIDatePicker) {
        
        dateFormatter.dateFormat = "dd/MM - yyyy"
        
        birthDateTextField.text = dateFormatter.string(from: datumVäljare.date)
        
        
        
        
        
    }
    
    
    //MARK: UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderTitlesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genderTitlesArray[row]
        
        
    }

    

    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        
        view.endEditing(true)
        
        
        
    }
    
    
    func loadHomeScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vaccinationProgramViewController = storyBoard.instantiateViewController(withIdentifier: "VaccinationProgramViewController")
        vaccinationProgramViewController.modalPresentationStyle = .fullScreen
        self.present(vaccinationProgramViewController, animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        //Checking some things before signing up
        
        if firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty || genderTextField.text!.isEmpty {
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
        
        if !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty && !birthDateTextField.text!.isEmpty {
            let user = PFUser()
            user.username = emailTextField.text!
            user.email = emailTextField.text!
            let name = firstNameTextField.text! + " " + lastNameTextField.text!
            user.setObject(name, forKey: "Name")
            user.setObject(emailTextField.text!, forKey: "User")
            user.password = passwordTextField.text!
            user.setObject(dateFormatter.date(from: birthDateTextField.text!)!, forKey: "birthDate")
            user.setObject(genderTextField.text!, forKey: "Gender")
            let sv = UIViewController.displaySpinner(onView: self.view)
            user.signUpInBackground { (success, error) in
                UIViewController.removeSpinner(spinner: sv)
                if success {
                    let alertViewController = self.alertService.alert(title: "Email-verifiering", message: "Vi har skickat ett email till dig. Vänligen gå dit och verifiera din email-adress", button1Title: "Ok", button2Title: nil, alertType: .success, completionWithAction: { () in self.processSignOut()}, completionWithCancel: {() in})
                    
                    
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
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("Login button tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func displayErrorMessage(message: String) {
        
        let alertViewController = alertService.alert(title: "Error!", message: message, button1Title: "Ok", button2Title: nil, alertType: .error, completionWithAction: { ()in}, completionWithCancel: { ()in})
        self.present(alertViewController, animated: true)
        /*let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            
        }
        
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion: nil)*/
    }
    
    func processSignOut() {
    
        // // Sign out
        PFUser.logOut()
        
        // Display sign in / up view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VaccineLogInViewController") as! VaccineLogInViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}
