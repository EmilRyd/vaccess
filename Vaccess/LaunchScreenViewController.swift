//
//  LaunchScreenViewController.swift
//  Vaccess
//
//  Created by emil on 2020-03-18.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse

class LaunchScreenViewController: UIViewController {

    
    var isLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let currentUser = PFUser.current()
        if currentUser != nil {
            isLoggedIn = false
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           if isLoggedIn {
               //loadHomeScreen()
            

           }
           isLoggedIn = false
           
       }
    
    
    func loadHomeScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationTabBarController")
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
