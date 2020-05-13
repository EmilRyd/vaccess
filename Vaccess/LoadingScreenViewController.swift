//
//  LoadingScreenViewController.swift
//  Vaccess
//
//  Created by emil on 2020-05-03.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse
class LoadingScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*let currentUser = PFUser.current()
        if currentUser != nil {
            loadHomeScreen()
        }
        else {
            loadLoginScreen()
        }*/
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("We're checking")
        let currentUser = PFUser.current()
        if currentUser != nil {
            print("Home screen should load")
            loadHomeScreen()
        }
        else {
            print("Log in screen should load")

            loadLoginScreen()
        }
    }
    
    func loadHomeScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationTabBarController")
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
        
    }
    
    func loadLoginScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccineLogInViewController")
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
