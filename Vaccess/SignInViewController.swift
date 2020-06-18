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
    let genderTitlesArray: [String] = ["Man", "Kvinna"]
    
    
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
        signInButton.layer.borderColor = CGColor(srgbRed: 0.108, green: 0.684, blue: 0.356, alpha: 1.0)
        signInButton.layer.cornerRadius = signInButton.frame.height/2
        
        firstNameTextField.font = UIFont(name: "Futura-Medium", size: 15.0)
        lastNameTextField.font = UIFont(name: "Futura-Medium", size: 15)
        emailTextField.font = UIFont(name: "Futura-Medium", size: 15.0)
        passwordTextField.font = UIFont(name: "Futura-Medium", size: 15.0)
        confirmPasswordTextField.font = UIFont(name: "Futura-Medium", size: 15)
        birthDateTextField.font = UIFont(name: "Futura-Medium", size: 15)

        
        firstNameTextFieldController = MDCTextInputControllerFilled(textInput: firstNameTextField)// Hold on as a property
        lastNameTextFieldController = MDCTextInputControllerFilled(textInput: lastNameTextField)// Hold on as a property
        emailTextFieldController = MDCTextInputControllerFilled(textInput: emailTextField)// Hold on as a property
        passwordTextFieldController = MDCTextInputControllerFilled(textInput: passwordTextField)// Hold on as a property
        confirmPasswordTextFieldController = MDCTextInputControllerFilled(textInput: confirmPasswordTextField)// Hold on as a property
         birthDateTextFieldController = MDCTextInputControllerFilled(textInput: birthDateTextField)// Hold on as a property
        genderTextFieldController = MDCTextInputControllerFilled(textInput: genderTextField)// Hold on as a property
        
        lastNameTextFieldController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        lastNameTextFieldController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        firstNameTextFieldController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        firstNameTextFieldController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        emailTextFieldController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        emailTextFieldController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        passwordTextFieldController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        passwordTextFieldController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        confirmPasswordTextFieldController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        confirmPasswordTextFieldController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        birthDateTextFieldController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        birthDateTextFieldController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        genderTextFieldController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        genderTextFieldController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        
        birthDatePicker.datePickerMode = .date
        
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
        return 2
        
        
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
                    let alertViewController = self.alertService.alert(title: "Email-verifiering", message: "Vi har skickat ett email till dig. Vänligen gå ditt och verifiera din email-address", buttonTitle: "Ok", alertType: .success, completionWithAction: { () in self.processSignOut()}, completionWithCancel: {() in})
                    
                    
                    self.present(alertViewController, animated: true)                   // self.loadHomeScreen()
                }
                else {
                    if var descrip = error?.localizedDescription {
                        if descrip == "Email address format is invalid." {
                            descrip = "Email-addressen är i felaktigt format."
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
        
        let alertViewController = alertService.alert(title: "Error!", message: message, buttonTitle: "Ok", alertType: .error, completionWithAction: { ()in}, completionWithCancel: { ()in})
        
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VaccineLogInViewController") as! VaccineLogInViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}
