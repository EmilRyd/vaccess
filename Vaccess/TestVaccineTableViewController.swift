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
import UserNotifications

class TestVaccineTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let center = UNUserNotificationCenter.current()
    
    
    let alertService = AlertService()
    var vaccinations = [Vaccination]()
    var vaccinationTabBarController: VaccinationTabBarController!
    var ongoingVaccinations = [Vaccination]()
    var comingVaccinations = [Vaccination]()
    var arrayOfArrayOfComingVaccinations = [[Vaccination]]()
    var unwindingFromVaccineList: Bool = false
    let titlar = ["Nästa vaccin du ska ta:"]
   // var addButton1: FloatingActionButton = FloatingActionButton()
    var user = PFUser.current()
    var sectionHeaderHeight: CGFloat = 0.0
    var arrayOfYears: [Int] = []
    let datumsFormat = DateFormatter()

    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        datumsFormat.dateFormat = "dd/MM - yyyy"
        let height: CGFloat = 56
        //Fix font layout
        /*addButton.backgroundColor = UIColor(displayP3Red: 0.108, green: 0.684, blue: 0.356, alpha: 1.0)
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.shadowOpacity = 0.25
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        addButton.frame = CGRect(x: UIScreen.main.bounds.width - 24 - height, y: UIScreen.main.bounds.height - 24 - height - (self.tabBarController?.tabBar.frame.height ?? 49), width: height, height: height)
        addButton.imageView?.tintColor = .white
        
        print(addButton.frame)*/
        
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 21)!]
        // Use the edit button item provided by the table view controller.
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        loadSampleVaccines()
        
        vaccinationTabBarController = tabBarController as? VaccinationTabBarController
        vaccinations = vaccinationTabBarController.vaccinations
        ongoingVaccinations = vaccinationTabBarController.ongoingVaccinations
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Kommande"
        longTitleLabel.font = UIFont(name: "Futura-Medium", size: 30)
        longTitleLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.rightBarButtonItems?.remove(navigationItem.rightBarButtonItems![1])
        
        tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        
        sectionHeaderHeight = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell")?.contentView.bounds.height ?? 44

        
        
        
        /*addButton.frame = CGRect(x:self.view.frame.width - 80, y:self.view.frame.height - 250, width: 50, height: 50)
        self.view.addSubview(addButton)
        self.view.bringSubview(toFront: addButton)
        self.tableView.bringSubview(toFront: self.view)
        print("The rseult is: \(self.view == self.tableView)")*/
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if unwindingFromVaccineList {
            let alertViewController = alertService.alert(title: "Vaccination sparad!", message: "Din vaccination är sparad. Gå till 'Historik' för att se på och modifiera den", button1Title: "Ok", button2Title: nil, alertType: .success, completionWithAction: {
                () in
                
            }, completionWithCancel: {
                () in
            })
            present(alertViewController, animated: true)
            /*var alertView = AlertView()
            alertView.showAlert(title: "Vaccinering sparad", message: "Din vaccinering är sparad. Gå till 'Historik' för att se på och modifiera den", alertType: .success)
            
            */
            
            
            
            
            /*
            
            let alert = UIAlertController(title: "Vaccinering sparad", message: "Din vaccinering är sparad. Gå till 'Historik' för att se på och modifiera den", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
            })
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)*/
            
        }
        //self.tableView.headerView(forSection: 0)?.textLabel?.font = UIFont(name: "Futura-Medium", size: 17.0)
        
        unwindingFromVaccineList = false
        
        let height: CGFloat = 100 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
        //addButton.alpha = 1.0

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        vaccinations = vaccinationTabBarController.vaccinations
        comingVaccinations = vaccinationTabBarController.comingVaccinations.sorted(by: { lhs, rhs in
          return lhs.vaccine < rhs.vaccine
            
        })
        loadArrayOfYears()
        loadArrayOfArrayOfComingVaccinations()

        tableView.reloadData()
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


