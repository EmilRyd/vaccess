//
//  TestVaccineTableViewController.swift
//  Vaccess
//
//  Created by emil on 2020-02-01.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//
import os.log

import UIKit
import Parse

class TestVaccineTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    var vaccinations = [Vaccination]()
    var vaccinationTabBarController: VaccinationTabBarController!
    var ongoingVaccinations = [Vaccination]()
    var comingVaccinations = [Vaccination]()
    var unwindingFromVaccineList: Bool = false
    let titlar = ["Nästa vaccin du ska ta:"]
    var addButton1: FloatingActionButton = FloatingActionButton()
    var user = PFUser.current()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fix font layout
        addButton.backgroundColor = UIColor(displayP3Red: 0.108, green: 0.684, blue: 0.356, alpha: 1.0)
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.shadowOpacity = 0.25
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        addButton.frame = CGRect(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 80 - (self.tabBarController?.tabBar.frame.height ?? 49), width: 56, height: 56)
        addButton.imageView?.tintColor = .white
        
        print(addButton.frame)
        
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 21)!]
        // Use the edit button item provided by the table view controller.
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        loadSampleVaccines()
        
        vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        vaccinations = vaccinationTabBarController.vaccinations
        ongoingVaccinations = vaccinationTabBarController.ongoingVaccinations
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Mina Vaccin"
        longTitleLabel.font = UIFont(name: "Futura-Medium", size: 30)
        longTitleLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.rightBarButtonItems?.remove(navigationItem.rightBarButtonItems![1])
        
        /*addButton.frame = CGRect(x:self.view.frame.width - 80, y:self.view.frame.height - 250, width: 50, height: 50)
        self.view.addSubview(addButton)
        self.view.bringSubview(toFront: addButton)
        self.tableView.bringSubview(toFront: self.view)
        print("The rseult is: \(self.view == self.tableView)")*/
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if unwindingFromVaccineList {
            let alert = UIAlertController(title: "Vaccinering sparad", message: "Din vaccinering är sparad. Gå till 'Historik' för att se på och modifiera den", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
            })
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        self.tableView.headerView(forSection: 0)?.textLabel?.font = UIFont(name: "Futura-Medium", size: 17.0)
        
        unwindingFromVaccineList = false
        
        let height: CGFloat = 100 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
        addButton.alpha = 1.0

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        vaccinations = vaccinationTabBarController.vaccinations
        comingVaccinations = vaccinationTabBarController.comingVaccinations
        tableView.reloadData()
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


