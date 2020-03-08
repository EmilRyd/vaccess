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
    @IBOutlet weak var tableView: UITableView!
    var previousVaccinationProgramIndicator: Int!
    
    var vaccinationProgramIndicatorWasInSettingsChangedThisSession: Bool?
    var user = PFUser.current()
    let titles = ["Har genomgått hela vaccinationsprgrammet för barn", "Har inte genomgått vacciantionsprogramet men vill göra det", "Har inte genomgått vaccinationsprogrammet och vill inte göra det"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        let value = user?.value(forKey: "VaccinationProgramIndicator") as! Int
        if value == indexPath.row {
            cell.yesNoSegmentControl.selectedSegmentIndex = 0
        }
        else {
            cell.yesNoSegmentControl.selectedSegmentIndex = 1
        }
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        vaccinationProgramIndicatorWasInSettingsChangedThisSession = false
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func valueForCell1Changed(_ sender: UISegmentedControl) {
        
        let alert = UIAlertController(title: "Vill du göra denna ändring?", message: "Denna åtgärd kan orsaka att vaccin du lagt till tidigare tas bort, och att du sedan måste lägga till dem igen om du byter tillbaka.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ja", style: .cancel, handler: { action in
            
            self.previousVaccinationProgramIndicator = self.user?.object(forKey: "VaccinationProgramIndicator") as! Int
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
                                       print (error?.localizedDescription)
                                     }
                                   
                               }
                        
        })
                
                let alertAction2 = UIAlertAction(title: "Avbryt", style: .default, handler: { action in
                    
                    if sender.selectedSegmentIndex == 1 {
                        sender.selectedSegmentIndex = 0
                    }
                    else {
                        sender.selectedSegmentIndex = 1
                    }
                    return
                    })
                
                alert.addAction(alertAction)
                alert.addAction(alertAction2)
                present(alert, animated: true, completion: nil)
        
        
        
            
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let loggedInViewController = segue.destination as! LoggedInViewController
        loggedInViewController.vaccinationProgramIndicatorWasChangedInSettingsThisSession = self.vaccinationProgramIndicatorWasInSettingsChangedThisSession!
        
    }
    
    func loadLoggedInScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInScreen = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        
        loggedInScreen.modalPresentationStyle = .fullScreen
        present(loggedInScreen, animated: true, completion: nil)
    }
    

}
