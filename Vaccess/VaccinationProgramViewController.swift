//
//  VaccinationProgramViewController.swift
//  Vaccess
//
//  Created by emil on 2020-02-21.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse

class VaccinationProgramViewController: UIViewController {

    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    
    @IBOutlet weak var switch2Label: UILabel!
    
    override func viewDidLoad() {
        switch2.isHidden = true
        switch2Label.isHidden = true
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func switch1ChangedValue(_ sender: UISwitch) {
        if !switch1.isOn {
            switch2.isHidden = false
            switch2Label.isHidden = false
        }
        else {
            switch2.isHidden = true
            switch2Label.isHidden = true
        }
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if switch1.isOn && switch2.isHidden {
            print("button1Tapped")
            
            guard let vaccinationTabBarController = segue.destination as? VaccinationTabBarController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            PFUser.current()?.setObject(0, forKey: "VaccinationProgramIndicator")
            
            vaccinationTabBarController.setVaccinationProgramVaccinations()

            vaccinationTabBarController.modalPresentationStyle = .fullScreen
            
        }
        else if switch2.isOn {
            print("button2Tapped")
                       
                       guard let vaccinationTabBarController = segue.destination as? VaccinationTabBarController else {
                           fatalError("Unexpected destination: \(segue.destination)")
                       }
                       
                       PFUser.current()?.setObject(1, forKey: "VaccinationProgramIndicator")
                       
                       vaccinationTabBarController.setVaccinationProgramComingVaccinations()

                       vaccinationTabBarController.modalPresentationStyle = .fullScreen
        }
        
        else if !switch2.isOn {
            print("Another button tapped")

            
            guard let vaccinationTabBarController = segue.destination as? VaccinationTabBarController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            PFUser.current()?.setObject(2, forKey: "VaccinationProgramIndicator")
            
            vaccinationTabBarController.setVaccinationProgramComingVaccinations()

            vaccinationTabBarController.modalPresentationStyle = .fullScreen
        }
            
            
        
           
            
            
            
       
        
            
        
        PFUser.current()?.saveInBackground {
            (success: Bool, error: Error?) in
              if (success) {
                // The object has been saved.
              } else {
                print (error?.localizedDescription as Any)
              }
            
        }
    }
    
    
    
}
