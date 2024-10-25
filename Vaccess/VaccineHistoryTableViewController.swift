//
//  VaccineHistoryTableViewController.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-10-02.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//
import os.log
import UIKit

class VaccineHistoryTableViewController: UITableViewController, UITextFieldDelegate {

    //MARK: Properties
    let alertService = AlertService()
    var vaccine: Vaccine! = nil
    var vaccinations = [Vaccination]()
    var amountOfSections: Int = 1
    var rowsInEachSection: [Int] = [0]
    var amountOfVaccinationsLoaded: Int = 0
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var sourceViewController: UIViewController? = nil
    var sectionsArray = [Vaccination]()
    let datumsFormat = DateFormatter()
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var datePickers: [[UIDatePicker]] = [[UIDatePicker]]()
    var pickerView: [[UIPickerView]] = [[UIPickerView]]()

    var tableViewWasEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = vaccine.simpleDescription()
        self.navigationController?.navigationBar.shadowImage = UIImage()
       // self.navigationItem.rightBarButtonItem = nil

        sectionsArray = getArrayWithVaccinationsOfRightType()
        //groupVaccinations(sectionsArray: sectionsArray)
        rowsInEachSection = [sectionsArray.count]
       
        let tryckGest = UITapGestureRecognizer(target: self, action: #selector(VaccineViewController.tapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tryckGest)
        
                // Hej Emil! Den 3:e Oktober ska du få in logike nsom bestämmer hur många rader det ska vara i denna tablieView och vad de ska fyllas med! Lycka till, och kom ihåg vad som står på spel! Njut inte bort tiden, utan arbeta!
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
    }
    deinit {
        //Stop listening to keyboard events

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        
        view.endEditing(true)
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UIDatePickerstuff
    @objc func dateChanged (datumVäljare: UIDatePicker) {
        
        datumsFormat.dateFormat = "dd/MM - yyyy"
        let tag = datumVäljare.tag
        
        if  tag % 2 == 0 {
            //startdatumTextruta.text = datumsFormat.string(from: startdatum)
            let row = tag/2
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! VaccineHistoryTableViewCell
            cell.startdateTextField.text = datumsFormat.string(from: datumVäljare.date)
                            
            
            
            startDatePicker.date = datumVäljare.date
        }
        else {
            //.text = ""
            let row = (tag-1)/2

            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! VaccineHistoryTableViewCell
            cell.enddateTextField.text = datumsFormat.string(from: datumVäljare.date)
            endDatePicker.date = datumVäljare.date
        }
            
       
        
    
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Radera"
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //return amountOfSections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            //return rowsInEachSection[section]
        return sectionsArray.count
        
        /*else {
            return sectionsArray.count
        }*/
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return "Omgång \(amountOfSections - section)"
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "VaccineHistoryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VaccineHistoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of VaccineHistoryTableViewCell.")
        }
        
        // Fetches the appropriate vaccine for the data source layout.
        
        
        //if amountOfVaccinationsLoaded >= sectionsArray.count {
            //return cell
       // }
        
        let vaccination = sectionsArray[indexPath.row]
        
        // Configure the cell...
        dateFormatter.dateFormat = "dd/MM - yyyy"
        let doses = vaccination.amountOfDosesTaken ?? 1
        cell.doseTextField.text = String(doses)
        if vaccination.amountOfDosesTaken == 17 {
            cell.doseTextField.text = "Booster"

        }
        cell.startdateTextField.text = dateFormatter.string(from: vaccination.startDate)
        
        cell.doseTextField.adjustsFontSizeToFitWidth = true
        cell.enddateTextField.adjustsFontSizeToFitWidth = true
        cell.startdateTextField.adjustsFontSizeToFitWidth = true
        cell.startdateTextField.isEnabled = false
        cell.enddateTextField.isEnabled = false
        
        var startDatePicker = UIDatePicker()
        var endDatePicker = UIDatePicker()
        var dosePicker = UIPickerView()
        
         startDatePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        let loc = Locale(identifier: "sv")
        startDatePicker.locale = loc
        // Se till att textrutan påverkas när datumet ändras av användaren
        startDatePicker.addTarget(self, action: #selector(VaccineViewController.dateChanged(datumVäljare:)), for: .valueChanged)
        endDatePicker.datePickerMode = .date
       if #available(iOS 14.0, *) {
        endDatePicker.preferredDatePickerStyle = .wheels
       } else {
           // Fallback on earlier versions
       }
        endDatePicker.locale = loc
       // Se till att textrutan påverkas när datumet ändras av användaren
        endDatePicker.addTarget(self, action: #selector(VaccineViewController.dateChanged(datumVäljare:)), for: .valueChanged)
        datePickers.append([startDatePicker, endDatePicker])
        
        startDatePicker.tag = 2 * indexPath.row
        endDatePicker.tag = 2*indexPath.row + 1
        
        
        cell.startdateTextField.inputView = datePickers[indexPath.row][0]
        cell.enddateTextField.inputView = datePickers[indexPath.row][1]

        

        
        if vaccination.getEndDate(amountOfDosesTaken: vaccination.amountOfDosesTaken) != nil && (vaccination.protectionManuallySetToLifelong ?? false) == false {
            cell.enddateTextField.text = dateFormatter.string(from: vaccination.getEndDate(amountOfDosesTaken: vaccination.amountOfDosesTaken)!)
        }
        else if (vaccination.protectionManuallySetToLifelong ?? false) == true  {
            cell.enddateTextField.text = "Livslångt"

        }
        else {
            switch vaccination.vaccine.protection(amountOfDosesTaken: vaccination.amountOfDosesTaken) {
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let index = returnPositionForThisIndexPath(indexPath: indexPath, insideThisTable: self.tableView)
            
            let alertController = alertService.alert(title: "Vill du ta bort denna vaccinering?", message: "Denna åtgärd kan inte ångras.", button1Title: "Radera", button2Title: nil, alertType: .warning, completionWithAction: { () in
                self.sectionsArray = self.getArrayWithVaccinationsOfRightType()
                    
                let vaccinationTabBarController = self.sourceViewController?.tabBarController as! VaccinationTabBarController
                    var allVaccinations = vaccinationTabBarController.allVaccinations
                    
                let indexForThisVaccination = allVaccinations.firstIndex(of: self.sectionsArray[index])
                    allVaccinations.remove(at: indexForThisVaccination!)
                    vaccinationTabBarController.allVaccinations = allVaccinations
                
                if vaccinationTabBarController.vaccinationsTakenInTime.contains(self.sectionsArray[index]) {
                    vaccinationTabBarController.vaccinationsTakenInTime.remove(self.sectionsArray[index])
                }
                else {
                    vaccinationTabBarController.vaccinationsNotTakenInTime.remove(self.sectionsArray[index])

                }
                    
              
                self.sectionsArray.remove(at: index)
                
           if self.rowsInEachSection[indexPath.section] > 1{
                self.rowsInEachSection[indexPath.section] -= 1
                tableView.deleteRows(at: [indexPath], with: .fade)

            }
            else {
                self.rowsInEachSection[indexPath.section] -= 1
                tableView.deleteRows(at: [indexPath], with: .fade)

                //self.rowsInEachSection.remove(at: indexPath.section)
               // self.amountOfSections -= 1
                //tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)

            }
                

            
            
                vaccinationTabBarController.locallyModified = true
                if !vaccinationTabBarController.save() {
                    let alertViewController = self.alertService.alert(title: "Varning!", message: "Det gick inte att spara ändringen. Vänligen se till att vara uppkopplad till internet.", button1Title: "OK", button2Title: nil, alertType: .error) {
                        
                    } completionWithCancel: {
                        
                    }
                    self.present(alertViewController, animated: true, completion: nil)
                }
            //else if editingStyle == .insert {
                    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
                
            }, completionWithCancel: {
                () in
            })
            
            
            
    
        
        
        present(alertController, animated: true, completion: nil)
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
        amountOfVaccinationsLoaded = 0
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var i = 0
        while i < amountOfSections {
            self.tableView.headerView(forSection: i)?.textLabel?.font = UIFont(name: "Futura-Medium", size: 17.0)

            i += 1
        }

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
   
    /*private func groupVaccinations(sectionsArray: [Vaccination]) {
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

        if true //!vaccine.takenOnce()
        {
            
            var x = 0
            var i = 0
            while x < sectionsArray.count - 1 {
                if sectionsArray[x+1].amountOfDosesTaken! > sectionsArray[x].amountOfDosesTaken! {
                    amountOfSections += 1
                    rowsInEachSection[i] = x + 1
                    i += 1
                    rowsInEachSection[i] = sectionsArray.count - (x + 1)

                }
                x += 1
            }
        }
        /*
        else {
            var x = 0
            var i = 0
            while x < sectionsArray.count - 1 {
                
                    amountOfSections += 1
                    rowsInEachSection[i] = 1
                    i += 1
                    rowsInEachSection[i] = 1

                
                x += 1
            }
        }*/
        
       
        
    }*/
    
    
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
            //let indexPath = tableView.index
            let vaccineHistoryTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! VaccineHistoryTableViewCell
            vaccineHistoryTableViewCell.startdateTextField.isEnabled = true
            vaccineHistoryTableViewCell.enddateTextField.isEnabled = true
            
            vaccineHistoryTableViewCell.startdateTextField.delegate = self
            vaccineHistoryTableViewCell.enddateTextField.delegate = self
            
        }
       //navigationItem.rightBarButtonItem.title = "Spara"
        

       
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
                    let ourVaccinations = vaccinationTabBarController.vaccinations
                    //let ourEditedVaccinationIndex = ourVaccinations.firstIndex(of: i)
                    //ourVaccinations[ourEditedVaccinationIndex!] = newVaccination
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

        
        
    }
    
    @IBAction func editButtonChanged(_ sender: UIBarButtonItem) {
        if sender.title == "Ändra" {
            for i in tableView.visibleCells {
                let cell = i as! VaccineHistoryTableViewCell
                cell.startdateTextField.isEnabled = true
                cell.enddateTextField
                    .isEnabled = true
            }
            sender.title = "Spara"
            sender.style = .done
        }
        else {
            sender.title = "Ändra"
            sender.style = .plain
            var index = 0
            for i in tableView.visibleCells {
                let cell = i as! VaccineHistoryTableViewCell
                cell.startdateTextField.isEnabled = false
                cell.enddateTextField.isEnabled = false
                sectionsArray[index].startDate = dateFormatter.date(from: cell.startdateTextField.text!)!
                if dateFormatter.date(from: cell.enddateTextField.text!) != nil {
                    sectionsArray[index].setEndDate(endDate: dateFormatter.date(from: cell.enddateTextField.text!)!)
                    sectionsArray[index].protectionManuallySetToLifelong = false

                }
                
                index += 1
            }
            
            let vaccinationTabBarController = self.sourceViewController?.tabBarController as! VaccinationTabBarController
            if !vaccinationTabBarController.save() {
                let alertViewController = alertService.alert(title: "Varning!", message: "Det gick inte att spara ändringen. Vänligen se till att vara uppkopplad till internet.", button1Title: "OK", button2Title: nil, alertType: .error) {
                    
                } completionWithCancel: {
                    
                }
                self.present(alertViewController, animated: true, completion: nil)

            }
        }
        
        
        
        
    }
    
    
    
}