//MARK: UITableViewDelegate

     func numberOfSections(in tableView: UITableView) -> Int {
        if arrayOfYears.count > 0 && arrayOfArrayOfComingVaccinations[0].count > 0 {
            tableView.restore()

        }
        else {
            tableView.setEmptyView(title: "Du har inga kommande vaccinationer.", message: "Dina kommande vaccinationer visas här.", image: "Emptiness")
            
        }
        return arrayOfYears.count

       }
       
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if comingVaccinations.count == 0 {
           tableView.setEmptyView(title: "Du har inga kommande vaccinationer.", message: "Dina kommande vaccinationer visas här.", image: "Emptiness")
           }
           else {
           tableView.restore()
           }
           
            return arrayOfArrayOfComingVaccinations[section].count
           
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           // Table view cells are reused and should be dequeued using a cell identifier.
           let cellIdentifierare = "VaccineTableViewCell"
           
           
           guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierare, for: indexPath) as? VaccineTableViewCell else {
               fatalError("The dequeued cell is not an instance of VaccineTableViewCell.")
           }
           // Hämtar rätt vaccin
           let vaccin: Vaccination
           
           
       
        
        
            vaccin = arrayOfArrayOfComingVaccinations[indexPath.section][indexPath.row]

        
           if vaccin.vaccine.getTotalAmountOfDoses() == 17 {
               cell.namnEtikett.text = vaccin.vaccine.simpleDescription() + " (Booster)"

           }
        else if vaccin.vaccine.getTotalAmountOfDoses() > 1  {
            cell.namnEtikett.text = vaccin.vaccine.simpleDescription()
            let amountOfDosesTakenString = String(vaccin.amountOfDosesTaken!)
            cell.doseLabel!.text = amountOfDosesTakenString + "/" + String(vaccin.vaccine.getTotalAmountOfDoses())

            

        }
       
        else {
            cell.namnEtikett.text = vaccin.vaccine.simpleDescription()

        }
        
        if vaccinationTabBarController.isVaccinationPartOfVaccinationProgram(vaccination: vaccin) {
            //cell.namnEtikett.textColor = UIColor(displayP3Red: 0.35, green: 0.78, blue: 0.98, alpha: 0.7)
            cell.vaccinationProgramImageView.isHidden = false
            //cell..isHidden = false
        }
        else {
            cell.vaccinationProgramImageView.isHidden = true
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
               
               let color = UIColor(displayP3Red: CGFloat((2.0 * x)), green: CGFloat((2.0 * (1 - x))), blue: 0.0, alpha: 1.0)
               
               
               
               
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
        
        
        
           
           return cell
        
       }
       
       
       
       
       
       
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell") as? SectionHeaderTableViewCell
            cell?.setUp(year: String(arrayOfYears[section]))
            return cell
       }
       
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
                return sectionHeaderHeight
            
    }
       
       // Override to support conditional editing of the table view.
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           // Return false if you do not want the specified item to be editable.
           return true
       }
       
       
       
       // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               
               
            let alertViewController = alertService.alert(title: "Vill du ta bort denna vaccinering?", message: "Denna åtgärd kan inte ångras.", button1Title: "Radera", button2Title: nil, alertType: .warning, completionWithAction: { ()  in
                
                // Make sure the general vaccinations array is updated and informed after this change
                let vaccinationTabBarController = self.tabBarController as! VaccinationTabBarController
                vaccinationTabBarController.comingVaccinations = self.comingVaccinations
                vaccinationTabBarController.ongoingVaccinations = self.ongoingVaccinations
                   //FIXA DETTA!
                   
                   
                       // Delete the row from the data source
                vaccinationTabBarController.comingVaccinations.remove(self.arrayOfArrayOfComingVaccinations[indexPath.section][indexPath.row])
                self.comingVaccinations.remove(self.arrayOfArrayOfComingVaccinations[indexPath.section][indexPath.row])
                   
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
                   
                self.comingVaccinations.remove(self.arrayOfArrayOfComingVaccinations[indexPath.section][indexPath.row])
                   
                   
                   
                self.vaccinationTabBarController.vaccinations = self.vaccinations
                self.vaccinationTabBarController.comingVaccinations = self.comingVaccinations
                var bool = false
                if self.arrayOfArrayOfComingVaccinations[indexPath.section].count == 1 {
                    bool = true
                }
                
                
                let identifier = (self.arrayOfArrayOfComingVaccinations[indexPath.section][indexPath.row].vaccine.simpleDescription() + self.datumsFormat.string(from: self.arrayOfArrayOfComingVaccinations[indexPath.section][indexPath.row].startDate))
                    print(identifier)
                    
                    print(self.center.getPendingNotificationRequests(completionHandler:
                        
                
                        {_ in ()
                        
                        return
                        }))
                    
                    
                    self.center.removePendingNotificationRequests(withIdentifiers: [identifier])
                    
                    
                    print(self.center.getPendingNotificationRequests(completionHandler:
                            
                    
                            {_ in ()
                            
                            return
                            }))
                
                
                
                print(self.comingVaccinations)
                print(self.arrayOfArrayOfComingVaccinations)
                
                
                
                self.loadArrayOfArrayOfComingVaccinations()
                                
               
                
                print(self.comingVaccinations)
                print(self.arrayOfArrayOfComingVaccinations)

                tableView.deleteRows(at: [indexPath], with: .fade)
               
                

                if bool {
                    self.arrayOfYears.remove(at: indexPath.section)
                    self.loadArrayOfArrayOfComingVaccinations()
                   // self.arrayOfArrayOfComingVaccinations[indexPath.section].remove(at: indexPath.row)


                    print(self.arrayOfYears)
                    print(tableView.numberOfSections)
                    print(tableView.numberOfRows(inSection: 0))
                    
                    print("We made it, we´re inside")
                    tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section)
                        , with: .fade)
                    
                    self.loadArrayOfYears()
                    
                }

                
                
                                
                
               
               
                tableView.reloadData()

                
            }, completionWithCancel: {() in})
            
            present(alertViewController, animated: true)

               
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
            segue.destination.modalPresentationStyle = .fullScreen
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
            
            selectedVaccination = arrayOfArrayOfComingVaccinations[indexPath.section][indexPath.row]
            vaccineDetailViewController.presentingComingVaccination = true
            
            vaccineDetailViewController.vaccination = selectedVaccination
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
    }
    
    
    
    
    //MARK: Actions
    
    @IBAction func unwindToVaccineList(sender: UIStoryboardSegue) {
        unwindingFromVaccineList = true

        if let sourceViewController = sender.source as? VaccineViewController, let vaccination = sourceViewController.vaccination {
            // Add a new vaccine
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow, let comingVaccination = sourceViewController.comingVaccination {
                
                if arrayOfArrayOfComingVaccinations[selectedIndexPath.section][selectedIndexPath.row].amountOfDosesTaken! < sourceViewController.comingVaccination!.amountOfDosesTaken! {
                    comingVaccinations.remove(arrayOfArrayOfComingVaccinations[selectedIndexPath.section][selectedIndexPath.row])
                    comingVaccinations.append(comingVaccination)
                    
                }
                
                
                
                
                
                
            }
                
            else {
                if let comingVaccination = sourceViewController.comingVaccination {
                    comingVaccinations.append(comingVaccination)
                    
                    

                }
                
            }
            vaccinationTabBarController.allVaccinations.append(vaccination)
            vaccinationTabBarController.comingVaccinations = self.comingVaccinations
            vaccinationTabBarController.saveLocally()
            //vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
            //vaccinationTabBarController.vaccinations = vaccinations
            comingVaccinations.sort()
            loadArrayOfYears()
            loadArrayOfArrayOfComingVaccinations()
            
            tableView.reloadData()
            
            /*if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
            }
            else {
                if unwindingFromVaccineList {
                           let alert = UIAlertController(title: "Vaccinering sparad", message: "Din vaccinering är sparad. Gå till 'Historik' för att se på och modifiera den", preferredStyle: .alert)
                           let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                           })
                           alert.addAction(alertAction)
                           self.present(alert, animated: true, completion: nil)
                           
                       }
                       unwindingFromVaccineList = false
                   
            }*/
            
            //self.viewDidAppear(true)
            
            
        }
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, sender: Any?) -> Bool {
        if self.tableView?.indexPathsForSelectedRows != nil {
            return true
        } else {
            return false

        }
        
        
    }
    
    
    // Private Methods
    
    private func loadSampleVaccines() {
        
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        if vaccinationTabBarController.vaccinationProgramIndicatorWasChangedThisSession {
            
        }
    }
    
    /* func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset
        addButton.frame = CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - 80 - addButton.layer.frame.height , width: 56, height: 56)
        //- offSet.y
    }*/
    
     func loadArrayOfYears() {
        let years = Set([Calendar.Component.year])
        arrayOfYears = []
        for i in comingVaccinations {
            let year = Calendar.current.dateComponents(years, from: i.startDate).year
            if !arrayOfYears.contains(year!) {
                arrayOfYears.append(year!)
            }
            
        }
        
        arrayOfYears.sort()
    }
    
    func loadArrayOfArrayOfComingVaccinations() {
        arrayOfArrayOfComingVaccinations = [[Vaccination]]()
        let years = Set([Calendar.Component.year])
        var a = 0
        while a < arrayOfYears.count {
            arrayOfArrayOfComingVaccinations.append([])
            a += 1
        }

        var y = 0
        outerLoop: for i in arrayOfYears {
            innerLoop: for x in comingVaccinations {
                let year = Calendar.current.dateComponents(years, from: x.startDate).year
                if year == i {
                    arrayOfArrayOfComingVaccinations[y].append(x)
                }
                
                
            }
            y += 1

        }
        
        
        
    }
    
    
    @IBAction func sendNotification(_ sender: UIButton) {
        
        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) in
            
            self.appDelegate?.scheduleNotifications(notificationType: "default", identifier: "testNotification")
        }
    }
    
        
    
    

    
    
    

}


