//
//  ProtectionTableTableViewController.swift
//  Vaccess
//
//  Created by emil on 2020-05-13.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class ProtectionTableTableViewController: UITableViewController {
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
            UIFont.familyNames.forEach({ familyName in
                let fontNames = UIFont.fontNames(forFamilyName: familyName)
                array.append(familyName)
                array = array.sorted()
                print(familyName)
            })
            
            
            
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
                
                var protVacc = ProtectionVaccine(name: i.simpleDescription(), protection: "Ingen")
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        allVaccinesAsProtectedVaccines = []
        for i in Vaccine.allValues {
            
            var protVacc = ProtectionVaccine(name: i.simpleDescription(), protection: "Ingen")
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
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of row
            if isFiltering {
                return filteredProtectionVaccines.count
            }
            else {
                return allVaccines.count
            }
        }
        
        
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            let vaccinationTabBarController = self.tabBarController as! VaccinationTabBarController

            
            
           /* if isFiltering {
                
                if vaccinationTabBarController.coverageForThisVaccine(vaccine: Vaccine(rawValue: filteredProtectionVaccines[indexPath.row].name)!) == 2 {
                    filteredProtectionVaccines[indexPath.row].totalProtection = .Fullt
                }
                else if vaccinationTabBarController.coverageForThisVaccine(vaccine: Vaccine(rawValue: filteredProtectionVaccines[indexPath.row].name)!) == 1 {
                    filteredProtectionVaccines[indexPath.row].totalProtection = .Partiellt
                }
                
                else {
                    allVaccinesAsProtectedVaccines[indexPath.row].totalProtection = .Ingen

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
    }

    extension ProtectionTableTableViewController: UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            let searchBar = searchController.searchBar
            let continent = ProtectionVaccine.TotalProtection(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
            filterContentForSearchText(searchBar.text!, category: continent)
        }
    }

    extension ProtectionTableTableViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            
            let category = ProtectionVaccine.TotalProtection(rawValue: searchBar.scopeButtonTitles![selectedScope])
            filterContentForSearchText(searchBar.text!, category: category)
        }
    }
