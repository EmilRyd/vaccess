//
//  ProtectionViewController.swift
//  Vaccess
//
//  Created by emil on 2020-08-25.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import Instructions

class ProtectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoachMarksControllerDataSource, CoachMarksControllerDelegate  {
   
    
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
    
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var datumsFormat = DateFormatter() {
           didSet {
               datumsFormat.dateFormat = "dd/MM - yyyy"
           }
       }
    var pointsOfInterest = [UIView(), UIView(), UIView(), UIView()]
    let coachMarksController = CoachMarksController()
    var walkthroughTitles = ["Här ser du alla vacciner du kan ta. Varje ruta representerar ett specifikt vaccin.", "Till höger i varje ruta kan du se ditt skydd mot vederbörande sjukdom. Det finns tre stadier: Inget, partiellt och fullt.", "Här kan du söka och filtrera för att få fram just den information du vill ha.", "Om du klickar på en ruta får du upp information om sjukdomen och dess vaccin."]
    
    let searchController = UISearchController(searchResultsController: nil)
           var currentVaccineArray = [String]()
           let allContinents = ["Alla", "Fullt", "Partiellt", "Inget"]
           let allScopeTitles = ["Alla", "Fullt", "Partiellt", "Inget"]
       var allVaccines: [String] = []
       var allVaccinesAsProtectedVaccines: [ProtectionVaccine] = []
           var array = [String]()
           var filteredProtectionVaccines: [ProtectionVaccine] = []
           var isSearchBarEmpty: Bool {
               return searchController.searchBar.text?.isEmpty ?? true
           }
           var isFiltering: Bool {
               let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
               return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
               //return searchController.isActive && !isSearchBarEmpty
           }
           
           override func viewDidLoad() {
               super.viewDidLoad()
               
            tableView.delegate = self
            tableView.dataSource = self
                
            searchController.searchBar.setValue("Avbryt", forKey: "cancelButtonText")
           
            
            coachMarksController.dataSource = self
            pointsOfInterest[0] = tableView
            coachMarksController.overlay.isUserInteractionEnabled = true
            datumsFormat.dateFormat = "dd/MM - yyyy"
            let height: CGFloat = 56
            //Fix font layout
            tutorialButton.backgroundColor = Theme.secondaryLight
            tutorialButton.layer.cornerRadius = tutorialButton.frame.height / 2
            tutorialButton.layer.shadowOpacity = 0.25
            tutorialButton.layer.shadowRadius = 5
            tutorialButton.layer.shadowOffset = CGSize(width: 0, height: 10)
            tutorialButton.imageView?.tintColor = .white
            
            
            tutorialButton.frame = CGRect(x: 24, y: UIScreen.main.bounds.height - 24 - height - (self.tabBarController?.tabBar.frame.height ?? 49), width: height, height: height)
            
            
               self.modalPresentationStyle = .fullScreen

               
               for i in Vaccine.allValues {
                   allVaccines.append(i.simpleDescription())
               }
             
               currentVaccineArray = allVaccines
               
               searchController.searchResultsUpdater = self
               searchController.obscuresBackgroundDuringPresentation = false
               searchController.searchBar.placeholder = "Sök efter vaccin"
               navigationItem.searchController = searchController
               
               searchController.searchBar.scopeButtonTitles = ProtectionVaccine.TotalProtection.allCases
               .map { $0.rawValue }
               searchController.searchBar.delegate = self
               
               
               definesPresentationContext = true
               
               
               
               
               self.navigationController?.navigationBar.titleTextAttributes =
               [NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 21)!]
               
               
               self.navigationController!.navigationBar.backgroundColor = .white
               self.navigationController?.navigationBar.shadowImage = UIImage()

