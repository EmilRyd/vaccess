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
    let alertService = AlertService()
    var vaccinations = [Vaccination]()
    var allVaccinations = [Vaccination]()
    var ongoingVaccinations = [Vaccination]()
    var comingVaccinations = [Vaccination]()
    var vaccinationsTakenInTime = [Vaccination]()
    var vaccinationsNotTakenInTime = [Vaccination]()
    var profileImage = UIImage()
    var locallyModified: Bool?
    var vaccinationProgramIndicatorWasChangedThisSession: Bool = false 
    
    var vaccinationsWereChangedInVaccinationHistoryTableViewController: Bool = false
    let arrayOfVaccinesInVaccinationProgramForBoys: [Vaccine] = [
        .Difteri,
        .Kikhosta,
        .Stelkramp,
        .Polio,
        .Haemophilus_influenzae_typ_b_Hib,
        
        .Pneumokocker,
        .Mässling,
        .Påssjuka,
        .Röda_hund,
        .Rotavirus,
        .Hepatit_B,
        .Humant_papillomvirus_HPV
    ]
    
    let arrayOfVaccinesInVaccinationProgramForGirls: [Vaccine] = [
        .Difteri,
        .Kikhosta,
        .Stelkramp,
        .Polio,
        .Haemophilus_influenzae_typ_b_Hib,
        
        .Pneumokocker,
        .Mässling,
        .Påssjuka,
        .Röda_hund,
        .Rotavirus,
        .Hepatit_B,
        .Humant_papillomvirus_HPV
    ]
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //Fix some layout things
        
    

        
        
        let user = PFUser.current()
        //user?.setObject(try? PropertyListEncoder().encode(vaccinations), forKey: "Vaccinations")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //askToSendPushNotifications()
        
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
    
    //MARK: Data Loading and Saving
    
    func save() -> Bool {
        
        var bool: Bool = true

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
        defaults.set(try? PropertyListEncoder().encode(comingVaccinations), forKey: "comingVaccinations")
        //defaults.set(try? PropertyListEncoder().encode(profileImage), forKey: "profileImage")

        
        
        let vaccinationTabBarController = PFObject(className: "VaccinationTabBarController")
        let user = PFUser.current()
        let jsonEncoder = JSONEncoder()
        
        let jsonDataV = try? jsonEncoder.encode(vaccinations)
        let jsonV = String(data: jsonDataV!, encoding: String.Encoding.utf8)
        
        let jsonDataAV = try? jsonEncoder.encode(allVaccinations)
        let jsonAV = String(data: jsonDataAV!, encoding: String.Encoding.utf8)
        
        let jsonDataOV = try? jsonEncoder.encode(comingVaccinations)
        let jsonOV = String(data: jsonDataOV!, encoding: String.Encoding.utf8)
        
        PFUser.enableRevocableSessionInBackground()
               

        vaccinationTabBarController["vaccinations"] = jsonV
        vaccinationTabBarController["allVaccinations"] = jsonAV
        vaccinationTabBarController["comingVaccinations"] = jsonOV
        vaccinationTabBarController["user"] = user?.email
        
        let query = PFQuery(className: "VaccinationTabBarController")
        let pfUser = PFUser.current()!
        let updatedQuery = query.whereKey("user", equalTo: pfUser.email!)
        var objects: [PFObject]? = nil
        
        do {
            objects = try updatedQuery.findObjects()
            
        }
        catch {
            
        }
        if objects == nil {
            return false
        }
        else if !objects!.isEmpty {
            objects![0]["vaccinations"] = jsonV
            objects![0]["allVaccinations"] = jsonAV
            objects![0]["comingVaccinations"] = jsonOV
            objects![0].saveInBackground {
                (success: Bool, error: Error?) in
                  if (success) {
                    // The object has been saved.
                    bool = true
                  } else {
                    bool = true
                    

                    print (error?.localizedDescription)
                  }
                
            }
        }
        
        else {
        vaccinationTabBarController.saveInBackground {
            (success: Bool, error: Error?) in
              if (success) {
                // The object has been saved.
                bool = true
              } else {
                bool = true
                
                
                
                print (error?.localizedDescription)
              }
        }

        }

        
        
        return bool

        locallyModified = false
    }
    
    
    func saveLocally() {
        let defaults = UserDefaults.standard
        defaults.set(try? PropertyListEncoder().encode(vaccinations), forKey: "vaccinations")
        defaults.set(try? PropertyListEncoder().encode(allVaccinations), forKey: "allVaccinations")
        defaults.set(try? PropertyListEncoder().encode(comingVaccinations), forKey: "comingVaccinations")
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
            
            guard let ongoingVaccinationsData = defaults.object(forKey: "comingVaccinations") as? Data else {
                       return
                   }
                   
                   // Use PropertyListDecoder to convert Data into Player
                   guard let ongoingVaccinations = try? PropertyListDecoder().decode(Array<Vaccination>.self, from: ongoingVaccinationsData) else {
                       return
                   }
            self.vaccinations = vaccinations
            self.allVaccinations = allVaccinations
            self.comingVaccinations = ongoingVaccinations
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
                
                let jsonStringOV = objects![0]["comingVaccinations"] as! String
                let jsonDataOV = jsonStringOV.data(using: .utf8)
                let jsonOV = try? jsonDecoder.decode([Vaccination].self, from: jsonDataOV!)
                
                self.vaccinations = jsonV!
                self.allVaccinations = jsonAV!
                self.comingVaccinations = jsonOV!
            }
            
        }
        
            
        
                
                
                }
            
        
  /*  func getPercentageOfCurrentTreatmentsFinsihed() -> Double {
        var vaccines = [Vaccine]()
        for i in allVaccinations {
            vaccines.append(i.vaccine)
        }
        vaccines = Array(Set(vaccines))
        
        var a = 0
        var arrayOfArrays = [[Vaccination]]()
        while a < vaccines.count {
            arrayOfArrays.append([Vaccination]())
            
            a += 1
        }
        
    
        var b = 0
        var c = 0
        for i in vaccines {
            
            for x in allVaccinations {
                if i == x.vaccine {
                    arrayOfArrays[b].append(x)
                }
                c += 1
            }
            
            b += 1
        }
        var e = 0
        while e < arrayOfArrays.count {
            arrayOfArrays[e] = arrayOfArrays[e].sorted()
            
            e += 1
        }
        
        var f = 0
        var totalOfLastTakens = 0
        var totalOfDoseCapacities = 0
        while f < arrayOfArrays.count {
            totalOfLastTakens = totalOfLastTakens + (arrayOfArrays[f].last!.amountOfDosesTaken ?? 0)
            totalOfDoseCapacities = totalOfDoseCapacities + arrayOfArrays[f].last!.vaccine.getTotalAmountOfDoses()
            
            f += 1
        }
        print(totalOfLastTakens)
        print(totalOfDoseCapacities)
        return Double(totalOfLastTakens)/Double(totalOfDoseCapacities)
        
        
    }*/
    
    func setVaccinationProgramVaccinationsFromDate(_ date: Date, setComingVaccinations vaccBool: Bool) {
         let RotaVirusVaccination1 = Vaccination(vaccine: .Rotavirus, startDate: date + 3628800, amountOfDosesTaken: 1)!
         
         
         let DifteriVaccination1 = Vaccination(vaccine: .Difteri, startDate: date + 7905600, amountOfDosesTaken: 1)!
         let StelkrampVaccination1 = Vaccination(vaccine: .Stelkramp, startDate: date + 7905600, amountOfDosesTaken: 1)!
         let KikhostaVaccination1 = Vaccination(vaccine: .Kikhosta, startDate: date + 7905600, amountOfDosesTaken: 1)!
         let PolioVaccination1 = Vaccination(vaccine: .Polio, startDate: date + 7905600, amountOfDosesTaken: 1)!
         let HibVaccination1 = Vaccination(vaccine: .Haemophilus_influenzae_typ_b_Hib, startDate: date + 7905600, amountOfDosesTaken: 1)!
         let HepatitBVaccination1 = Vaccination(vaccine: .Hepatit_B, startDate: date + 7905600, amountOfDosesTaken: 1)!
         let PneumokockerVaccination1 = Vaccination(vaccine: .Pneumokocker, startDate: date + 7905600, amountOfDosesTaken: 1)!
         let RotaVirusVaccination2 = Vaccination(vaccine: .Rotavirus, startDate: date + 7905600, amountOfDosesTaken: 2)!

        
         let DifteriVaccination2 = Vaccination(vaccine: .Difteri, startDate: date + 13176000, amountOfDosesTaken: 2)!
         let StelkrampVaccination2 = Vaccination(vaccine: .Stelkramp, startDate: date + 13176000, amountOfDosesTaken: 2)!
         let KikhostaVaccination2 = Vaccination(vaccine: .Kikhosta, startDate: date + 13176000, amountOfDosesTaken: 2)!
         let PolioVaccination2 = Vaccination(vaccine: .Polio, startDate: date + 13176000, amountOfDosesTaken: 2)!
         let HibVaccination2 = Vaccination(vaccine: .Haemophilus_influenzae_typ_b_Hib, startDate: date + 13176000, amountOfDosesTaken: 2)!
         let HepatitBVaccination2 = Vaccination(vaccine: .Hepatit_B, startDate: date + 13176000, amountOfDosesTaken: 2)!
         let PneumokockerVaccination2 = Vaccination(vaccine: .Pneumokocker, startDate: date + 13176000, amountOfDosesTaken: 2)!
         
         let DifteriVaccination3 = Vaccination(vaccine: .Difteri, startDate: date + 31557600, amountOfDosesTaken: 3)!
         let StelkrampVaccination3 = Vaccination(vaccine: .Stelkramp, startDate: date + 31557600, amountOfDosesTaken: 3)!
         let KikhostaVaccination3 = Vaccination(vaccine: .Kikhosta, startDate: date + 31557600, amountOfDosesTaken: 3)!
         let PolioVaccination3 = Vaccination(vaccine: .Polio, startDate: date + 31557600, amountOfDosesTaken: 3)!
         let HibVaccination3 = Vaccination(vaccine: .Haemophilus_influenzae_typ_b_Hib, startDate: date + 31557600, amountOfDosesTaken: 3)!
         let HepatitBVaccination3 = Vaccination(vaccine: .Hepatit_B, startDate: date + 31557600, amountOfDosesTaken: 3)!
         let PneumokockerVaccination3 = Vaccination(vaccine: .Pneumokocker, startDate: date + 31557600, amountOfDosesTaken: 3)!
         
         let DifteriVaccination4 = Vaccination(vaccine: .Difteri, startDate: date + 157788000, amountOfDosesTaken: 4)!
         let StelkrampVaccination4 = Vaccination(vaccine: .Stelkramp, startDate: date + 157788000, amountOfDosesTaken: 4)!
         let KikhostaVaccination4 = Vaccination(vaccine: .Kikhosta, startDate: date + 157788000, amountOfDosesTaken: 4)!
         let PolioVaccination4 = Vaccination(vaccine: .Polio, startDate: date + 157788000, amountOfDosesTaken: 4)!
         let PneumokockerVaccination4 = Vaccination(vaccine: .Pneumokocker, startDate: date + 157788000, amountOfDosesTaken: 4)!

         
         
        let MässlingVaccination1 = Vaccination(vaccine: .Mässling, startDate: date + 47336400, amountOfDosesTaken: 1)!
        let PåssjukaVaccination1 = Vaccination(vaccine: .Påssjuka, startDate: date + 47336400, amountOfDosesTaken: 1)!
        let RödaHundVaccination1 = Vaccination(vaccine: .Röda_hund, startDate: date + 47336400, amountOfDosesTaken: 1)!
        
        let MässlingVaccination2 = Vaccination(vaccine: .Mässling, startDate: date + 220903200, amountOfDosesTaken: 2)!
        let PåssjukaVaccination2 = Vaccination(vaccine: .Påssjuka, startDate: date + 220903200, amountOfDosesTaken: 2)!
        let RödaHundVaccination2 = Vaccination(vaccine: .Röda_hund, startDate: date + 220903200, amountOfDosesTaken: 2)!
        
        
        let DifteriVaccination5 = Vaccination(vaccine: .Difteri, startDate: date + 473040000, amountOfDosesTaken: 5)!
        let StelkrampVaccination5 = Vaccination(vaccine: .Stelkramp, startDate: date + 473040000, amountOfDosesTaken: 5)!
        let KikhostaVaccination5 = Vaccination(vaccine: .Kikhosta, startDate: date + 473040000, amountOfDosesTaken: 5)!
        
        let HPVVaccination1 = Vaccination(vaccine: .Humant_papillomvirus_HPV, startDate: date + 378691200, amountOfDosesTaken: 1)!
        let HPVVaccination2 = Vaccination(vaccine: .Humant_papillomvirus_HPV, startDate: date + 378691200 + 15789600, amountOfDosesTaken: 2)!

        
        if vaccBool {
            comingVaccinations.append(RotaVirusVaccination1)
            
            comingVaccinations.append(DifteriVaccination1)
            comingVaccinations.append(StelkrampVaccination1)
            comingVaccinations.append(PolioVaccination1)
            comingVaccinations.append(HibVaccination1)
            comingVaccinations.append(PneumokockerVaccination1)
            
            comingVaccinations.append(MässlingVaccination1)
            comingVaccinations.append(PåssjukaVaccination1)
            comingVaccinations.append(RödaHundVaccination1)
            comingVaccinations.append(HepatitBVaccination1)
            comingVaccinations.append(KikhostaVaccination1)
            comingVaccinations.append(HPVVaccination1)
            
            
        }
        else {
            
            allVaccinations.append(RotaVirusVaccination1)
            
            allVaccinations.append(DifteriVaccination1)
            allVaccinations.append(StelkrampVaccination1)
            allVaccinations.append(PolioVaccination1)
            allVaccinations.append(HibVaccination1)
            allVaccinations.append(PneumokockerVaccination1)
            allVaccinations.append(RotaVirusVaccination2)

            
            allVaccinations.append(MässlingVaccination1)
            allVaccinations.append(PåssjukaVaccination1)
            allVaccinations.append(RödaHundVaccination1)
            allVaccinations.append(HepatitBVaccination1)
            allVaccinations.append(KikhostaVaccination1)
            allVaccinations.append(HPVVaccination1)

            
            allVaccinations.append(DifteriVaccination2)
            allVaccinations.append(StelkrampVaccination2)
            allVaccinations.append(PolioVaccination2)
            allVaccinations.append(HibVaccination2)
            allVaccinations.append(PneumokockerVaccination2)
            
            
            allVaccinations.append(HepatitBVaccination2)
            allVaccinations.append(KikhostaVaccination2)
            
            allVaccinations.append(DifteriVaccination3)
            allVaccinations.append(StelkrampVaccination3)
            allVaccinations.append(PolioVaccination3)
            allVaccinations.append(HibVaccination3)
            allVaccinations.append(PneumokockerVaccination3)
            
            
            allVaccinations.append(HepatitBVaccination3)
            allVaccinations.append(KikhostaVaccination3)
            
            allVaccinations.append(DifteriVaccination4)
            allVaccinations.append(StelkrampVaccination4)
            allVaccinations.append(PolioVaccination4)
            allVaccinations.append(PneumokockerVaccination4)
            
            
            
            allVaccinations.append(KikhostaVaccination4)
            
            allVaccinations.append(MässlingVaccination2)
            allVaccinations.append(PåssjukaVaccination2)
            allVaccinations.append(RödaHundVaccination2)

            allVaccinations.append(HPVVaccination2)

            
            allVaccinations.append(DifteriVaccination5)
            allVaccinations.append(StelkrampVaccination5)
            allVaccinations.append(KikhostaVaccination5)
            

            
        }
    }
    
    
    
    func setVaccinationProgramVaccinations() {
        
        let hours = Set([Calendar.Component.hour])
        let birthDay = (PFUser.current()?.object(forKey: "birthDate") as! Date)
        let hourInterval = Calendar.current.dateComponents(hours, from: birthDay, to: Date()).hour!
        let weekInterval = hourInterval / 168
        
        if true //weekInterval > 168
        {
            deleteAllVaccinationProgramVaccinations()
            
            setVaccinationProgramVaccinationsFromDate(birthDay, setComingVaccinations: false)
        }
        
        

    }
    
    func setVaccinationProgramComingVaccinations() {
        let hours = Set([Calendar.Component.hour])
        let birthDay = (PFUser.current()?.object(forKey: "birthDate") as! Date)
        let hourInterval = Calendar.current.dateComponents(hours, from: birthDay, to: Date()).hour!
        let weekInterval = hourInterval / 168
        
        if true //weekInterval > 168
        {
            deleteAllVaccinationProgramComingVaccinations()

            setVaccinationProgramVaccinationsFromDate(birthDay, setComingVaccinations: true)
        }
        
    }
    
    func getAllVaccinationProgramVaccinations() -> [Vaccination] {
        
        var vaccinationProgramVaccinationsArray: [Vaccination] = []
        
        let hours = Set([Calendar.Component.hour])
        let birthDay = (PFUser.current()?.object(forKey: "birthDate") as? Date) ?? Date()
        let hourInterval = Calendar.current.dateComponents(hours, from: birthDay, to: Date()).hour!
        let weekInterval = hourInterval / 168
        
        let RotaVirusVaccination1 = Vaccination(vaccine: .Rotavirus, startDate: birthDay + 3628800, amountOfDosesTaken: 1)!
        
        
        let DifteriVaccination1 = Vaccination(vaccine: .Difteri, startDate: birthDay + 7905600, amountOfDosesTaken: 1)!
        let StelkrampVaccination1 = Vaccination(vaccine: .Stelkramp, startDate: birthDay + 7905600, amountOfDosesTaken: 1)!
        let KikhostaVaccination1 = Vaccination(vaccine: .Kikhosta, startDate: birthDay + 7905600, amountOfDosesTaken: 1)!
        let PolioVaccination1 = Vaccination(vaccine: .Polio, startDate: birthDay + 7905600, amountOfDosesTaken: 1)!
        let HibVaccination1 = Vaccination(vaccine: .Haemophilus_influenzae_typ_b_Hib, startDate: birthDay + 7905600, amountOfDosesTaken: 1)!
        let HepatitBVaccination1 = Vaccination(vaccine: .Hepatit_B, startDate: birthDay + 7905600, amountOfDosesTaken: 1)!
        let PneumokockerVaccination1 = Vaccination(vaccine: .Pneumokocker, startDate: birthDay + 7905600, amountOfDosesTaken: 1)!
        let RotaVirusVaccination2 = Vaccination(vaccine: .Rotavirus, startDate: birthDay + 7905600, amountOfDosesTaken: 2)!

        
        let DifteriVaccination2 = Vaccination(vaccine: .Difteri, startDate: birthDay + 13176000, amountOfDosesTaken: 2)!
        let StelkrampVaccination2 = Vaccination(vaccine: .Stelkramp, startDate: birthDay + 13176000, amountOfDosesTaken: 2)!
        let KikhostaVaccination2 = Vaccination(vaccine: .Kikhosta, startDate: birthDay + 13176000, amountOfDosesTaken: 2)!
        let PolioVaccination2 = Vaccination(vaccine: .Polio, startDate: birthDay + 13176000, amountOfDosesTaken: 2)!
        let HibVaccination2 = Vaccination(vaccine: .Haemophilus_influenzae_typ_b_Hib, startDate: birthDay + 13176000, amountOfDosesTaken: 2)!
        let HepatitBVaccination2 = Vaccination(vaccine: .Hepatit_B, startDate: birthDay + 13176000, amountOfDosesTaken: 2)!
        let PneumokockerVaccination2 = Vaccination(vaccine: .Pneumokocker, startDate: birthDay + 13176000, amountOfDosesTaken: 2)!
        
        let DifteriVaccination3 = Vaccination(vaccine: .Difteri, startDate: birthDay + 31557600, amountOfDosesTaken: 3)!
        let StelkrampVaccination3 = Vaccination(vaccine: .Stelkramp, startDate: birthDay + 31557600, amountOfDosesTaken: 3)!
        let KikhostaVaccination3 = Vaccination(vaccine: .Kikhosta, startDate: birthDay + 31557600, amountOfDosesTaken: 3)!
        let PolioVaccination3 = Vaccination(vaccine: .Polio, startDate: birthDay + 31557600, amountOfDosesTaken: 3)!
        let HibVaccination3 = Vaccination(vaccine: .Haemophilus_influenzae_typ_b_Hib, startDate: birthDay + 31557600, amountOfDosesTaken: 3)!
        let HepatitBVaccination3 = Vaccination(vaccine: .Hepatit_B, startDate: birthDay + 31557600, amountOfDosesTaken: 3)!
        let PneumokockerVaccination3 = Vaccination(vaccine: .Pneumokocker, startDate: birthDay + 31557600, amountOfDosesTaken: 3)!
        
        let DifteriVaccination4 = Vaccination(vaccine: .Difteri, startDate: birthDay + 157788000, amountOfDosesTaken: 4)!
        let StelkrampVaccination4 = Vaccination(vaccine: .Stelkramp, startDate: birthDay + 157788000, amountOfDosesTaken: 4)!
        let KikhostaVaccination4 = Vaccination(vaccine: .Kikhosta, startDate: birthDay + 157788000, amountOfDosesTaken: 4)!
        let PolioVaccination4 = Vaccination(vaccine: .Polio, startDate: birthDay + 157788000, amountOfDosesTaken: 4)!
        let PneumokockerVaccination4 = Vaccination(vaccine: .Pneumokocker, startDate: birthDay + 157788000, amountOfDosesTaken: 4)!
        
        
        
        let MässlingVaccination1 = Vaccination(vaccine: .Mässling, startDate: birthDay + 47336400, amountOfDosesTaken: 1)!
        let PåssjukaVaccination1 = Vaccination(vaccine: .Påssjuka, startDate: birthDay + 47336400, amountOfDosesTaken: 1)!
        let RödaHundVaccination1 = Vaccination(vaccine: .Röda_hund, startDate: birthDay + 47336400, amountOfDosesTaken: 1)!
        
        let MässlingVaccination2 = Vaccination(vaccine: .Mässling, startDate: birthDay + 220903200, amountOfDosesTaken: 2)!
        let PåssjukaVaccination2 = Vaccination(vaccine: .Påssjuka, startDate: birthDay + 220903200, amountOfDosesTaken: 2)!
        let RödaHundVaccination2 = Vaccination(vaccine: .Röda_hund, startDate: birthDay + 220903200, amountOfDosesTaken: 2)!
        
        
        let DifteriVaccination5 = Vaccination(vaccine: .Difteri, startDate: birthDay + 473040000, amountOfDosesTaken: 5)!
        let StelkrampVaccination5 = Vaccination(vaccine: .Stelkramp, startDate: birthDay + 473040000, amountOfDosesTaken: 5)!
        let KikhostaVaccination5 = Vaccination(vaccine: .Kikhosta, startDate: birthDay + 473040000, amountOfDosesTaken: 5)!
        
        let HPVVaccination1 = Vaccination(vaccine: .Humant_papillomvirus_HPV, startDate: birthDay + 378691200, amountOfDosesTaken: 1)!
        let HPVVaccination2 = Vaccination(vaccine: .Humant_papillomvirus_HPV, startDate: birthDay + 378691200 + 15789600, amountOfDosesTaken: 2)!
        
        vaccinationProgramVaccinationsArray.append(RotaVirusVaccination1)
         
         vaccinationProgramVaccinationsArray.append(DifteriVaccination1)
         vaccinationProgramVaccinationsArray.append(StelkrampVaccination1)
         vaccinationProgramVaccinationsArray.append(PolioVaccination1)
         vaccinationProgramVaccinationsArray.append(HibVaccination1)
         vaccinationProgramVaccinationsArray.append(PneumokockerVaccination1)
        vaccinationProgramVaccinationsArray.append(RotaVirusVaccination2)
        
         vaccinationProgramVaccinationsArray.append(MässlingVaccination1)
         vaccinationProgramVaccinationsArray.append(PåssjukaVaccination1)
         vaccinationProgramVaccinationsArray.append(RödaHundVaccination1)
         vaccinationProgramVaccinationsArray.append(HepatitBVaccination1)
         vaccinationProgramVaccinationsArray.append(KikhostaVaccination1)
        
         vaccinationProgramVaccinationsArray.append(HPVVaccination1)


         vaccinationProgramVaccinationsArray.append(DifteriVaccination2)
         vaccinationProgramVaccinationsArray.append(StelkrampVaccination2)
         vaccinationProgramVaccinationsArray.append(PolioVaccination2)
         vaccinationProgramVaccinationsArray.append(HibVaccination2)
         vaccinationProgramVaccinationsArray.append(PneumokockerVaccination2)
         
         
         vaccinationProgramVaccinationsArray.append(HepatitBVaccination2)
         vaccinationProgramVaccinationsArray.append(KikhostaVaccination2)
         
         vaccinationProgramVaccinationsArray.append(DifteriVaccination3)
         vaccinationProgramVaccinationsArray.append(StelkrampVaccination3)
         vaccinationProgramVaccinationsArray.append(PolioVaccination3)
         vaccinationProgramVaccinationsArray.append(HibVaccination3)
         vaccinationProgramVaccinationsArray.append(PneumokockerVaccination3)
         
        
         vaccinationProgramVaccinationsArray.append(HepatitBVaccination3)
         vaccinationProgramVaccinationsArray.append(KikhostaVaccination3)
         
         vaccinationProgramVaccinationsArray.append(DifteriVaccination4)
         vaccinationProgramVaccinationsArray.append(StelkrampVaccination4)
         vaccinationProgramVaccinationsArray.append(PolioVaccination4)
         vaccinationProgramVaccinationsArray.append(PneumokockerVaccination4)
         
         
         
         vaccinationProgramVaccinationsArray.append(KikhostaVaccination4)
        
        vaccinationProgramVaccinationsArray.append(MässlingVaccination2)
        vaccinationProgramVaccinationsArray.append(PåssjukaVaccination2)
        vaccinationProgramVaccinationsArray.append(RödaHundVaccination2)
        
        vaccinationProgramVaccinationsArray.append(HPVVaccination2)


        vaccinationProgramVaccinationsArray.append(DifteriVaccination5)
        vaccinationProgramVaccinationsArray.append(StelkrampVaccination5)
        vaccinationProgramVaccinationsArray.append(KikhostaVaccination5)
        
        return vaccinationProgramVaccinationsArray
        
    }
    
    func changeVaccinationProgramStatus(previousVaccinationProgramIndicator: Int?) {
        let user = PFUser.current()
        let vaccinationProgramIndicator = user?.object(forKey: "VaccinationProgramIndicator") as! Int
        
        switch vaccinationProgramIndicator {
        case 0:
            self.setVaccinationProgramVaccinations()
        case 1:
            self.setVaccinationProgramComingVaccinations()
        case 2:
            print("Yeeet")
        default:
            return
            
        }
        
        if previousVaccinationProgramIndicator != nil {
            switch previousVaccinationProgramIndicator {
            case 0:
                self.deleteAllVaccinationProgramVaccinations()
            case 1:
                self.deleteAllVaccinationProgramComingVaccinations()
            case 2:
                return
            default:
                return
            }
        }
        
        self.save()
    }
    
    
    func isVaccinePartOfVaccinationProgram(vaccine: Vaccine) -> Bool {
        
        let user = PFUser.current()
        if PFUser.current()?.object(forKey: "Gender") as? String == "Man" {
            for i in arrayOfVaccinesInVaccinationProgramForBoys {
                if i == vaccine {
                    return true
                }
            }
        }
        else {
            for i in arrayOfVaccinesInVaccinationProgramForGirls {
                if i == vaccine {
                    return true
                }
            }
        }
        return false
        
        
    }
    
    func getPercentageOfVaccinationProgramTaken() -> Double {
        
        var vaccinationProgramVaccinationsTaken: Double = 0.0
        let allVaccinationProgramVaccinations = getAllVaccinationProgramVaccinations()
        for i in allVaccinationProgramVaccinations {
            for x in allVaccinations {
                if i.vaccine == x.vaccine && i.amountOfDosesTaken == x.amountOfDosesTaken {
                    print(i.vaccine.rawValue)
                    vaccinationProgramVaccinationsTaken += 1
                }

            }
        }
        
        return vaccinationProgramVaccinationsTaken/Double(allVaccinationProgramVaccinations.count)
    }
    
    
    func isVaccinationPartOfVaccinationProgram(vaccination: Vaccination) -> Bool {
        let allVaccinationProgramVaccinations = getAllVaccinationProgramVaccinations()
        
        
            for x in allVaccinationProgramVaccinations {
                if vaccination.amountOfDosesTaken == x.amountOfDosesTaken && vaccination.vaccine == x.vaccine {
                    return true
                }
            
        }
        return false
    }
    func isComingVaccinationPartOfVaccinationProgram(vaccination: Vaccination) -> Bool {
        let allVaccinationProgramVaccinations = getAllVaccinationProgramVaccinations()
        
        
            for x in allVaccinationProgramVaccinations {
                if vaccination.amountOfDosesTaken == x.amountOfDosesTaken && vaccination.vaccine == x.vaccine {
                    return true
                }
            
        }
        return false
    }
    
    
    func deleteAllVaccinationProgramVaccinations() {
        for i in allVaccinations {
            if isVaccinationPartOfVaccinationProgram(vaccination: i) {
                allVaccinations.remove(i)
            }
            
        }
    }
    
    func deleteAllVaccinationProgramComingVaccinations() {
        for i in comingVaccinations {
            if isComingVaccinationPartOfVaccinationProgram(vaccination: i) {
                comingVaccinations.remove(i)
            }
            
        }
    }
    
    func coverageForThisVaccine(vaccine: Vaccine) -> Int {
        var vaccinationsWithThisVaccine: [Vaccination] = []
        for i in allVaccinations {
            if i.vaccine == vaccine {
                vaccinationsWithThisVaccine.append(i)
            }
        }
        var vaccination = Vaccination(vaccine: vaccine, startDate: Date(), amountOfDosesTaken: 0)
        for i in vaccinationsWithThisVaccine {
            if i.amountOfDosesTaken! > (vaccination?.amountOfDosesTaken!)! {
                vaccination = i
            }
        }
        
        let user = PFUser.current()
        let indic = user?.object(forKey: "VaccinationProgramIndicator") as! Int
        let birthDate = user?.object(forKey: "birthDate") as! Date
        
        
        if vaccination!.amountOfDosesTaken! >= (vaccination?.vaccine.getTotalAmountOfDoses(vaccinationProgramIndicator: indic, birthDay: birthDate))! {
            return 2
        }
        else {
            return 0
        }
    }
    
    func timeTillNextComingVaccination() -> VaccinationTimeLeft? {
        var comingVaccination: Vaccination!
        var index = 0
        if comingVaccinations.count != 0 {
            
            for i in comingVaccinations {
                if index == 0 {
                    comingVaccination = i
                }
                else if i.startDate < comingVaccination.startDate {
                    comingVaccination = i
                }
                
                index += 1
            }
            
            return comingVaccination.getVaccinationTimeLeft(atDate: Date(), amountOfDosesTaken: comingVaccination.amountOfDosesTaken)
        }
        else {
            return nil
            
        }
    }
    //MARK: Push Notifications
    /*func askToSendPushNotifications() {
        let alertController = alertService.alert(title: "Skicka en push-notis till nyhetskanalen", message: "", buttonTitle: "OK", alertType: .success, completionWithAction: {
            () in
            self.sendPushNotifications()}
            , completionWithCancel: {()
                in})
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendPushNotifications() {
        let cloudParams : [AnyHashable:String] = [:]
        PFCloud.callFunction(inBackground: "pushsample", withParameters: cloudParams, block: {
            (result: Any?, error: Error?) -> Void in
            if error != nil {
                if let descrip = error?.localizedDescription{
                    print(descrip)
                }
            }
            else {
                print(result as? String)
            }
        })
    }*/
        
        
    }