//MARK: UITableViewDelegate

     func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if comingVaccinations.count == 0 {
           tableView.setEmptyView(title: "Du har inga kommande vaccinationer.", message: "Dina kommande vaccinationer visas här.", image: "Emptiness")
           }
           else {
           tableView.restore()
           }
           
           return comingVaccinations.count
           
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           // Table view cells are reused and should be dequeued using a cell identifier.
           let cellIdentifierare = "VaccineTableViewCell"
           
           
           guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? VaccineTableViewCell else {
               fatalError("The dequeued cell is not an instance of VaccineTableViewCell.")
           }
           // Hämtar rätt vaccin
           let vaccin: Vaccination
           
           
           
           vaccin = comingVaccinations[indexPath.row]
           
        if vaccin.vaccine.getTotalAmountOfDoses() > 1 {
            cell.namnEtikett.text = vaccin.vaccine.simpleDescription() + " (dos \(vaccin.amountOfDosesTaken!))"

        }
        if vaccin.vaccine.getTotalAmountOfDoses() == 17 {
            cell.namnEtikett.text = vaccin.vaccine.simpleDescription() + " (Booster)"

        }
        else {
            cell.namnEtikett.text = vaccin.vaccine.simpleDescription()

        }
        
           
           
           let today = Date()
           
           switch (vaccin.vaccine.protection(amountOfDosesTaken: vaccin.amountOfDosesTaken)) {
           case .time(_), .unknown:
               let timeLeft = vaccin.getVaccinationTimeLeft(atDate: today, amountOfDosesTaken: vaccin.amountOfDosesTaken)
               
               /*switch (timeLeft.status) {
                case VaccinationStatus.expired:
                cell.tidsFoto.image = #imageLiteral(resourceName: "firstRed")
                
                case VaccinationStatus.ok:
                cell.tidsFoto.image = #imageLiteral(resourceName: "firstGreen")
                
                case VaccinationStatus.soon_to_expiry:
                cell.tidsFoto.image = #imageLiteral(resourceName: "firstYellow")
                case VaccinationStatus.unknown:
                cell.tidsFoto.image = nil
                cell.tidsEtikett.text = "Vet ej"
                //return cell
                }*/
               var x: Double = Double(timeLeft.days)/150.0
               if x > 1.0 {
                   x = 1.0
               }
               if x < 0 {
                   x = 0
               }
               print(x)
               x = x.squareRoot().squareRoot()
               
               let color = UIColor(displayP3Red: CGFloat(2.0 * (1 - x)), green: CGFloat(2.0 * x), blue: 0.0, alpha: 1.0)
               
               
               
               
               cell.timeView.backgroundColor = color
               switch timeLeft.days {
               case 0:
                   cell.tidsEtikett.text = "Kan tas nu!"
               case 1...31:
                   cell.tidsEtikett.text = "Kan tas om \(timeLeft.days) dagar"
               case (-31)...(-1):
                   cell.tidsEtikett.text = "Kan tas nu!"
               default:
                   switch timeLeft.months {
                   case let x where x >= 12:
                       cell.tidsEtikett.text = "Kan tas om \(timeLeft.years) år och \(timeLeft.months - (timeLeft.years * 12)) månader"
                   case let x where x <= -12:
                       cell.tidsEtikett.text = "Kan tas nu!"
                   case 1...12:
                       cell.tidsEtikett.text = "Kan tas om \(timeLeft.months) månader"
                   case (-11)...0:
                       cell.tidsEtikett.text = "Kan tas nu!"
                   default:
                       fatalError("Inconsistent time left")
                   }
                   
               }
           case Protection.lifeLong:
               cell.timeView.backgroundColor = .green
               cell.tidsEtikett.text = "Livslångt"
               
           }
        
        if vaccin.isPartOfVaccinationProgram ?? false {
            cell.vaccinationProgramLabel.isHidden = false
        }
           
           return cell
       }
       
       
       
       
       
       
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let view = UIView()
           view.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.108, green: 0.684, blue: 0.356, alpha: 1.0))
           
           let icon = UIImageView(image: UIImage(named: "MinaVaccinationerImage"))
           icon.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
           view.addSubview(icon)
           
           let label = UILabel()
           label.text = titlar[section]
           label.font = UIFont(name: "Futura-Medium", size: 12)
           label.sizeToFit()
           label.frame = CGRect(x: 45, y: 5, width: 200, height: 35)
           view.addSubview(label)
           
           return view
       }
       
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 45
       }
       
       // Override to support conditional editing of the table view.
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           // Return false if you do not want the specified item to be editable.
           return true
       }
       
       
       
       // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               
               
               
               // Make sure the general vaccinations array is updated and informed after this change
               let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
               vaccinationTabBarController.comingVaccinations = comingVaccinations
               vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
               //FIXA DETTA!
               
               if indexPath.section == 0 {
                   // Delete the row from the data source
                   vaccinationTabBarController.allVaccinations.remove(comingVaccinations[indexPath.row])
               }
               /*var noOtherVaccines = true
                var alikeVaccinations = [Vaccination]()
                for i in vaccinationTabBarController.allVaccinations {
                if i.vaccine == comingVaccinations[indexPath.row].vaccine {
                
                alikeVaccinations.append(i)
                
                
                noOtherVaccines = false
                }
                }
                
                
                if alikeVaccinations.count == 1 {
                comingVaccinations.append(alikeVaccinations[0])
                }
                else if alikeVaccinations.count > 1{
                alikeVaccinations.sort(by: <)
                
                let z = alikeVaccinations[alikeVaccinations.count - 1]
                
                comingVaccinations.append(z)
                }
                
                
                if noOtherVaccines {
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                }
                */
               
               comingVaccinations.remove(at: indexPath.row)
               
               
               
               vaccinationTabBarController.vaccinations = vaccinations
               vaccinationTabBarController.comingVaccinations = comingVaccinations
           }
           /*else {
            _ = comingVaccinations.firstIndex(of: comingVaccinations[indexPath.row])!
            vaccinationTabBarController.allVaccinations.remove(comingVaccinations[indexPath.row])
            
            var noOtherVaccines2 = true
            var alikeVaccinations = [Vaccination]()
            for i in vaccinationTabBarController.allVaccinations {
            if i.vaccine == comingVaccinations[indexPath.row].vaccine && !(i === comingVaccinations[indexPath.row]) {
            
            alikeVaccinations.append(i)
            
            noOtherVaccines2 = false
            }
            }
            
            
            if alikeVaccinations.count == 1 {
            comingVaccinations.append(alikeVaccinations[0])
            }
            
            alikeVaccinations.sort(by: <)
            let z: Vaccination
            if alikeVaccinations.count == 0 {
            z = alikeVaccinations[alikeVaccinations.count - 1]
            }
            else {
            z = alikeVaccinations[0]
            
            }
            comingVaccinations.append(z)
            
            
            
            comingVaccinations.remove(at: indexPath.row)
            
            if noOtherVaccines2 {
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            }
            
            
            vaccinationTabBarController.comingVaccinations = comingVaccinations
            vaccinationTabBarController.vaccinations = vaccinations
            
            }*/
           
           
           tableView.reloadData()
           
           if editingStyle == .insert {
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
            
            selectedVaccination = comingVaccinations[indexPath.row]
            vaccineDetailViewController.presentingComingVaccination = true
            
            vaccineDetailViewController.vaccination = selectedVaccination
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
    }
    
    
    
    
    //MARK: Actions
    
    @IBAction func unwindToVaccineList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? VaccineViewController, let vaccination = sourceViewController.vaccination {
            // Add a new vaccine
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow, let comingVaccination = sourceViewController.comingVaccination {
                
                if comingVaccinations[selectedIndexPath.row].startDate < sourceViewController.comingVaccination!.startDate {
                    comingVaccinations.remove(at: selectedIndexPath.row)
                    comingVaccinations.append(comingVaccination)
                    
                }
                
                
                
                
                
                
            }
                
            else {
                if let comingVaccination = sourceViewController.comingVaccination {
                    comingVaccinations.append(comingVaccination)
                    
                }
                
            }
            unwindingFromVaccineList = true
            vaccinationTabBarController.allVaccinations.append(vaccination)
            vaccinationTabBarController.comingVaccinations = self.comingVaccinations
            //vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
            //vaccinationTabBarController.vaccinations = vaccinations
            
            tableView.reloadData()
            
            //self.viewDidAppear(true)
            
            
        }
    }
    
    
    // Private Methods
    
    private func loadSampleVaccines() {
        
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        if vaccinationTabBarController.vaccinationProgramIndicatorWasChangedThisSession {
            
        }
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset
        addButton.frame = CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - 250 + offSet.y, width: 50, height: 50)
        
    }
    
    
    
    

    
    
    

}