               // Uncomment the following line to preserve selection between presentations
               // self.clearsSelectionOnViewWillAppear = false
               
               
               // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
               // self.navigationItem.rightBarButtonItem = self.editButtonItem
               
               
               let longTitleLabel = UILabel()
               longTitleLabel.text = "Mitt skydd"
               longTitleLabel.font = UIFont(name: "Futura-Medium", size: 30)
               longTitleLabel.sizeToFit()
               let leftItem = UIBarButtonItem(customView: longTitleLabel)
               self.navigationItem.leftBarButtonItem = leftItem
               
               
               for i in Vaccine.allValues {
                   
                let protVacc = ProtectionVaccine(name: i.simpleDescription(), protection: "Inget")
                   let vaccinationTabBarController = self.tabBarController as! VaccinationTabBarController
                   if vaccinationTabBarController.coverageForThisVaccine(vaccine: i) == 2 {
                       protVacc.totalProtection = .Fullt
                   }
                   else if vaccinationTabBarController.coverageForThisVaccine(vaccine: i) == 1 {
                       protVacc.totalProtection = .Partiellt
                   }
                   
                   allVaccinesAsProtectedVaccines.append(protVacc)

               }

               
           }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let indexPath = tableView.indexPathsForSelectedRows?[0] else {
            return
        }
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        cell.isSelected = false
    }
       
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
           allVaccinesAsProtectedVaccines = []
           for i in Vaccine.allValues {
               
            let protVacc = ProtectionVaccine(name: i.simpleDescription(), protection: "Inget")
               let vaccinationTabBarController = self.tabBarController as! VaccinationTabBarController
               if vaccinationTabBarController.coverageForThisVaccine(vaccine: i) == 2 {
                   protVacc.totalProtection = .Fullt
               }
               else if vaccinationTabBarController.coverageForThisVaccine(vaccine: i) == 1 {
                   protVacc.totalProtection = .Partiellt
               }
               
               allVaccinesAsProtectedVaccines.append(protVacc)

           }
       }
           
           
           // MARK: - Table view data source
        func numberOfSections(in tableView: UITableView) -> Int {
               // #warning Incomplete implementation, return the number of sections
               return 1
           }

           
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               // #warning Incomplete implementation, return the number of row
               if isFiltering {
                if filteredProtectionVaccines.count == 0 {
                    
                    tutorialButton.isHidden = true
                    
                }
                else {
                    tutorialButton.isHidden = false
                }
                   return filteredProtectionVaccines.count
               }
               else {
                   return allVaccines.count
               }
           }
           
           
           
           
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell else {
                   fatalError("Expected cell to be a CountryTableViewCell but got something else.")
               }
               /*var newImage: UIImage
               switch allCountries[indexPath.row] {
               case "Afghanistan", "Albanien", "Algeriet":
                   newImage = UIImage(named: allCountries[indexPath.row])!
                   
               default:
                   newImage = UIImage(named: "Albanien")!
               }
               newImage = ResizeImage(image: newImage, targetSize: CGSize(width: UIScreen.main.bounds.width, height: 90.0))
               cell.counrtyImage.restorationIdentifier = "Yes"
               cell.counrtyImage.contentMode = .scaleToFill
               
               cell.counrtyImage.image = newImage
               cell.countryLabel.text = allCountries[indexPath.row]
               cell.bringSubview(toFront: cell.countryLabel)
               cell.countryLabel.font = .some(.init(descriptor: .init(name: "Times New Roman", size: 45), size: 45))
               cell.countryLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width
               cell.countryLabel.textColor = .white
               cell.countryLabel.adjustsFontSizeToFitWidth = true
               
               
               cell.layer.cornerRadius = 20;
               cell.layer.masksToBounds = true;*/
               

               
               
              /* if isFiltering {
                   
                   if vaccinationTabBarController.coverageForThisVaccine(vaccine: Vaccine(rawValue: filteredProtectionVaccines[indexPath.row].name)!) == 2 {
                       filteredProtectionVaccines[indexPath.row].totalProtection = .Fullt
                   }
                   else if vaccinationTabBarController.coverageForThisVaccine(vaccine: Vaccine(rawValue: filteredProtectionVaccines[indexPath.row].name)!) == 1 {
                       filteredProtectionVaccines[indexPath.row].totalProtection = .Partiellt
                   }
                   
                   else {
                       allVaccinesAsProtectedVaccines[indexPath.row].totalProtection = .Ingene

                   }
                   
                   cell.countryLabel.text = filteredProtectionVaccines[indexPath.row].name
                   cell.continentLabel.text = filteredProtectionVaccines[indexPath.row].totalProtection.rawValue

               }
               else {
                   
                   if vaccinationTabBarController.coverageForThisVaccine(vaccine: Vaccine(rawValue: allVaccines[indexPath.row])!) == 2 {
                       allVaccinesAsProtectedVaccines[indexPath.row].totalProtection = .Fullt
                   }
                   else if vaccinationTabBarController.coverageForThisVaccine(vaccine: Vaccine(rawValue: allVaccines[indexPath.row])!) == 1 {
                       allVaccinesAsProtectedVaccines[indexPath.row].totalProtection = .Partiellt
                   }
                   else {
                       allVaccinesAsProtectedVaccines[indexPath.row].totalProtection = .Ingen

                   }
                   
                   cell.countryLabel.text = allVaccines[indexPath.row]
                   cell.continentLabel.text = allVaccinesAsProtectedVaccines[indexPath.row].totalProtection.rawValue

               }
    */
               
               if isFiltering {
                   
                   
                   
                   cell.countryLabel.text = filteredProtectionVaccines[indexPath.row].name
                   cell.continentLabel.text = filteredProtectionVaccines[indexPath.row].totalProtection.rawValue

               }
               else {
                   
                   
                   
                   cell.countryLabel.text = allVaccines[indexPath.row]
                   cell.continentLabel.text = allVaccinesAsProtectedVaccines[indexPath.row].totalProtection.rawValue

               }
               
               
                   cell.countryLabel.font = UIFont(name: "Futura-Medium", size: 17.0)
               if indexPath.row == 3 {
                   cell.countryLabel.text = "Haemophilus influenzae typ b"
               }
            
            if indexPath.row == 0 {
                
                /*var walkthroughTitles = ["Här ser du alla vacciner du kan ta.", "Varje ruta representerar ett specifikt vaccin.", "Till höger i varje ruta kan du se ditt skydd mot vederbörande sjukdom. Det finns tre stadier: Inget, partiellt och fullt.", "Här kan du också filtrera för att få fram just den information du vill ha.", "Om du klickar på en ruta får du upp information om sjukdomen och dess vaccin."]*/
                

                    pointsOfInterest[0] = cell.countryLabel
                    pointsOfInterest[1] = cell.continentLabel
                    pointsOfInterest[2] = searchController.searchBar
                    pointsOfInterest[3] = cell

                    
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
           override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
           
           
           
           // MARK: - Navigation
           
           // In a storyboard-based application, you will often want to do a little preparation before navigation
           override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               // Get the new view controller using segue.destination.
               // Pass the selected object to the new view controller.
               let indexPath = tableView.indexPathForSelectedRow
               //let destinationViewController = segue.destination as! ViewController
               //destinationViewController.font = UIFont(name: array[indexPath!.row], size: 17.0)
               
               var vaccine = allVaccines[indexPath!.row]
               
               vaccine = vaccine.lowercased()
               
               let NC = segue.destination as! UINavigationController
               let VC = NC.viewControllers[0] as! VaccineInformationViewController
               
               VC.currentVaccine = makeStringURLCompatible(string: vaccine)
               
               segue.destination.modalPresentationStyle = .fullScreen

            
            
               
               
           }
           
           
           func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
               let size = image.size
               
               let widthRatio  = targetSize.width  / image.size.width
               let heightRatio = targetSize.height / image.size.height
               
               // Figure out what our orientation is, and use that to form the rectangle
               var newSize: CGSize
               if(widthRatio > heightRatio) {
                   newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
               } else {
                   newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
               }
               
               // This is the rect that we've calculated out and this is what is actually used below
               let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
               
               // Actually do the resizing to the rect using the ImageContext stuff
               UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
               image.draw(in: rect)
               let newImage = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               
               
               return newImage!
           }
           
           
           
           
           
           
       func filterContentForSearchText(_ searchText: String, category: ProtectionVaccine.TotalProtection? = nil) {
               filteredProtectionVaccines = allVaccinesAsProtectedVaccines.filter { (protectionVaccine: ProtectionVaccine) -> Bool in
                   let doesCategoryMatch = category == .Alla || protectionVaccine.totalProtection == category
                   
                   if isSearchBarEmpty {
                       return doesCategoryMatch
                   }
                   else {
                       return doesCategoryMatch && protectionVaccine.name.lowercased().contains(searchText.lowercased())
                   }
           }
               tableView.reloadData()
           
           
           }
           
           /*func getContinent(for country: String) -> String {
               if allCountriesInAmerica.contains(country) {
                   return "Amerika"
               }
               else if allCountriesInAsia.contains(country) {
                   return "Asien"
               }
               else if allCountriesInAfrica.contains(country) {
                   return "Afrika"
               }
               else if allCountriesInOceania.contains(country) {
                   return "Oceanien"
               }
               else if allCountriesInEurope.contains(country) {
                   return "Europa"
               }
               else {
                   return "Yeeeeeeeeeeeeeeeeet"
               }
           }*/
       
       //MARK: Special functions
       func makeStringURLCompatible(string: String) -> String {
           let newString = string.lowercased()
           if newString.localizedStandardContains("meningokocker") {
               return "meningokocker"
           }
           if newString.localizedStandardContains("encephalitis") {
               return "tick-borne-encefalitis-tbe"
           }
           var array = Array(newString)
           var iter = 0
           while iter < array.count {
               switch array[iter] {
               case "å", "ä":
                   array[iter] = "a"
               case "ö":
                   array[iter] = "o"
               case " ":
                   array[iter] = "-"
               case "(", ")":
                   array.remove(at: iter)
               default:
                   break
               }
               iter += 1
           }
           
           return String(array)
       }
       
    @IBAction func startWalkthrough(_ sender: UIButton) {
        //Walkthrough
        
        self.coachMarksController.start(in: .window(over: self))
    }
}

       extension ProtectionViewController: UISearchResultsUpdating {
           func updateSearchResults(for searchController: UISearchController) {
               let searchBar = searchController.searchBar
               let continent = ProtectionVaccine.TotalProtection(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
               filterContentForSearchText(searchBar.text!, category: continent)
           }
       }

       extension ProtectionViewController: UISearchBarDelegate {
           func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
               
               let category = ProtectionVaccine.TotalProtection(rawValue: searchBar.scopeButtonTitles![selectedScope])
               filterContentForSearchText(searchBar.text!, category: category)
           }
       }
