//
//  VaccineHistoryTableViewController.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-10-02.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//
import os.log
import UIKit

class VaccineHistoryTableViewController: UITableViewController, UITextFieldDelegate{

    //MARK: Properties
    var vaccine: Vaccine! = nil
    var vaccinations = [Vaccination]()
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var sourceViewController: UIViewController? = nil
    var sectionsArray = [Vaccination]()
    let datumsFormat = DateFormatter()
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    let dateFormatter = DateFormatter()

    var tableViewWasEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = vaccine.rawValue
        sectionsArray = getArrayWithVaccinationsOfRightType()
        saveButton.isEnabled = false
        
                // Hej Emil! Den 3:e Oktober ska du få in logike nsom bestämmer hur många rader det ska vara i denna tablieView och vad de ska fyllas med! Lycka till, och kom ihåg vad som står på spel! Njut inte bort tiden, utan arbeta!
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sectionsArray.count
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "VaccineHistoryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VaccineHistoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of VaccineHistoryTableViewCell.")
        }
        
        // Fetches the appropriate vaccine for the data source layout.
        let vaccination = sectionsArray[indexPath.row]
        
        // Configure the cell...
        dateFormatter.dateFormat = "dd/MM - yyyy"
        
        
        cell.startdateTextField.text = dateFormatter.string(from: vaccination.startDate)
        cell.startdateTextField.isEnabled = false
        if vaccination.getEndDate() != nil {
            cell.enddateTextField.text = dateFormatter.string(from: vaccination.getEndDate()!)
            cell.enddateTextField.isEnabled = false
        }
        else {
            switch vaccination.vaccine.protection() {
            case .unknown:
                cell.enddateTextField.text = "Obestämt"
            case .lifeLong:
                cell.enddateTextField.text = "Livslångt"
            default:
                fatalError("Inconcsistent Protection attribute")
            }
        }
        self.navigationItem.title = self.vaccine.rawValue

        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let alert = UIAlertController(title: "Vill du ta bort denna vaccinering?", message: "Denna åtgärd kan inte ångras.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Radera", style: .destructive, handler: { action in
                self.sectionsArray = self.getArrayWithVaccinationsOfRightType()
                    
                let vaccinationTabBarController = self.sourceViewController?.tabBarController as! VaccinationTabBarController
                    var allVaccinations = vaccinationTabBarController.allVaccinations
                    
                let indexForThisVaccination = allVaccinations.firstIndex(of: self.sectionsArray[indexPath.row])
                    allVaccinations.remove(at: indexForThisVaccination!)
                    vaccinationTabBarController.allVaccinations = allVaccinations
                    
                   if self.sectionsArray.count == 1 {
                        vaccinationTabBarController.vaccinations.remove(self.sectionsArray[indexPath.row])

                    }

                    
                if indexPath.row == 0 && self.sectionsArray.count > 1 {
                    let index = vaccinationTabBarController.vaccinations.firstIndex(of: self.sectionsArray[indexPath.row])
                    vaccinationTabBarController.vaccinations[index!] = self.sectionsArray[(indexPath.row + 1)]
                }
                self.sectionsArray.remove(at: indexPath.row)

                

            tableView.deleteRows(at: [indexPath], with: .fade)
            
              //  else if editingStyle == .insert {
                    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
                
                //}
            
            
            
          
         //else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //}
     
    
        })
            let alertAction2 = UIAlertAction(title: "Avbryt", style: .cancel, handler: { action in
                return
            })
            alert.addAction(alertAction)
            alert.addAction(alertAction2)
            present(alert, animated: true, completion: nil)
    }
    }
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
   
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === backButton else {
            os_log("The back button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
            
            
        
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = vaccine.rawValue
        sectionsArray = getArrayWithVaccinationsOfRightType()
        
        tableView.reloadData()
    }
    
    //MARK: Private Methods
    
    private func getArrayWithVaccinationsOfRightType() -> [Vaccination] {
        //Returns an array with the all the vaccinations of the type being displayed taken
        
        let vaccinationTabBarController = sourceViewController?.tabBarController as! VaccinationTabBarController
        let allVaccinations = vaccinationTabBarController.allVaccinations
        var sectionsArray = [Vaccination]()
        for i in allVaccinations {
            if i.vaccine.rawValue == navigationItem.title {
                sectionsArray.append(i)
            }
        }
        sectionsArray.sort(by: >)
        
        return sectionsArray
        
    }
   
    
    //MARK: Actions
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        tableViewWasEdited = true
        for index in 0...(sectionsArray.count - 1){
            let vaccineHistoryTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! VaccineHistoryTableViewCell
            vaccineHistoryTableViewCell.startdateTextField.isEnabled = true
            vaccineHistoryTableViewCell.enddateTextField.isEnabled = true
            
            vaccineHistoryTableViewCell.startdateTextField.delegate = self
            vaccineHistoryTableViewCell.enddateTextField.delegate = self
            
        }
       //navigationItem.rightBarButtonItem.title = "Spara"
        

        editButton.isEnabled = false
        saveButton.isEnabled = true
    }
    
    
    @IBAction func saveChanges(_ sender: UIBarButtonItem) {
        
        let vaccinationTabBarController = sourceViewController?.tabBarController as! VaccinationTabBarController
        var allVaccinations = vaccinationTabBarController.allVaccinations
        var x = 0
        for i in sectionsArray {
            let currentTableViewCell = tableView.cellForRow(at: IndexPath(row: x, section: 0)) as! VaccineHistoryTableViewCell
            
            let sDate = dateFormatter.date(from: currentTableViewCell.startdateTextField.text!)
            if sDate != nil && dateFormatter.date(from: currentTableViewCell.enddateTextField.text!) != nil {
                
                let editedVaccinationIndex = allVaccinations.firstIndex(of: i)
                let newVaccination = Vaccination(vaccine: vaccine, startDate: sDate!, amountOfDosesTaken: nil)!
                newVaccination.setEndDate(endDate: dateFormatter.date(from: currentTableViewCell.enddateTextField.text!)!)
                allVaccinations[editedVaccinationIndex!] = newVaccination
                vaccinationTabBarController.allVaccinations = allVaccinations
                
                if x == 0 {
                    var ourVaccinations = vaccinationTabBarController.vaccinations
                    let ourEditedVaccinationIndex = ourVaccinations.firstIndex(of: i)
                    ourVaccinations[ourEditedVaccinationIndex!] = newVaccination
                    vaccinationTabBarController.vaccinations = ourVaccinations
                }
            }
            else {
                let alert = UIAlertController(title: "Kunde inte redigera vaccineringen", message: "Se till att de öndrade datumen står i rätt typsnitt (dd/mm - åååå). Titta efter om du möjligtvis glömt ett mellanslag någonstans.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel)
                alert.addAction(alertAction)
                present(alert, animated: false, completion: nil)
                return
            }
            x += 1
            currentTableViewCell.startdateTextField.isEnabled = false
            currentTableViewCell.enddateTextField.isEnabled = false
        }

        saveButton.isEnabled = false
        editButton.isEnabled = true
        
    }
    
    
    
    
}


