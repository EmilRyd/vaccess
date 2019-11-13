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
    var amountOfSections: Int = 1
    var rowsInEachSection: [Int] = [0]
    var amountOfVaccinationsLoaded: Int = 0
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
        groupVaccinations(sectionsArray: sectionsArray)
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
        
        return amountOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return rowsInEachSection[section]
        
        /*else {
            return sectionsArray.count
        }*/
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Omgång \(amountOfSections - section)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "VaccineHistoryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VaccineHistoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of VaccineHistoryTableViewCell.")
        }
        
        // Fetches the appropriate vaccine for the data source layout.
        let vaccination = sectionsArray[amountOfVaccinationsLoaded]
        
        // Configure the cell...
        dateFormatter.dateFormat = "dd/MM - yyyy"
        let doses = vaccination.amountOfDosesTaken ?? 1
        cell.doseTextField.text = String(doses)
        cell.startdateTextField.text = dateFormatter.string(from: vaccination.startDate)
        cell.startdateTextField.isEnabled = false
        if vaccination.getEndDate(amountOfDosesTaken: vaccination.amountOfDosesTaken) != nil {
            cell.enddateTextField.text = dateFormatter.string(from: vaccination.getEndDate(amountOfDosesTaken: vaccination.amountOfDosesTaken)!)
            cell.enddateTextField.isEnabled = false
        }
        else {
            switch vaccination.vaccine.protection(amountOfDosesTaken: nil) {
            case .unknown:
                cell.enddateTextField.text = "Obestämt"
            case .lifeLong:
                cell.enddateTextField.text = "Livslångt"
            default:
                fatalError("Inconcsistent Protection attribute")
            }
        }
        self.navigationItem.title = self.vaccine.rawValue

        amountOfVaccinationsLoaded += 1
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
            let index = returnPositionForThisIndexPath(indexPath: indexPath, insideThisTable: self.tableView)
            
            let alert = UIAlertController(title: "Vill du ta bort denna vaccinering?", message: "Denna åtgärd kan inte ångras.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Radera", style: .destructive, handler: { action in
                self.sectionsArray = self.getArrayWithVaccinationsOfRightType()
                    
                let vaccinationTabBarController = self.sourceViewController?.tabBarController as! VaccinationTabBarController
                    var allVaccinations = vaccinationTabBarController.allVaccinations
                    
                let indexForThisVaccination = allVaccinations.firstIndex(of: self.sectionsArray[index])
                    allVaccinations.remove(at: indexForThisVaccination!)
                    vaccinationTabBarController.allVaccinations = allVaccinations
                    
                if self.rowsInEachSection[indexPath.section] == 1 && indexPath.section == 0 {
                    if self.sectionsArray[index].amountOfDosesTaken! < self.sectionsArray[index].vaccine.getTotalAmountOfDoses() {
                        vaccinationTabBarController.ongoingVaccinations.remove(self.sectionsArray[index])
                        let index5 = vaccinationTabBarController.ongoingVaccinations.firstIndex(of: self.sectionsArray[index])
                        
                        if self.sectionsArray[(index + 1)].amountOfDosesTaken! < self.sectionsArray[index + 1].vaccine.getTotalAmountOfDoses() {
                            vaccinationTabBarController.ongoingVaccinations[index5!] = self.sectionsArray[index + 1]
                        }
                        else {
                            vaccinationTabBarController.ongoingVaccinations.remove(self.sectionsArray[index])
                            vaccinationTabBarController.vaccinations.append(self.sectionsArray[index + 1])
                        }
                        
                    }
                    else {
                        let index4 = vaccinationTabBarController.vaccinations.firstIndex(of: self.sectionsArray[index])
                        vaccinationTabBarController.vaccinations[index4!] = self.sectionsArray[index + 1]
                        
                       
                    
                    }
                    
                }

                    
                else if indexPath.row == 0 && self.rowsInEachSection[indexPath.section] > 1 && indexPath.section == 0 {
                    
                    if self.sectionsArray[index].amountOfDosesTaken! < self.sectionsArray[index].vaccine.getTotalAmountOfDoses() {
                        let index2 = vaccinationTabBarController.ongoingVaccinations.firstIndex(of: self.sectionsArray[index])
                        vaccinationTabBarController.ongoingVaccinations[index2!] = self.sectionsArray[(index + 1)]

                    }
                       
                         //Hej Emil! Den 12/10 ska du fixa så att man kan radera den senaste dosen man tagit av ett vaccin, och så hoppar den tidigare upp!
                         
                         
                    else {
                        let index3 = vaccinationTabBarController.vaccinations.firstIndex(of: self.sectionsArray[index])
                        if self.sectionsArray[(index + 1)].amountOfDosesTaken! < self.sectionsArray[index + 1].vaccine.getTotalAmountOfDoses() {
                            vaccinationTabBarController.ongoingVaccinations.append( self.sectionsArray[(index + 1)])
                            vaccinationTabBarController.vaccinations.remove(self.sectionsArray[index])

                        }
                        else {
                            vaccinationTabBarController.vaccinations[index3!] = self.sectionsArray[(index + 1)]

                        }
                    }
                }
                self.sectionsArray.remove(at: index)
                
            if self.rowsInEachSection[indexPath.section] > 1{
                self.rowsInEachSection[indexPath.section] -= 1
                tableView.deleteRows(at: [indexPath], with: .fade)

            }
            else {
                self.rowsInEachSection[indexPath.section] -= 1
                tableView.deleteRows(at: [indexPath], with: .fade)

                self.rowsInEachSection.remove(at: indexPath.section)
                self.amountOfSections -= 1
            }

            
            tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
            
                vaccinationTabBarController.locallyModified = true
            //else if editingStyle == .insert {
                    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
                
            })
            
        
            
          
         //else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //}
     
    
        //})
/*            let alertAction2 = UIAlertAction(title: "Avbryt", style: .cancel, handler: { action in
                return
            })
            */
    
        
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
   
    private func groupVaccinations(sectionsArray: [Vaccination]) {
        var x = 0
        while x < sectionsArray.count {
            if x == 0 {
                rowsInEachSection[x] = sectionsArray.count
            }
            else {
                rowsInEachSection.append(x)
            }
            x += 1
        }

        if !vaccine.takenOnce() {
            
            var x = 0
            var i = 0
            while x < sectionsArray.count - 1 {
                if sectionsArray[x+1].amountOfDosesTaken! >= sectionsArray[x].amountOfDosesTaken! {
                    amountOfSections += 1
                    rowsInEachSection[i] = x + 1
                    i += 1
                    rowsInEachSection[i] = sectionsArray.count - (x + 1)

                }
                x += 1
            }
        }
        
        else {
            var x = 0
            var i = 0
            while x < sectionsArray.count - 1 {
                
                    amountOfSections += 1
                    rowsInEachSection[i] = x + 1
                    i += 1
                    rowsInEachSection[i] = sectionsArray.count - (x + 1)

                
                x += 1
            }
        }
        
       
        
    }
    
    
    func returnPositionForThisIndexPath(indexPath: IndexPath, insideThisTable theTable:UITableView)->Int{

        var i = 0
        var rowCount = 0

        while i < indexPath.section {

            rowCount += theTable.numberOfRows(inSection: i)

            i += 1
        }

        rowCount += indexPath.row

        return rowCount
    }
    
    //MARK: Actions
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        tableViewWasEdited = true
        for index in 0...(sectionsArray.count - 1){
            let indexPath = tableView.index
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


