//
//  VaccinationTabBarController.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-26.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit
import Parse

class VaccinationTabBarController: UITabBarController  {

    //MARK: Properties
    var vaccinations = [Vaccination]()
    var allVaccinations = [Vaccination]()
    var ongoingVaccinations = [Vaccination]()
    var comingVaccinations = [Vaccination]()
    var locallyModified: Bool?
    
    var vaccinationsWereChangedInVaccinationHistoryTableViewController: Bool = false
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = PFUser.current()
        user?.setObject(try? PropertyListEncoder().encode(vaccinations), forKey: "Vaccinations")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   /* init(vaccinations: [Vaccination], allVaccinations: [Vaccination], ongoingVaccinations: [Vaccination])  {
        self.vaccinations = vaccinations
        self.allVaccinations = allVaccinations
        self.ongoingVaccinations = ongoingVaccinations
        super.init(nibName: nil, bundle: nil)
        
    }*/
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func save() {
        
        
        let defaults = UserDefaults.standard
        
        /*var dictionary = defaults.dictionary(forKey: "users")
        
        var newDictionary: [String:[[Vaccination]]]
        let controller = [vaccinations, allVaccinations, ongoingVaccinations]
        if dictionary != nil {
            dictionary![PFUser.current()!.email!] = controller
            newDictionary = dictionary as! [String : [[Vaccination]]]
        }
        else {
            newDictionary = [PFUser. ()!.email!: controller]
        }*/
        // Use PropertyListEncoder to convert Player into Data / NSData
        defaults.set(try? PropertyListEncoder().encode(vaccinations), forKey: "vaccinations")
        defaults.set(try? PropertyListEncoder().encode(allVaccinations), forKey: "allVaccinations")
        defaults.set(try? PropertyListEncoder().encode(ongoingVaccinations), forKey: "ongoingVaccinations")
        
        
        
        
        let vaccinationTabBarController = PFObject(className: "VaccinationTabBarController")
        let user = PFUser.current()
        let jsonEncoder = JSONEncoder()
        let jsonDataV = try? jsonEncoder.encode(vaccinations)
        let jsonV = String(data: jsonDataV!, encoding: String.Encoding.utf8)
        let jsonDataAV = try? jsonEncoder.encode(allVaccinations)
        let jsonAV = String(data: jsonDataAV!, encoding: String.Encoding.utf8)
        let jsonDataOV = try? jsonEncoder.encode(ongoingVaccinations)
        let jsonOV = String(data: jsonDataOV!, encoding: String.Encoding.utf8)
        PFUser.enableRevocableSessionInBackground()
               

        vaccinationTabBarController["vaccinations"] = jsonV
        vaccinationTabBarController["allVaccinations"] = jsonAV
        vaccinationTabBarController["ongoingVaccinations"] = jsonOV
        vaccinationTabBarController["user"] = user?.email
        
        let query = PFQuery(className: "VaccinationTabBarController")
        let pfUser = PFUser.current()!
        let updatedQuery = query.whereKey("user", equalTo: pfUser.email)
        var objects: [PFObject]? = nil
        
        do {
            objects = try updatedQuery.findObjects()
            
        }
        catch {
            
        }
        if !objects!.isEmpty {
            objects![0]["vaccinations"] = jsonV
            objects![0]["allVaccination"] = jsonAV
            objects![0]["ongoingVaccinations"] = jsonOV
            objects![0].saveInBackground {
                (success: Bool, error: Error?) in
                  if (success) {
                    // The object has been saved.
                  } else {
                    print (error?.localizedDescription)
                  }
                
            }
        }
        
        else {
        vaccinationTabBarController.saveInBackground {
            (success: Bool, error: Error?) in
              if (success) {
                // The object has been saved.
              } else {
                print (error?.localizedDescription)
              }
            
        }
        }

        
        
        
        locallyModified = false
    }
    
    
    func saveLocally() {
        let defaults = UserDefaults.standard
        defaults.set(try? PropertyListEncoder().encode(vaccinations), forKey: "vaccinations")
        defaults.set(try? PropertyListEncoder().encode(allVaccinations), forKey: "allVaccinations")
        defaults.set(try? PropertyListEncoder().encode(ongoingVaccinations), forKey: "ongoingVaccinations")
    }
    
