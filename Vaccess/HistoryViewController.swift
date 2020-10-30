//
//  HistoryViewController.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-10-02.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit
import os.log
import Instructions
class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    
    
    
    //MARK: CoachMarksControllerDataSource
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = walkthroughTitles[index]
        coachViews.bodyView.background.innerColor = Theme.primary
        coachViews.arrowView?.background.innerColor = Theme.primary
        coachViews.bodyView.hintLabel.font = UIFont(name: "Futura-medium", size: 15)
        coachViews.bodyView.hintLabel.textColor = .white
        coachViews.bodyView.separator.isHidden = true
        coachViews.bodyView.nextLabel.isHidden = true

        if index == walkthroughTitles.count - 1 {
            coachViews.bodyView.nextLabel.text = ""

        }
        else {
            coachViews.bodyView.nextLabel.text = ""

        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        
        return coachMarksController.helper.makeCoachMark(for: pointsOfInterest[index])
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return pointsOfInterest.count
    }
    
    
    
    
    
    //MARK: Outlets
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tutorialButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: Variables and properties
    
    var vaccinations = [Vaccine]()
    var datumsFormat = DateFormatter() {
        didSet {
            datumsFormat.dateFormat = "dd/MM - yyyy"
        }
    }

    var pointsOfInterest = [UIView(), UIView()]
    let coachMarksController = CoachMarksController()
    var walkthroughTitles = ["Här ser du de vaccin du tagit. Om du klickar på en ruta kan du se din kompletta historik för det vaccinet.", "Här kan du klicka för att lägga till ett vaccin du tagit."]
    
    
    //MARK: Table View Data Source and Delegate Protocol Stubs
    
    
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
            tutorialButton.isHidden = true
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
        if indexPath.row == 0 {
            pointsOfInterest[0] = cell
            pointsOfInterest[1] = addButton
        }
        
        
        if tableView.numberOfSections != 0 {
            tutorialButton.isHidden = false
        }
        else {
            tutorialButton.isHidden = true

        }
        
        
        
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
        
        //Configure tutorialButton
        tutorialButton.isHidden = true
        let height: CGFloat = 56

        coachMarksController.dataSource = self
        //pointsOfInterest[0] = tableView
        coachMarksController.overlay.isUserInteractionEnabled = true
        datumsFormat.dateFormat = "dd/MM - yyyy"
        //Fix font layout
        tutorialButton.backgroundColor = Theme.secondaryLight
        tutorialButton.layer.cornerRadius = tutorialButton.frame.height / 2
        tutorialButton.layer.shadowOpacity = 0.25
        tutorialButton.layer.shadowRadius = 5
        tutorialButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        tutorialButton.imageView?.tintColor = .white
        tutorialButton.tintColor = .white
        //tutorialButton.imageView?.backgroundColor = .white
        
        tutorialButton.frame = CGRect(x: 24, y: UIScreen.main.bounds.height - 24 - height - (self.tabBarController?.tabBar.frame.height ?? 49), width: height, height: height)
        
        //Configure the add button a bit
        //Fix font layout
        addButton.backgroundColor = Theme.secondaryDark
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
            destinationViewController.modalPresentationStyle = .fullScreen
        
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
        let vaccineTableViewController: TestVaccineTableViewController
        if #available(iOS 13.0, *) {
            vaccineTableViewController = storyboard?.instantiateViewController(identifier: "TestVaccineTableViewController") as! TestVaccineTableViewController
        } else {
            // Fallback on earlier versions
            vaccineTableViewController = storyboard?.instantiateViewController(withIdentifier: "TestVaccineTableViewController") as! TestVaccineTableViewController
        }
        
        
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
                if sourceViewController.comingVaccination != nil {
                    vaccinationTabBarController.comingVaccinations.append(sourceViewController.comingVaccination!)

                }
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
    
    
    @IBAction func startWalkthourgh(_ sender: UIButton) {
        if tableView.numberOfSections == 0 {
            //pointsOfInterest = [UIView(frame: (self.navigationController?.navigationBar.frame)!)]
            walkthroughTitles = ["Du har för tillfället inga kommande vaccinationer. När du har det kan du klicka på frågetecknet för mer information."]
        }
        self.coachMarksController.start(in: .window(over: self))
    }
    
    
    

}
