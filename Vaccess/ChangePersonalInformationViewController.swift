//
//  ChangePersonalInformationViewController.swift
//  Vaccess
//
//  Created by emil on 2020-03-09.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import Parse

class ChangePersonalInformationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: MDCTextField!
    @IBOutlet weak var lastNameTextField: MDCTextField!
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var birthDateTextField: MDCTextField!
    @IBOutlet weak var genderTextField: MDCTextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var informationWasChanged: Bool = false
    
    let genderTitlesArray: [String] = ["Man", "Kvinna", "Annat", "Vill inte uppge"]
    
    var birthDatePicker = UIDatePicker()
    var genderPicker = UIPickerView()
    
    let dateFormatter = DateFormatter()
    
    var firstNameTextFieldController: MDCTextInputControllerFilled?
    var lastNameTextFieldController: MDCTextInputControllerFilled?
    var emailTextFieldController: MDCTextInputControllerFilled?
    
    var birthDateTextFieldController: MDCTextInputControllerFilled?
    var genderTextFieldController: MDCTextInputControllerFilled?
    
    var firstName: String!
    var lastName: String!
    var email: String!
    var birthDate: String!
    var gender: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // saveButton.isEnabled = false
        
        dateFormatter.dateFormat = "dd/MM - yyyy"
        
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
        
        
        birthDateTextFieldController?.activeColor = Theme.secondary
        birthDateTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        birthDateTextFieldController?.inlinePlaceholderColor = Theme.secondary
        birthDateTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
        
        genderTextFieldController?.activeColor = Theme.secondary
        genderTextFieldController?.floatingPlaceholderActiveColor = Theme.secondary
        genderTextFieldController?.inlinePlaceholderColor = Theme.secondary
        genderTextFieldController?.floatingPlaceholderNormalColor = Theme.secondary
        
        //Unenable email text field
        emailTextField.isEnabled = false
        
        birthDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            birthDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        birthDatePicker.maximumDate = Date()
        let loc = Locale(identifier: "sv")
        birthDatePicker.locale = loc
        // Se till att textrutan påverkas när datumet ändras av användaren
        birthDatePicker.addTarget(self, action: #selector(VaccineViewController.dateChanged(datumVäljare:)), for: .valueChanged)
        
        // Gör det möjligt för användaren att stänga av väljaren
        
        
        // Sätt datumVäljare som input till textrutan
        birthDateTextField.inputView = birthDatePicker
        genderTextField.inputView = genderPicker
        
        genderPicker.delegate = self
        
        
        firstNameTextField.delegate = self
        firstNameTextField.tag = 0
         lastNameTextField.delegate = self
        lastNameTextField.tag = 1
        emailTextField.delegate = self
        emailTextField.tag = 2
        birthDateTextField.tag = 3
        birthDateTextField.delegate = self
        genderTextField.delegate = self
        genderTextField.tag = 4
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tryckGest = UITapGestureRecognizer(target: self, action: #selector(VaccineViewController.tapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tryckGest)
        
        
        
        
        
        
        
        let user = PFUser.current()
        
        let fullNameString = user?.object(forKey: "Name") as? String ?? "Vildsvin"
        var array = Array(fullNameString)
        var firstNameArray: [Character] = []
        for i in fullNameString {
            if i == " " {
                array.remove(i)
                break
            }
            else {
                firstNameArray.append(i)
                array.remove(i)
            }
        }
        firstName = String(firstNameArray)
        lastName = String(array)
        
        
        
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        emailTextField.text = user?.username
        email = emailTextField.text!
        
        birthDateTextField.text = dateFormatter.string(from: (user?.object(forKey: "birthDate") as! Date))
        birthDate = birthDateTextField.text!
        genderTextField.text = user?.object(forKey: "Gender") as? String
        gender = genderTextField.text!
        
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    deinit {
        //Stop listening to keyboard events

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    
    
    @objc func keyboardWillChange (notification: Notification) {

          
        /*guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
              return
          }*/
          
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification  {
              view.frame.origin.y = -38 //50
              
          }
          else {
              view.frame.origin.y = 0
          }
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
        return genderTitlesArray.count
        
        
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
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField){
        var string: String = ""
        switch textField.tag {
        case 0:
            string = firstName
            case 1:
            string = lastName
            case 2:
            string = email
            case 3:
            string = birthDate
            case 4:
            string = gender
        default:
            break
        }
        if string != textField.text {
           // saveButton.isEnabled = true
        }
        else {
            //saveButton.isEnabled = false
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        var string: String = ""
        switch textField.tag {
        case 0:
            string = firstName
            case 1:
            string = lastName
            case 2:
            string = email
            case 3:
            string = birthDate
            case 4:
            string = gender
        default:
            break
        }
        if string != textField.text {
            //saveButton.isEnabled = true
        }
        else {
            //saveButton.isEnabled = false
        }
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
            if firstNameTextField.text != firstName {
                informationWasChanged = true
            }
        
            if lastNameTextField.text != lastName {
                informationWasChanged = true
            }
        
            if emailTextField.text != email {
                informationWasChanged = true
            }
            if birthDateTextField.text != birthDate {
                informationWasChanged = true
            }
            if genderTextField.text != gender {
                informationWasChanged = true
            }
        
        
        if informationWasChanged {
            if firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty || emailTextField.text!.isEmpty  || genderTextField.text!.isEmpty {
                displayErrorMessage(message: "Alla fält måste vara ifyllda.")
            }
            
            
            
            
            
            
            
            if !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty && !birthDateTextField.text!.isEmpty {
                let user = PFUser.current()
                //user!.username = emailTextField.text!
                //user!.email = emailTextField.text!
                let name = firstNameTextField.text! + " " + lastNameTextField.text!
                user!.setObject(name, forKey: "Name")
                //user!.setObject(emailTextField.text!, forKey: "User")
                user!.setObject(dateFormatter.date(from: birthDateTextField.text!)!, forKey: "birthDate")
                user!.setObject(genderTextField.text!, forKey: "Gender")
                let sv = UIViewController.displaySpinner(onView: self.view)
                user!.saveInBackground { (success, error) in
                    UIViewController.removeSpinner(spinner: sv)
                    if success {
                        return
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
        
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        
            // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
            

        
        
        if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
       else {
            dismiss(animated: true, completion: nil)

        }
            
            
        
    
    }
    
    
    //MARK: Private functions
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