    func loadFrom(defaults: UserDefaults) {
        
        
        /*guard let vaccinationsData = defaults.object(forKey: "vaccinations") as? Data else {
            return
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let vaccinations = try? PropertyListDecoder().decode(Array<Vaccination>.self, from: vaccinationsData) else {
            return
        }
        
        guard let allVaccinationsData = defaults.object(forKey: "allVaccinations") as? Data else {
                   return
               }
               
               // Use PropertyListDecoder to convert Data into Player
               guard let allVaccinations = try? PropertyListDecoder().decode(Array<Vaccination>.self, from: allVaccinationsData) else {
                   return
               }
        
        guard let ongoingVaccinationsData = defaults.object(forKey: "ongoingVaccinations") as? Data else {
                   return
               }
               
               // Use PropertyListDecoder to convert Data into Player
               guard let ongoingVaccinations = try? PropertyListDecoder().decode(Array<Vaccination>.self, from: ongoingVaccinationsData) else {
                   return
               }
        let user = PFUser.current()
        guard let serverVaccinationsData = user?.object(forKey: "Vaccinations") as? Data else {
            return
        }
            guard let serverVaccinations = try? PropertyListDecoder().decode(Array<Vaccination>.self, from: serverVaccinationsData) else {
                return
            }
        guard let serverAllVaccinationsData = user?.object(forKey: "allVaccinations") as? Data else {
            return
        }
            guard let serverAllVaccinations = try? PropertyListDecoder().decode(Array<Vaccination>.self, from: serverAllVaccinationsData) else {
                return
            }
        guard let serverOngoingVaccinationsData = user?.value(forKey: "OngoingVaccinations") as? Data else {
            return
        }
            guard let serverOngoingVaccinations = try? PropertyListDecoder().decode(Array<Vaccination>.self, from: serverOngoingVaccinationsData) else {
                return
            }*/
        
        if locallyModified == true {
            guard let vaccinationsData = defaults.object(forKey: "vaccinations") as? Data else {
                return
            }
            
            // Use PropertyListDecoder to convert Data into Player
            guard let vaccinations = try? PropertyListDecoder().decode(Array<Vaccination>.self, from: vaccinationsData) else {
                return
            }
            
            guard let allVaccinationsData = defaults.object(forKey: "allVaccinations") as? Data else {
                       return
                   }
                   
                   // Use PropertyListDecoder to convert Data into Player
                   guard let allVaccinations = try? PropertyListDecoder().decode(Array<Vaccination>.self, from: allVaccinationsData) else {
                       return
                   }
            
            guard let ongoingVaccinationsData = defaults.object(forKey: "ongoingVaccinations") as? Data else {
                       return
                   }
                   
                   // Use PropertyListDecoder to convert Data into Player
                   guard let ongoingVaccinations = try? PropertyListDecoder().decode(Array<Vaccination>.self, from: ongoingVaccinationsData) else {
                       return
                   }
            self.vaccinations = vaccinations
            self.allVaccinations = allVaccinations
            self.ongoingVaccinations = ongoingVaccinations
        }
        else {
            let query = PFQuery(className: "VaccinationTabBarController")
            let pfUser = PFUser.current()!
            let updatedQuery = query.whereKey("user", equalTo: pfUser.email)
            var objects: [PFObject]? = nil
            do {
                objects = try updatedQuery.findObjects()
                print(objects)
            }
            catch {
                
            }
            if objects?.count == 1 {
                let jsonDecoder = JSONDecoder()
                let jsonStringV = objects![0]["vaccinations"] as! String
                let jsonDataV = jsonStringV.data(using: .utf8)
                let jsonV = try? jsonDecoder.decode([Vaccination].self, from: jsonDataV!)
                let jsonStringAV = objects![0]["allVaccinations"] as! String
                let jsonDataAV = jsonStringAV.data(using: .utf8)
                let jsonAV = try? jsonDecoder.decode([Vaccination].self, from: jsonDataAV!)
                let jsonStringOV = objects![0]["ongoingVaccinations"] as! String
                let jsonDataOV = jsonStringOV.data(using: .utf8)
                let jsonOV = try? jsonDecoder.decode([Vaccination].self, from: jsonDataOV!)
                self.vaccinations = jsonV!
                self.allVaccinations = jsonAV!
                self.ongoingVaccinations = jsonOV!
            }
            
        }
        
            
        
                
                
                }
            
        
        
        
        
        
    }



