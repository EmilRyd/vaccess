//
//  SettingsViewController.swift
//  Vaccess
//
//  Created by emil on 2020-03-04.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    let alertService = AlertService()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundview: UIView!
    var previousVaccinationProgramIndicator: Int!
    
    var vaccinationProgramIndicatorWasInSettingsChangedThisSession: Bool?
    var personalInformationWasChanged = false
    
    var changeWasSelected = false
    
    
    var user = PFUser.current()
    let titles = ["Har genomgått hela vaccinationsprgrammet för barn", "Vill genomgå vaccinationsprogrammet för barn", "Har inte genomgått vaccinationsprogrammet och vill inte göra det"]
    
    
    
    let sectionTitles = ["Vaccinationsprogrammet", "Mina uppgifter", "Kontakt"]
    
    var sectionHeaderHeight: CGFloat = 0.0
    
    //MARK: UITableViewDataSource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0, 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsHeaderTableViewCell") as! SettingsHeaderTableViewCell
        
        cell.setUp(title: sectionTitles[section])
        return cell.contentView
        
        
        
        

        
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cellIdentifierare = "SettingsTableViewCell"

            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? SettingsTableViewCell else {
                fatalError("The dequeued cell is not an instance of SettingsTableViewCell.")
            }
            cell.subjectLabel.text = titles[indexPath.row]
            
            /*switch user?.value(forKey: "VacciantionProgramIndicator") as! Int {
            case 1:
                switch indexPath.row {
                case 0:
                    cell.yesNoSegmentControl
                }
                cell.yesNoSegmentControl
            }*/
            
            let value = user?.value(forKey: "VaccinationProgramIndicator") as? Int
            if value == indexPath.row {
                cell.yesNoSwitch.setOn(true, animated: true)
            }
            else {
                cell.yesNoSwitch.setOn(false, animated: true)
            }
            return cell
        case 1:
            let cellIdentifierare = "SettingsPersonalInformationTableViewCell"

            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? SettingsPersonalInformationTableViewCell else {
                fatalError("The dequeued cell is not an instance of SettingsTableViewCell.")
            }
            
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Min information"
            case 1:
             cell.titleLabel.text = "Datahantering"
            default:
             cell.titleLabel.text = "Inte klar"


            }
            

            return cell
        case 2:
           let cellIdentifierare = "SettingsPersonalInformationTableViewCell"

            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? SettingsPersonalInformationTableViewCell else {
                fatalError("The dequeued cell is not an instance of SettingsTableViewCell.")
            }
           cell.titleLabel.text = "circlevaccess@gmail.com"
           cell.arrowView.isHidden = true
           cell.isUserInteractionEnabled = false
           

           
           
           
           return cell
        default:
            let cell = UITableViewCell()

            
            
            
            return cell
        }
        
        
       
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        vaccinationProgramIndicatorWasInSettingsChangedThisSession = false
        self.view.backgroundColor = .white
        
        sectionHeaderHeight = tableView.dequeueReusableCell(withIdentifier: "SettingsHeaderTableViewCell")?.contentView.bounds.height ?? 0

        backgroundview.backgroundColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 0.5)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    @IBAction func valueForCellChanged(_ sender: UISwitch) {
    
    
       
        
        let alertViewController = alertService.alert(title: "Vill du göra denna ändring?", message: "Denna åtgärd kan orsaka att vaccin du lagt till tidigare tas bort, och att du sedan måste lägga till dem igen om du byter tillbaka.", button1Title: "Ja", button2Title: "Avbryt", alertType: .warning, completionWithAction: { ()  in
         
        
             
             self.previousVaccinationProgramIndicator = (self.user?.object(forKey: "VaccinationProgramIndicator") as? Int) ?? 2
             let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationTabBarController") as! VaccinationTabBarController
             
                         let cell1 = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingsTableViewCell
                         let cell2 = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingsTableViewCell
                         

                         if sender.isOn {
                             if cell1.yesNoSwitch == sender {
                                cell2.yesNoSwitch.setOn(false, animated: true)
                                 self.user?.setObject(0, forKey: "VaccinationProgramIndicator")
                                 self.vaccinationProgramIndicatorWasInSettingsChangedThisSession = true
                             }
                              else if cell2.yesNoSwitch == sender {
                                cell1.yesNoSwitch.setOn(false, animated: true)
                                 self.user?.setObject(1, forKey: "VaccinationProgramIndicator")
                                 
                                 self.vaccinationProgramIndicatorWasInSettingsChangedThisSession = true


                             }
                             
                         }
                         else {
                             self.user?.setObject(2, forKey: "VaccinationProgramIndicator")
                             self.vaccinationProgramIndicatorWasInSettingsChangedThisSession = true

                             
                         }
             
             tabBarController.vaccinationProgramIndicatorWasChangedThisSession = true
             
          
             
                         PFUser.current()?.saveInBackground {
                                    (success: Bool, error: Error?) in
                                      if (success) {
                                        // The object has been saved.
                                      } else {
                                        print (error?.localizedDescription as Any)
                                      }
                                    
                                }
                         
        }, completionWithCancel: { () in
            if !sender.isOn {
                sender.setOn(true, animated: true)

            }
            else {
                sender.setOn(false, animated: true)

            }
        })
        present(alertViewController, animated: true)
        
        
        
        
        
            
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let CPIVC: UINavigationController
            if #available(iOS 13.0, *) {
                CPIVC = storyboard?.instantiateViewController(identifier: "ChangePersonalInformationNavigationController") as! UINavigationController
            } else {
                // Fallback on earlier versions
                CPIVC = storyboard?.instantiateViewController(withIdentifier: "ChangePersonalInformationNavigationController") as! UINavigationController

            }
            CPIVC.modalPresentationStyle = .fullScreen
            //CPIVC.navigationController?.modalPresentationStyle = .fullScreen
            self.present(CPIVC, animated: true, completion: nil)
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            let CIVC: UINavigationController
            if #available(iOS 13.0, *) {
                CIVC = storyboard?.instantiateViewController(identifier: "CompanyInformationNavigationController") as! UINavigationController
            } else {
                // Fallback on earlier versions
                CIVC = storyboard?.instantiateViewController(withIdentifier: "CompanyInformationNavigationController") as! UINavigationController

            }
            CIVC.modalPresentationStyle = .fullScreen
            //CPIVC.navigationController?.modalPresentationStyle = .fullScreen
            self.present(CIVC, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "presentPersonalInformationViewController" {
            let changePersonalInformationViewControllerNavigationController = segue.destination as! UINavigationController
            let changePersonalInformationViewController = changePersonalInformationViewControllerNavigationController.viewControllers[0] as! ChangePersonalInformationViewController
            changePersonalInformationViewControllerNavigationController.modalPresentationStyle = .fullScreen
            changePersonalInformationViewController.modalPresentationStyle = .fullScreen
        }
        
        

        //let loggedInViewController = segue.destination as! LoggedInViewController
       // loggedInViewController.vaccinationProgramIndicatorWasChangedInSettingsThisSession = self.vaccinationProgramIndicatorWasInSettingsChangedThisSession!
        
    }
    
    @IBAction func unwindToSettingsViewController(for segue: UIStoryboardSegue, sender: Any?) {
        //Don´t really know what to do here yet
        var i = 0
        while i < tableView.numberOfSections {
           var x = 0
            while x < tableView.numberOfRows(inSection: i) {
                tableView.cellForRow(at: IndexPath(row: x, section: i))?.isSelected = false
                x += 1
            }
            i += 1
        }
        
        
        guard let changePersonalInformationViewController = segue.source as? ChangePersonalInformationViewController else {
            return
        }
        if changePersonalInformationViewController.informationWasChanged {
            personalInformationWasChanged = true
        }
        
        


        
    }
    
    
    func loadLoggedInScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInScreen = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        
        loggedInScreen.modalPresentationStyle = .fullScreen
        present(loggedInScreen, animated: true, completion: nil)
    }
    
    func changeSegmentControllers() {
        
    }
    
    
    

}
