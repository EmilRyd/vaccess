//
//  TravellingTableViewController.swift
//  Vaccess
//
//  Created by emil on 2019-10-30.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit

class TravellingTableViewController: UITableViewController{//MARK: Properties
    let searchController = UISearchController(searchResultsController: nil)
    var currentCountryArray = [String]()
    let allContinents = ["Afrika", "Asien", "Europa", "Oceanien", "Amerika"]
    let allScopeTitles = ["Alla", "Afrika", "Asien", "Europa", "Oceanien", "Amerika"]
    var allCountries: [String] = ["Afghanistan","Albanien","Algeriet","Amerikanska jungfruöarna","Amerikanska Samoa",  "Andorra",  "Angola",  "Anguilla",  "Antigua och Barbuda",  "Argentina",  "Armenien",  "Aruba"
    ,  "Australien","Azerbajdzjan","Bahamas","Bahrain","Bangladesh","Barbados","Belgien","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnien Hercegovina","Botswana","Brasilien","Brittiska jungfruöarna","Brunei","Bulgarien","Burkina Faso","Burma","Burundi","Caymanöarna","Centralafrikanska republiken","Chile","Colombia","Comorerna","Cooköarna","Costa Rica","Cypern","Danmark","Dominica","Dominikanska republiken","Ecuador","Egypten","Ekvatorialguinea","El Salvador","Elfenbenskusten","England","Eritrea","Estland"
    ,"Etiopien","Falklandsöarna","Fiji","Filippinerna","Finland","Frankrike","Franska Guyana","Franska Polynesien","Färöarna","Förenade Arabemiraten","Gabon","Gambia","Georgien","Ghana","Gibraltar","Grekland","Grenada","Grönland","Guadeloupe","Guam","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hongkong","Indien","Indonesien","Irak","Iran","Irland","Island","Isle of Man","Israel","Italien","Jamaica","Japan","Jemen","Jordanien"
    
    ,"Kambodja","Kamerun","Kanada","Kenya","Kina","Kiribati","Kongo-Kinshasa","Kroatien","Kuba","Kuwait","Laos","Lesotho","Lettland","Libanon","Liberia","Libyen","Liechtenstein","Litauen","Luxemburg","Madagaskar","Makedonien","Malawi","Malaysia","Maldiverna","Mali","Malta","Marocko","Marshallöarna","Martinique","Mauritius","Mayotte","Mexiko","Mikronesiens federerade stater","Moçambique","Moldavien","Monaco","Mongoliet","Namibia","Nauru","Nederländerna","Nederländska Antillerna","Nepal","Nicaragua","Niger","Nigeria","Nordkorea","Norge","Nya Zeeland","Oman","Pakistan","Panama","Papua Nya Guinea","Paraguay","Peru","Pitcairnöarna","Polen","Portugal","Puerto Rico","Reunion","Rumänien","Rwanda","Ryssland","Saint Christopher och Nevis","Saint Helena","Saint Lucia","Saint Vincent och Grenadinerna"
    ,"Saint-Pierre-et-Miquelon","Salomonöarna","Samoa","São Tomé och Príncipe","Saudiarabien","Schweiz","Senegal","Serbien","Sierra Leone"
    
    ,"Singapore","Skottland","Slovakien","Slovenien","Spanien","Sri Lanka","Storbritannien","Sudan","Surinam"
    ,"Sverige","Swaziland","Sydafrika","Sydkorea","Syrien","Taiwan","Tanzania","Tchad","Thailand","Tjeckien","Togo","Tonga","Trinidad och Tobago","Tunisien","Turkiet","Turkmenistan","Turks- och Caicosöarna","Tuvalu","Tyskland","Uganda","Ukraina","Ungern","Uruguay","USA","Uzbekistan","Vanuatu","Venezuela","Vietnam","Vitryssland","Wales","Wallis och Futuna","Zambia","Zimbabwe","Österrike"
        
    ,"Östtimor"]
    
    let allCountriesInAfrica = ["Algeriet", "Angola", "Benin", "Botswana","Burkina Faso","Burundi","Centralafrikanska republiken","Demokratiska Republiken Kongo", "Djibouti", "Egypten","Ekvatorialguinea","Elfenbenskusten","Eritrea"
    ,"Etiopien","Gabon","Gambia","Ghana","Guinea-Bissau","Guinea-Conacry", "Guyana","Kamerun","Kanarieöarna","Kap Verde","Kenya","Komorerna","Lesotho","Liberia","Libyen","Madagaskar","Malawi","Mali","Marocko","Mauretanien","Mauritius","Moçambique","Namibia","Niger","Nigeria","Republiken Kongo","Rwanda","São Tomé och Príncipe","Senegal","Sierra Leone"
    
    ,"Somalia","Sudan","Swaziland","Sydafrika","Tanzania","Tchad","Togo","Tunisien","Uganda","Zanzibar","Zambia","Zimbabwe"]
    
