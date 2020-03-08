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

    @IBOutlet weak var HasNotButWantsToButton: UIButton!
    @IBOutlet weak var hasDoneItButton: UIButton!
    @IBOutlet weak var hasNotDoneItButDoesNotWantToButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HasNotButWantsToButton.titleLabel?.numberOfLines = 5
        hasDoneItButton.titleLabel?.numberOfLines = 4
        hasNotDoneItButDoesNotWantToButton.titleLabel?.numberOfLines = 4
        
        HasNotButWantsToButton.layer.cornerRadius = HasNotButWantsToButton.frame.height/5;
        HasNotButWantsToButton.layer.borderColor = CGColor(srgbRed: 0.108, green: 0.684, blue: 0.356, alpha: 1.0)
        HasNotButWantsToButton.layer.borderWidth = 5
        HasNotButWantsToButton.layer.masksToBounds = true;
        
        hasDoneItButton.layer.cornerRadius = HasNotButWantsToButton.frame.height/5;
        hasDoneItButton.layer.borderColor = CGColor(srgbRed: 0.108, green: 0.684, blue: 0.356, alpha: 1.0)
        hasDoneItButton.layer.borderWidth = 5
        hasDoneItButton.layer.masksToBounds = true;
        
        hasNotDoneItButDoesNotWantToButton.layer.cornerRadius = HasNotButWantsToButton.frame.height/5;
        hasNotDoneItButDoesNotWantToButton.layer.borderColor = CGColor(srgbRed: 0.108, green: 0.684, blue: 0.356, alpha: 1.0)
        hasNotDoneItButDoesNotWantToButton.layer.borderWidth = 5
        hasNotDoneItButDoesNotWantToButton.layer.masksToBounds = true;
        
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
    @IBAction func button1Tapped(_ sender: UIButton) {
        let vaccinationTabBarController = PFObject(className: "VaccinationTabBarController")
        let user = PFUser.current()
       
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationTabBarController") as! VaccinationTabBarController
        let vaccination = Vaccination(vaccine: .Difteri, startDate: Date(), amountOfDosesTaken: 1)
        tabBarController.comingVaccinations.append(vaccination!)
        loadHomeScreen()
    }
    
    @IBAction func button2Tapped(_ sender: UIButton) {
        PFUser.current()?.setValue(2, forKey: "VaccinationProgramIndicator")
        loadHomeScreen()

    }
    
    @IBAction func button3Tapped(_ sender: UIButton) {
        PFUser.current()?.setObject(3, forKey: "VaccinationProgramIndicator")
        loadHomeScreen()

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "button1Tapped":
            print("button1Tapped")
            
            guard let vaccinationTabBarController = segue.destination as? VaccinationTabBarController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            PFUser.current()?.setObject(1, forKey: "VaccinationProgramIndicator")
            
            vaccinationTabBarController.setVaccinationProgramVaccinations()

            vaccinationTabBarController.modalPresentationStyle = .fullScreen
            
             
            
            
        case "button2Tapped":
            print("button2Tapped")
            
            guard let vaccinationTabBarController = segue.destination as? VaccinationTabBarController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            PFUser.current()?.setObject(2, forKey: "VaccinationProgramIndicator")
            
            vaccinationTabBarController.setVaccinationProgramComingVaccinations()

            vaccinationTabBarController.modalPresentationStyle = .fullScreen
            
            
            
       
        default:
            print("Another button tapped")
            
        }
        
        PFUser.current()?.saveInBackground {
            (success: Bool, error: Error?) in
              if (success) {
                // The object has been saved.
              } else {
                print (error?.localizedDescription)
              }
            
        }
    }
    
}
