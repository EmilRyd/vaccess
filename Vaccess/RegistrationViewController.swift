//
//  RegistrationViewController.swift
//  Vaccess
//
//  Created by emil on 2019-10-19.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("Sign Up button tapped")
        if (firstNameTextField.text?.isEmpty)! ||
            (surnameTextField.text?.isEmpty)! ||
            (emailTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! ||
            (confirmPasswordTextField.text?.isEmpty)! {
            // Display alert message
            displayMessage(userMessage: "Alla fält måste fyllas i")
            return
            
        }
        
        if ((passwordTextField.text?.elementsEqual(confirmPasswordTextField.text!)) != true) {
            displayMessage(userMessage: "Se till att lösenorden matchar")
            return
        }
        // Fix Activity Indicator
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        
        activityIndicator.center = view.center
        
        activityIndicator.hidesWhenStopped = false
        
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        
        // Send HTTP Request to Register User
        let url = URL(fileURLWithPath: "http://localhost:8080/api/users")
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["firstName": firstNameTextField.text!,
                          "surname": surnameTextField.text!,
                          "email": emailTextField.text!,
                          "password": passwordTextField.text!,]
                          as [String: String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }   catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong. Try again.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: activityIndicator)
            
            if error != nil {
                self.displayMessage(userMessage: "Kunde inte spara informationen. Pröva igen senare.")
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    let userId = parseJSON["userId"] as? String
                    print("User Id: \(String(describing: userId))")
                    
                    
                    if (userId?.isEmpty)! {
                        
                        //Dispay an alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Kunde inte spara informationen. Pröva igen senare.")
                        return
                    }
                    else {
                        self.displayMessage(userMessage: "Du har nu registrerat ett konto hos Vaccess. Fortsätt gärna med att logga in.")
                    }
                    
                }
                
                else {
                    //Display an alert ialog with a friendly error message
                    self.displayMessage(userMessage: "Kunde inte spara informationen. Pröva igen senare.")
                    return
                }
                
            }
            catch {
                self.removeActivityIndicator(activityIndicator: activityIndicator)
                
                //Display an alert dialog with a friendly error message
                self.displayMessage(userMessage: "Kunde inte spara informationen. Pröva igen senare.")
                return
                
            }

        }
        task.resume()

    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        
        DispatchQueue.main.async {
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("Login button tapped")
        self.dismiss(animated: true, completion: nil)
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
    
    func displayMessage(userMessage: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "OBS!", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                //Code in this block will be triggered when the OK button is pressed
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