    let allCountriesInEurope = ["Albanien","Andorra","Azorerna","Bosnien Hercegovina","Bulgarien","Danmark","Estland","Finland","Frankrike","Grekland","Italien","Kosovo","Kroatien","Lettland","Liechtenstein","Litauen","Madeira","Makedonien","Malta","Moldavien","Monaco","Montenegro","Norge","Polen","Portugal","Rumänien","Serbien","Slovakien","Slovenien","Spanien","Tjeckien","Tyskland","Ukraina","Ungern","Vitryssland","Österrike"]
    
    let allCountriesInAsia = ["Afghanistan","Armenien", "Azerbajdzjan","Bahrain","Bali","Bangladesh","Bhutan","Brunei","Cypern","Filippinerna","Förenade Arabemiraten","Georgien","Hongkong","Indien","Indonesien","Irak","Iran","Israel","Japan","Jemen","Jordanien"
    
    ,"Kambodja","Kazakhstan","Kina","Kirgizistan","Kuwait","Laos","Libanon","Malaysia","Maldiverna","Mongoliet","Myanmar","Nepal","Nordkorea","Nya Guinea","Oman","Pakistan","Palestina","Qatar","Ryssland","Saudiarabien",
    
    "Singapore","Sri Lanka","Sydkorea","Syrien","Tadzjikistan","Taiwan","Thailand","Turkiet","Turkmenistan","Uzbekistan","Vietnam"
        
    ,"Östtimor"]
    
    let allCountriesInOceania = ["Amerikanska Samoa",
     "Australien","Cooköarna","Fiji","Marshallöarna","Mikronesien","Nauru","Nya Kaledonien","Nya Zeeland","Papua Nya Guinea","Salomonöarna","Samoa","Tahiti", "Tokelau","Tonga","Tuvalu","Vanuatu","Wake Island"]
    
    let allCountriesInNorthAmerica = ["Amerikanska jungfruöarna","Amerikanska Samoa","Anguilla",  "Antigua och Barbuda",  "Aruba"
        ,  "Bahamas","Barbados","Belize","Bermuda","Brittiska jungfruöarna","Caymanöarna","Costa Rica","Curacao","Dominica","Dominikanska republiken","El Salvador","Grenada","Grenadinerna","Guadeloupe","Guatemala","Haiti","Hawaii","Honduras","Jamaica","Kanada","Martinique","Mexiko","Montserrat","Nicaragua","Panama","Puerto Rico","Saint Christopher och Nevis","Saint Lucia","Saint Vincent",
   "Trinidad och Tobago","USA"]
    
    let allCountriesInSouthAmerica = ["Argentina","Bolivia","Brasilien","Chile","Colombia","Ecuador","Franska Guyana","Galapagosöarna","Guyana","Isla Margerita","Kuba","Paraguay","Peru","Saint Barthélemy",
    "Uruguay","Venezuela"]
    
    var allCountriesInAmerica: [String] = []
    
    var allCountriesAsCountries: [Country] = []
    
    var array = [String]()
    var filteredCountries: [Country] = []
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
        
        allCountriesInAmerica = allCountriesInSouthAmerica + allCountriesInNorthAmerica
        allCountries = allCountriesInAsia + allCountriesInAfrica + allCountriesInEurope + allCountriesInOceania + allCountriesInAmerica
        
        allCountries.sort()
        
        currentCountryArray = allCountries
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Sök efter länder"
        navigationItem.searchController = searchController
        
        searchController.searchBar.scopeButtonTitles = Country.Continent.allCases
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
        longTitleLabel.text = "Resor"
        longTitleLabel.font = UIFont(name: "Futura-Medium", size: 30)
        longTitleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        var x = 0
        for i in allCountries {
            allCountriesAsCountries.append(Country(name: i, continent: getContinent(for: i)))
     x += 1
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
            return filteredCountries.count
        }
        else {
            return allCountries.count
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
        
        if isFiltering {
            cell.countryLabel.text = filteredCountries[indexPath.row].name
            cell.continentLabel.text = filteredCountries[indexPath.row].continent.rawValue

        }
        else {
            cell.countryLabel.text = allCountries[indexPath.row]
            cell.continentLabel.text = getContinent(for: cell.countryLabel.text!)

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
        let destinationViewController = segue.destination as! CountryViewController
        destinationViewController.font = UIFont(name: array[indexPath!.row], size: 17.0)
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
    
    
    
    
    
    
    func filterContentForSearchText(_ searchText: String, category: Country.Continent? = nil) {
        filteredCountries = allCountriesAsCountries.filter { (country: Country) -> Bool in
            let doesCategoryMatch = category == .Alla || country.continent == category
            
            if isSearchBarEmpty {
                return doesCategoryMatch
            }
            else {
                return doesCategoryMatch && country.name.lowercased().contains(searchText.lowercased())
            }
    }
        tableView.reloadData()
    
    
    }
    
    func getContinent(for country: String) -> String {
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
    }
}

extension TravellingTableViewController: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let continent = Country.Continent(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text!, category: continent)
    }
}

extension TravellingTableViewController: UISearchBarDelegate {
    func travellingsearchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        let category = Country.Continent(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)
    }
}


