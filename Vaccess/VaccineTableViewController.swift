//
//  VaccineTableViewController.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-14.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit
import os.log

class VaccineTableViewController: UITableViewController {

    //MARK: Properties
    
    var vaccinations = [Vaccination]()

    
    let titlar = ["Vaccin du tagit:", "Vaccin du håller på att ta", "Vaccin du inte tagit:"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        loadSampleVaccines()
        
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        vaccinationTabBarController.vaccinations = vaccinations
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return vaccinations.count
        }
            
        else {
            return 0
        }
        
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifierare = "VaccineTableViewCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? VaccineTableViewCell else {
            fatalError("The dequeued cell is not an instance of VaccineTableViewCell.")
        }
        // Hämtar rätt vaccin
        let vaccin = vaccinations[indexPath.row]
            
        cell.namnEtikett.text = vaccin.vaccine.simpleDescription()
        
     
        let today = Date()
        
        switch (vaccin.vaccine.protection()) {
        case .time(_), .unknown:
            let timeLeft = vaccin.getVaccinationTimeLeft(atDate: today)
            
            switch (timeLeft.status) {
            case VaccinationStatus.expired:
                cell.tidsFoto.image = #imageLiteral(resourceName: "firstRed")
                
            case VaccinationStatus.ok:
                cell.tidsFoto.image = #imageLiteral(resourceName: "firstGreen")
                
            case VaccinationStatus.soon_to_expiry:
                cell.tidsFoto.image = #imageLiteral(resourceName: "firstYellow")
            case VaccinationStatus.unknown:
                cell.tidsFoto.image = nil
                cell.tidsEtikett.text = "Vet ej"
                return cell
            }
            
            switch timeLeft.days {
            case 0:
                cell.tidsEtikett.text = "Går ut idag"
            case 1...31:
                cell.tidsEtikett.text = "Går ut om \(timeLeft.days) dagar"
            case (-31)...(-1):
                cell.tidsEtikett.text = "Gick ut för \(-timeLeft.days) dagar sedan"
            default:
                switch timeLeft.months {
                case let x where x >= 12:
                    cell.tidsEtikett.text = "Går ut om \(timeLeft.years) år och \(timeLeft.months - (timeLeft.years * 12)) månader"
                case let x where x <= -12:
                    cell.tidsEtikett.text = "Gick ut för \(-timeLeft.years) år och \(-timeLeft.months - (timeLeft.years * -12)) månader sedan"
                case 1...12:
                    cell.tidsEtikett.text = "Går ut om \(timeLeft.months) månader"
                case (-11)...0:
                    cell.tidsEtikett.text = "Gick ut för  \(-timeLeft.months) månader sedan"
                default:
                    fatalError("Inconsistent time left")
                }
                
            }
        case Protection.lifeLong:
            cell.tidsFoto.image = #imageLiteral(resourceName: "firstGreen")
            cell.tidsEtikett.text = "Livslångt"

    }
    
        return cell
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titlar[section]
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            vaccinations.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let vaccineDetailViewController = segue.destination as? VaccineViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? VaccineTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedVaccination = vaccinations[indexPath.row]
            vaccineDetailViewController.vaccination = selectedVaccination
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        vaccinationTabBarController.vaccinations = vaccinations
        
    }
 

    //MARK: Actions
    
    @IBAction func unwindToVaccineList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? VaccineViewController, let vaccination = sourceViewController.vaccination {
            // Add a new vaccine
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update an existing meal.
                vaccinations[selectedIndexPath.row] = vaccination
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            
            }
            else {
                let indexPath = IndexPath(item: vaccinations.count, section: 0)
                vaccinations.append(vaccination)
                
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    // Private Methods
    
    private func loadSampleVaccines() {
        
        let date1 = Date()
        let date2 = Date(timeInterval: -5, since: Date())
        let date3 = Date(timeIntervalSinceNow: 50000000000)

        guard let vaccine1 = Vaccination(vaccine:Vaccine.Rabies, startDate: date1) else {
            fatalError("Kunde inte skapa vaccine1")
        }
        
        guard let vaccine2 = Vaccination(vaccine:Vaccine.Hepatit_A, startDate: date2) else {
            fatalError("Kunde inte skapa vaccine2")
        }
        
        guard let vaccine3 = Vaccination(vaccine:Vaccine.Hepatit_B, startDate: date3) else {
            fatalError("Kunde inte skapa vaccine1")
        }
        
        vaccinations += [vaccine1, vaccine2, vaccine3]
    }

}

