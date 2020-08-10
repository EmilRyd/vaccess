//
//  HistoryViewController.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-10-02.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit
import os.log
class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var vaccinations = [Vaccine]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    //MARK: Table View Data Source andDeleate Protocol Stubs
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        
        
        
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
            //vaccinations = vaccinationTabBarController.vaccinations
            //vaccinations += vaccinationTabBarController.ongoingVaccinations
        vaccinations = []
            for i in vaccinationTabBarController.allVaccinations {
                vaccinations.append(i.vaccine)
            }
        vaccinations = Array(Set(vaccinations)).sorted()
        
        if vaccinations.count == 0 {
        tableView.setEmptyView(title: "Du har inga tagna vaccin.", message: "Dina tagna vaccin visas här.", image: "ColoredSyringe")
        }
        else {
        tableView.restore()
        }
            return vaccinations.count
        
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HistoryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HistoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of HistoryTableViewCell.")
        }
        
        // Fetches the appropriate vaccine for the data source layout.
        let vaccine = vaccinations[indexPath.row]
        
        // Configure the cell...
    
        cell.VaccineLabel.text = vaccine.simpleDescription()
        cell.VaccineImage = nil
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self 
        
        //Configure the add button a bit
        let height: CGFloat = 56
        //Fix font layout
        addButton.backgroundColor = UIColor(displayP3Red: 0.108, green: 0.684, blue: 0.356, alpha: 1.0)
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.shadowOpacity = 0.25
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        addButton.frame = CGRect(x: UIScreen.main.bounds.width - 24 - height, y: UIScreen.main.bounds.height - 24 - height - (self.tabBarController?.tabBar.frame.height ?? 49), width: height, height: height)
        addButton.imageView?.tintColor = .white
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 21)!]
        
        self.navigationController?.navigationBar.shadowImage = UIImage()

        
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Tagna"
        longTitleLabel.font = UIFont(name: "Futura-Medium", size: 30)
        longTitleLabel.sizeToFit()

        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        //vaccinations = vaccinationTabBarController.vaccinations
        //vaccinations += vaccinationTabBarController.ongoingVaccinations
        
        for i in vaccinationTabBarController.allVaccinations {
            vaccinations.append(i.vaccine)
        }
        vaccinations = Array(Set(vaccinations)).sorted()
        
        tableView.reloadData()
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            segue.destination.modalPresentationStyle = .fullScreen
        case "ShowHistory":
        
        
            let destinationNavigationController = segue.destination as! UINavigationController
            let destinationViewController = destinationNavigationController.viewControllers[0] as! VaccineHistoryTableViewController
            
            destinationViewController.sourceViewController = self

        
        guard let selectedCell = sender as? HistoryTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedVaccine = vaccinations[indexPath.row]
        destinationViewController.vaccine = selectedVaccine
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

        }
        
    }
    
    
    //MARK: Private Methods
    @IBAction func unwindToHistoryTable(sender: UIStoryboardSegue){
        
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController

            //vaccinations = vaccinationTabBarController.vaccinations
            //vaccinations += vaccinationTabBarController.ongoingVaccinations
            for i in vaccinationTabBarController.allVaccinations {
                vaccinations.append(i.vaccine)
            }
            vaccinations = Array(Set(vaccinations)).sorted()
            tableView.reloadData()
        
        
        
    }
    
    //MARK: Unwind Functions
    
    @IBAction func unwindToVaccineList(sender: UIStoryboardSegue) {
        let vaccinationTabBarController = tabBarController as! VaccinationTabBarController
        let vaccineTableViewController = storyboard?.instantiateViewController(identifier: "TestVaccineTableViewController") as! TestVaccineTableViewController
        
        
            if let sourceViewController = sender.source as? VaccineViewController, let vaccination = sourceViewController.vaccination {
            // Add a new vaccine
            
            /*if let selectedIndexPath = tableView.indexPathForSelectedRow, let comingVaccination = sourceViewController.comingVaccination {
                
                if vaccineTableViewController.arrayOfArrayOfComingVaccinations[selectedIndexPath.section][selectedIndexPath.row].amountOfDosesTaken! < sourceViewController.comingVaccination!.amountOfDosesTaken! {
                    
                    vaccineTableViewController.comingVaccinations.remove(vaccineTableViewController.arrayOfArrayOfComingVaccinations[selectedIndexPath.section][selectedIndexPath.row])
                    vaccineTableViewController.comingVaccinations.append(comingVaccination)
                    
                }
                
                
                
                
                
                
            }
                
            else {
                if let comingVaccination = sourceViewController.comingVaccination {
                    vaccineTableViewController.comingVaccinations.append(comingVaccination)
                    
                    

                }
                
            }*/
            vaccinationTabBarController.allVaccinations.append(vaccination)
                vaccinationTabBarController.comingVaccinations.append(sourceViewController.comingVaccination!)
                vaccinationTabBarController.vaccinations.append(vaccination)
            vaccinationTabBarController.saveLocally()
                vaccinationTabBarController.save()
            //vaccinationTabBarController.ongoingVaccinations = ongoingVaccinations
            //vaccinationTabBarController.vaccinations = vaccinations
                /*vaccineTableViewController.comingVaccinations.sort()
                vaccineTableViewController.loadArrayOfYears()
                vaccineTableViewController.loadArrayOfArrayOfComingVaccinations()*/
            
            tableView.reloadData()
        }
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, sender: Any?) -> Bool {
        
    
        guard let NavC = self.presentedViewController as? UINavigationController else {
            return false

        }
        
        guard let VVC = NavC.viewControllers[0] as? VaccineViewController else {
            guard let VHTVC = NavC.viewControllers[0] as? VaccineHistoryTableViewController else{
                return false

            }
            return true
        }
        return true
        
        
        
    }
    
    
    
    
    

}
