//
//  LoadingScreenViewController.swift
//  Vaccess
//
//  Created by emil on 2020-05-03.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse
import GhostTypewriter


class LoadingScreenViewController: UIViewController {
    
    
    @IBOutlet weak var vaccessLabel: TypewriterLabel!
    var isLoggedIn = false
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
         super.viewDidLoad()
        self.appDelegate?.requestNotificationAuthorization()
        let currentUser = PFUser.current()
        if currentUser != nil {
            isLoggedIn = true
            
        }
        else {
            isLoggedIn = false
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("We're checking")
        if !UserDefaults.standard.bool(forKey: "hasWatchedWalkthrough")
        {
            // let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
            if let walkthroughViewController = storyboard?.instantiateViewController(identifier: "OnBoardingViewController") as? OnBoardingViewController {
                walkthroughViewController.modalPresentationStyle = .fullScreen
                present(walkthroughViewController, animated: true, completion: nil)
            }
            
            
        }
        vaccessLabel.startTypewritingAnimation {
            if self.isLoggedIn {
                print("Home screen should load")
                self.loadHomeScreen()
                
                
            }
            else {
                print("Log in screen should load")
                
                self.loadLoginScreen()
            }
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
