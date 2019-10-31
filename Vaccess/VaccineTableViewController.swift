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
    var vaccinationTabBarController: VaccinationTabBarController!
    var ongoingVaccinations = [Vaccination]()
    
    let titlar = ["Vaccin du tagit:", "Vaccin du håller på att ta", "Vaccin du inte tagit:"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        loadSampleVaccines()
        
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        vaccinationTabBarController.vaccinations = vaccinations
        vaccinationTabBarController.allVaccinations = vaccinations
        vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
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
            
        else if section == 1{
            return ongoingVaccinations.count
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
        if indexPath.section == 0 {
            let vaccin = vaccinations[indexPath.row]
            
            cell.namnEtikett.text = vaccin.vaccine.simpleDescription()
            
            
            let today = Date()
            
            switch (vaccin.vaccine.protection(amountOfDosesTaken: vaccin.amountOfDosesTaken)) {
            case .time(_), .unknown:
                let timeLeft = vaccin.getVaccinationTimeLeft(atDate: today, amountOfDosesTaken: vaccin.amountOfDosesTaken)
                
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
        
        else {
            let vaccin = ongoingVaccinations[indexPath.row]
            
            cell.namnEtikett.text = vaccin.vaccine.simpleDescription()
            
            
            let today = Date()
            
            switch (vaccin.vaccine.protection(amountOfDosesTaken: vaccin.amountOfDosesTaken)) {
            case .time(_), .unknown:
                let timeLeft = vaccin.getVaccinationTimeLeft(atDate: today, amountOfDosesTaken: vaccin.amountOfDosesTaken)
                
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
            
            
            
            // Make sure the general vaccinations array is updated and informed after this change
            let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
            vaccinationTabBarController.vaccinations = vaccinations
            vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
            //FIXA DETTA!
            
            if indexPath.section == 0 {
                // Delete the row from the data source
                vaccinationTabBarController.allVaccinations.remove(vaccinations[indexPath.row])
                var noOtherVaccines = true
                var alikeVaccinations = [Vaccination]()
                for i in vaccinationTabBarController.allVaccinations {
                    if i.vaccine == vaccinations[indexPath.row].vaccine {
                        
                        alikeVaccinations.append(i)
                        
                        
                        noOtherVaccines = false
                    }
                }
                
                
                if alikeVaccinations.count == 1 {
                    if alikeVaccinations[0].amountOfDosesTaken! < alikeVaccinations[0].vaccine.getTotalAmountOfDoses() {
                        ongoingVaccinations.append(alikeVaccinations[0])
                    }
                    else {
                        vaccinations.append(alikeVaccinations[0])
                    }
                }
                else if alikeVaccinations.count > 1{
                    alikeVaccinations.sort(by: <)
                    
                    let z = alikeVaccinations[alikeVaccinations.count - 1]
                    
                    if z.amountOfDosesTaken! < z.vaccine.getTotalAmountOfDoses() {
                        ongoingVaccinations.append(z)
                    }
                    else {
                        vaccinations.append(z)
                    }
                }
                    
                
        
                vaccinations.remove(at: indexPath.row)

                if noOtherVaccines {
                    tableView.deleteRows(at: [indexPath], with: .fade)

                }

                vaccinationTabBarController.vaccinations = vaccinations
                vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
            }
            else {
                _ = ongoingVaccinations.firstIndex(of: ongoingVaccinations[indexPath.row])!
                vaccinationTabBarController.allVaccinations.remove(ongoingVaccinations[indexPath.row])
                
                var noOtherVaccines2 = true
                var alikeVaccinations = [Vaccination]()
                for i in vaccinationTabBarController.allVaccinations {
                    if i.vaccine == ongoingVaccinations[indexPath.row].vaccine && !(i === ongoingVaccinations[indexPath.row]) {
                        
                        alikeVaccinations.append(i)

                        noOtherVaccines2 = false
                    }
                }
                
                
                if alikeVaccinations.count == 1 {
                    if alikeVaccinations[0].amountOfDosesTaken! < alikeVaccinations[0].vaccine.getTotalAmountOfDoses() {
                        ongoingVaccinations.append(alikeVaccinations[0])
                    }
                    else {
                        vaccinations.append(alikeVaccinations[0])
                    }
                }
                else {
                    alikeVaccinations.sort(by: <)
                    let z: Vaccination
                    if alikeVaccinations.count == 0 {
                        z = alikeVaccinations[alikeVaccinations.count - 1]
                    }
                    else {
                        z = alikeVaccinations[0]

                    }
                    if z.amountOfDosesTaken! < z.vaccine.getTotalAmountOfDoses() {
                        ongoingVaccinations.append(z)
                    }
                    else {
                        vaccinations.append(z)
                    }
                }
                
                
                ongoingVaccinations.remove(at: indexPath.row)

                if noOtherVaccines2 {
                    tableView.deleteRows(at: [indexPath], with: .fade)

                }

                
                vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
                vaccinationTabBarController.vaccinations = vaccinations
                
            }
            
            
            tableView.reloadData()

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
            
            guard let selectedVaccineCell = sender as? VaccineTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedVaccineCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedVaccination: Vaccination
            if indexPath.section == 0 {
                selectedVaccination = vaccinations[indexPath.row]
            }
            else {
                selectedVaccination = ongoingVaccinations[indexPath.row]
            }
            vaccineDetailViewController.vaccination = selectedVaccination
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vaccinationTabBarController = tabBarController as? VaccinationTabBarController
        vaccinations = vaccinationTabBarController.vaccinations
        ongoingVaccinations = vaccinationTabBarController.ongoingVaccinations
        tableView.reloadData()
        
    }
 

    //MARK: Actions
    
    @IBAction func unwindToVaccineList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? VaccineViewController, let vaccination = sourceViewController.vaccination {
            // Add a new vaccine
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                if vaccination.amountOfDosesTaken! < vaccination.vaccine.getTotalAmountOfDoses() {
                    
                    if selectedIndexPath.section == 1 {
                        ongoingVaccinations[selectedIndexPath.row] = vaccination
                        
                    }
                    else {
                        ongoingVaccinations.append(vaccination)
                        vaccinations.remove(at: selectedIndexPath.row)
                        
                    }
                    vaccinationTabBarController.vaccinations = vaccinations
                    
                    vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
                    
                    
                }
                else {
                    if selectedIndexPath.section == 0 {
                        vaccinations[selectedIndexPath.row] = vaccination
                        
                    }
                    else {
                        vaccinations.append(vaccination)
                        ongoingVaccinations.remove(at: selectedIndexPath.row)
                        
                    }
                    vaccinationTabBarController.vaccinations = vaccinations
                    vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
                    
                }
                
                /*if vaccinations.contains(vaccinations[selectedIndexPath.row]) {
                    vaccinations.remove(vaccinations[selectedIndexPath.row])
                }
                else {
                    ongoingVaccinations.remove(vaccinations[selectedIndexPath.row])
                }
                
                // Update an existing vaccination.
                vaccinationTabBarController.allVaccinations.remove(vaccination)
                vaccinationTabBarController.allVaccinations.append(vaccination)
                
                */
                

                tableView.reloadData()
            
            }
            else {
                
                var x = 0
                var firstTime = true
                var newIndexPath: IndexPath
     outerLoop: for i in vaccinations {
                    if vaccination.vaccine == i.vaccine {
                        if i < vaccination {
                            vaccinations.remove(at: x)
                            if vaccination.amountOfDosesTaken! < vaccination.vaccine.getTotalAmountOfDoses() {
                                newIndexPath = IndexPath(row: x, section: 0)
                                tableView.deleteRows(at: [newIndexPath], with: .fade)
                                ongoingVaccinations.append(vaccination)
                            }
                            else {
                                newIndexPath = IndexPath(row: x, section: 0)
                                tableView.deleteRows(at: [newIndexPath], with: .fade)
                                vaccinations.append(vaccination)
                            }
                            
                            
                        }
                        firstTime = false

                        break outerLoop
                    }
                    else {
                        x += 1
                    }

                }
                var y = 0
                
                outerLoop: for i in ongoingVaccinations {
                    if vaccination.vaccine == i.vaccine {
                        if i < vaccination {
                            ongoingVaccinations.remove(at: y)
                            if vaccination.amountOfDosesTaken! < vaccination.vaccine.getTotalAmountOfDoses() {
                                newIndexPath = IndexPath(row: y, section: 1)
                                tableView.deleteRows(at: [newIndexPath], with: .fade)
                                ongoingVaccinations.append(vaccination)
                            }
                            else {
                                vaccinations.append(vaccination)
                            }
                            
                            
                        }
                        firstTime = false

                        break outerLoop
                    }
                    else {
                        y += 1
                    }

                }

                if firstTime {

                    if vaccination.amountOfDosesTaken! < vaccination.vaccine.getTotalAmountOfDoses() {
                        ongoingVaccinations.append(vaccination)

                    }
                    else {
                        vaccinations.append(vaccination)

                    }
                }

                
                vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
                vaccinationTabBarController.vaccinations = vaccinations
                vaccinationTabBarController.allVaccinations.append(vaccination)
                tableView.reloadData()
        }
    }
    }
    // Private Methods
    
    private func loadSampleVaccines() {
        
        let date1 = Date()
        let date2 = Date(timeInterval: -5, since: Date())
        let date3 = Date(timeIntervalSinceNow: 50000000000)

        guard let vaccine1 = Vaccination(vaccine:Vaccine.Rabies, startDate: date1, amountOfDosesTaken: 1) else {
            fatalError("Kunde inte skapa vaccine1")
        }
        
        guard let vaccine2 = Vaccination(vaccine:Vaccine.Hepatit_A, startDate: date2, amountOfDosesTaken: 1) else {
            fatalError("Kunde inte skapa vaccine2")
        }
        
        guard let vaccine3 = Vaccination(vaccine:Vaccine.Hepatit_B, startDate: date3, amountOfDosesTaken: 1) else {
            fatalError("Kunde inte skapa vaccine1")
        }
        
        vaccinations += [vaccine1, vaccine2, vaccine3]
    }

}

