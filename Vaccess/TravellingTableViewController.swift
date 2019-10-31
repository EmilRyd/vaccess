//
//  TravellingTableViewController.swift
//  Vaccess
//
//  Created by emil on 2019-10-30.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit

class TravellingTableViewController: UITableViewController {

    let allCountries: [String] = ["Afghanistan"
    ,
    "Albanien"

    ,"Algeriet"

    ,"Amerikanska jungfruöarna"

    ,"Amerikanska Samoa"

    ,  "Andorra"

    ,  "Angola"

    ,  "Anguilla"

    ,  "Antigua och Barbuda"

    ,  "Argentina"

    ,  "Armenien"

    ,  "Aruba"
    ,  "Australien"

    ,"Azerbajdzjan"

    ,"Bahamas"

    ,"Bahrain"

    ,"Bangladesh"

    ,"Barbados"

    ,"Belgien"

    ,"Belize"

    ,"Benin"

    ,"Bermuda"

    ,"Bhutan"

    ,"Bolivia"

    ,"Bosnien Hercegovina"

    ,"Botswana"

    ,"Brasilien"

    ,"Brittiska jungfruöarna"

    ,"Brunei"

    ,"Bulgarien"

    ,"Burkina Faso"

    ,"Burma"

    ,"Burundi"

    ,"Caymanöarna"

    ,"Centralafrikanska republiken"

    ,"Chile"

    ,"Colombia"

    ,"Comorerna"

    ,"Cooköarna"

    ,"Costa Rica"

    ,"Cypern"

    ,"Danmark"

    ,"Dominica"

    ,"Dominikanska republiken"

    ,"Ecuador"

    ,"Egypten"

    ,"Ekvatorialguinea"

    ,"El Salvador"

    ,"Elfenbenskusten"

    ,"England"

    ,"Eritrea"

    ,"Estland"
    ,"Etiopien"

    ,"Falklandsöarna"

    ,"Fiji"

    ,"Filippinerna"

    ,"Finland"

    ,"Frankrike"

    ,"Franska Guyana"

    ,"Franska Polynesien"

    ,"Färöarna"

    ,"Förenade Arabemiraten"

    ,"Gabon"

    ,"Gambia"

    ,"Georgien"

    ,"Ghana"

    ,"Gibraltar"

    ,"Grekland"

    ,"Grenada"

    ,"Grönland"

    ,"Guadeloupe"

    ,"Guam"

    ,"Guatemala"

    ,"Guinea"

    ,"Guinea-Bissau"

    ,"Guyana"

    ,"Haiti"

    ,"Honduras"

    ,"Hongkong"

    ,"Indien"

    ,"Indonesien"

    ,"Irak"

    ,"Iran"

    ,"Irland"

    ,"Island"

    ,"Isle of Man"

    ,"Israel"

    ,"Italien"

    ,"Jamaica"

    ,"Japan"

    ,"Jemen"

    ,"Jordanien"
    
    ,"Kambodja"

    ,"Kamerun"

    ,"Kanada"

    ,"Kenya"

    ,"Kina"

    ,"Kiribati"

    ,"Kongo-Kinshasa"

    ,"Kroatien"

    ,"Kuba"

    ,"Kuwait"

    ,"Laos"

    ,"Lesotho"

    ,"Lettland"

    ,"Libanon"

    ,"Liberia"

    ,"Libyen"

    ,"Liechtenstein"

    ,"Litauen"

    ,"Luxemburg"

    ,"Madagaskar"

    ,"Makedonien"

    ,"Malawi"

    ,"Malaysia"

    ,"Maldiverna"

    ,"Mali"

    ,"Malta"

    ,"Marocko"

    ,"Marshallöarna"

    ,"Martinique"

    ,"Mauritius"

    ,"Mayotte"

    ,"Mexiko"

    ,"Mikronesiens federerade stater"

    ,"Moçambique"

    ,"Moldavien"

    ,"Monaco"

    ,"Mongoliet"

    ,"Namibia"

    ,"Nauru"

    ,"Nederländerna"

    ,"Nederländska Antillerna"

    ,"Nepal"

    ,"Nicaragua"

    ,"Niger"

    ,"Nigeria"

    ,"Nordkorea"

    ,"Norge"

    ,"Nya Zeeland"

    ,"Oman"

    ,"Pakistan"

    ,"Panama"

    ,"Papua Nya Guinea"

    ,"Paraguay"

    ,"Peru"

    ,"Pitcairnöarna"

    ,"Polen"

    ,"Portugal"

    ,"Puerto Rico"

    ,"Reunion"

    ,"Rumänien"

    ,"Rwanda"

    ,"Ryssland"

    ,"Saint Christopher och Nevis"

    ,"Saint Helena"

    ,"Saint Lucia"

    ,"Saint Vincent och Grenadinerna"
    ,"Saint-Pierre-et-Miquelon"

    ,"Salomonöarna"

    ,"Samoa"

    ,"São Tomé och Príncipe"

    ,"Saudiarabien"

    ,"Schweiz"

    ,"Senegal"

    ,"Serbien"

    ,"Sierra Leone"
    
    ,"Singapore"

    ,"Skottland"

    ,"Slovakien"

    ,"Slovenien"

    ,"Spanien"

    ,"Sri Lanka"

    ,"Storbritannien"

    ,"Sudan"

    ,"Surinam"
    ,"Sverige"

    ,"Swaziland"

    ,"Sydafrika"

    ,"Sydkorea"

    ,"Syrien"

    ,"Taiwan"

    ,"Tanzania"

    ,"Tchad"

    ,"Thailand"

    ,"Tjeckien"

    ,"Togo"

    ,"Tonga"

    ,"Trinidad och Tobago"

    ,"Tunisien"

    ,"Turkiet"

    ,"Turkmenistan"

    ,"Turks- och Caicosöarna"

    ,"Tuvalu"

    ,"Tyskland"

    ,"Uganda"

    ,"Ukraina"

    ,"Ungern"

    ,"Uruguay"

    ,"USA"

    ,"Uzbekistan"

    ,"Vanuatu"

    ,"Venezuela"

    ,"Vietnam"

    ,"Vitryssland"

    ,"Wales"

    ,"Wallis och Futuna"

    ,"Zambia"

    ,"Zimbabwe"

    ,"Österrike"

    ,"Östtimor"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allCountries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell else {
            fatalError("Expected cell to be a CountryTableViewCell but got something else.")
        }
        var newImage: UIImage
        switch allCountries[indexPath.row] {
        case "Afghanistan", "Albanien", "Algeriet":
            newImage = UIImage(named: allCountries[indexPath.row])!
            
        default:
            newImage = UIImage(named: "Albanien")!
        }
        newImage = ResizeImage(image: newImage, targetSize: CGSize(width: UIScreen.main.bounds.width, height: 300.0))
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
        cell.layer.masksToBounds = true;

        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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

}
