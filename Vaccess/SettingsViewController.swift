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
    var previousVaccinationProgramIndicator: Int!
    
    var vaccinationProgramIndicatorWasInSettingsChangedThisSession: Bool?
    var personalInformationWasChanged = false
    
    var changeWasSelected = false
    
    
    var user = PFUser.current()
    let titles = ["Har genomgått hela vaccinationsprgrammet för barn", "Har inte genomgått vacciantionsprogramet men vill göra det", "Har inte genomgått vaccinationsprogrammet och vill inte göra det"]
    
    let sectionTitles = ["Vaccinationsprogrammet", "Mina uppgifter"]
    
    var sectionHeaderHeight: CGFloat = 0.0
    
    //MARK: UITableViewDataSource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsHeaderTableViewCell") as! SettingsHeaderTableViewCell
        
        cell.setUp(title: sectionTitles[section])
        return cell.contentView
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        let view = UIView()
        view.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.108, green: 0.684, blue: 0.356, alpha: 0.0))
        
        
        let icon = UIImageView(image: UIImage(named: "MinaVaccinationerImage"))
        icon.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(icon)
        
        let label = UILabel()
        
        label.text = sectionTitles[section]
        label.font = UIFont(name: "Futura-Medium", size: 12)
        label.sizeToFit()
        label.frame = CGRect(x: 45, y: 5, width: 200, height: 35)
        view.addSubview(label)
        
        
        
        return view
        
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
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
                cell.yesNoSegmentControl.selectedSegmentIndex = 0
            }
            else {
                cell.yesNoSegmentControl.selectedSegmentIndex = 1
            }
            return cell

        }
        
        if indexPath.section == 1 {
            let cellIdentifierare = "SettingsPersonalInformationTableViewCell"

            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? SettingsPersonalInformationTableViewCell else {
                fatalError("The dequeued cell is not an instance of SettingsTableViewCell.")
            }
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        vaccinationProgramIndicatorWasInSettingsChangedThisSession = false
        self.view.backgroundColor = .clear
        
        sectionHeaderHeight = tableView.dequeueReusableCell(withIdentifier: "SettingsHeaderTableViewCell")?.contentView.bounds.height ?? 0

        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func valueForCell1Changed(_ sender: UISegmentedControl) {
       
        
        let alertViewController = alertService.alert(title: "Vill du göra denna ändring?", message: "Denna åtgärd kan orsaka att vaccin du lagt till tidigare tas bort, och att du sedan måste lägga till dem igen om du byter tillbaka.", buttonTitle: "Ja", alertType: .error, completionWithAction: { ()  in
         
        
             
             self.previousVaccinationProgramIndicator = (self.user?.object(forKey: "VaccinationProgramIndicator") as? Int) ?? 2
             let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let tabBarController = storyBoard.instantiateViewController(withIdentifier: "VaccinationTabBarController") as! VaccinationTabBarController
             
                         let cell1 = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingsTableViewCell
                         let cell2 = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingsTableViewCell
                         let cell3 = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! SettingsTableViewCell

                         if sender.selectedSegmentIndex == 0 {
                             if cell1.yesNoSegmentControl == sender {
                                 cell2.yesNoSegmentControl.selectedSegmentIndex = 1
                                 cell3.yesNoSegmentControl.selectedSegmentIndex = 1
                                 self.user?.setObject(0, forKey: "VaccinationProgramIndicator")
                                 self.vaccinationProgramIndicatorWasInSettingsChangedThisSession = true
                             }
                              else if cell2.yesNoSegmentControl == sender {
                                 cell1.yesNoSegmentControl.selectedSegmentIndex = 1
                                 cell3.yesNoSegmentControl.selectedSegmentIndex = 1
                                 self.user?.setObject(1, forKey: "VaccinationProgramIndicator")
                                 
                                 self.vaccinationProgramIndicatorWasInSettingsChangedThisSession = true


                             }
                             else if cell3.yesNoSegmentControl == sender {
                                 cell2.yesNoSegmentControl.selectedSegmentIndex = 1
                                 cell1.yesNoSegmentControl.selectedSegmentIndex = 1
                                 self.user?.setObject(2, forKey: "VaccinationProgramIndicator")
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
            if sender.selectedSegmentIndex == 1 {
                sender.selectedSegmentIndex = 0

            }
            else {
                sender.selectedSegmentIndex = 1

            }
        })
        present(alertViewController, animated: true)
        
        
        
        
        
            
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
        let changePersonalInformationViewController = segue.source as! ChangePersonalInformationViewController
        if changePersonalInformationViewController.informationWasChanged {
            personalInformationWasChanged = true
        }
        self.tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.isSelected = false
        
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
