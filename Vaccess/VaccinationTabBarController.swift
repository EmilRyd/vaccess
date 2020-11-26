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
    let center = UNUserNotificationCenter.current()

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
        
        let user = PFUser.current()
        let birthDate = user?.value(forKey: "birthDate") as! Date
        let gender = user?.value(forKey: "Gender") as! String
        let datumsFormat = DateFormatter()
        datumsFormat.dateFormat = "dd/MM - yyyy"

        let age = Date().timeIntervalSince(birthDate)/(3600*24*365.25)
        let year = 3600*24*365.25
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
        DifteriVaccination1.manualEndDate = DifteriVaccination2.startDate
         let StelkrampVaccination2 = Vaccination(vaccine: .Stelkramp, startDate: date + 13176000, amountOfDosesTaken: 2)!
        DifteriVaccination1.manualEndDate = DifteriVaccination2.startDate

         let KikhostaVaccination2 = Vaccination(vaccine: .Kikhosta, startDate: date + 13176000, amountOfDosesTaken: 2)!
        DifteriVaccination1.manualEndDate = DifteriVaccination2.startDate

         let PolioVaccination2 = Vaccination(vaccine: .Polio, startDate: date + 13176000, amountOfDosesTaken: 2)!
        PolioVaccination1.manualEndDate = PolioVaccination2.startDate
         let HibVaccination2 = Vaccination(vaccine: .Haemophilus_influenzae_typ_b_Hib, startDate: date + 13176000, amountOfDosesTaken: 2)!
        HibVaccination1.manualEndDate = HibVaccination2.startDate
         let HepatitBVaccination2 = Vaccination(vaccine: .Hepatit_B, startDate: date + 13176000, amountOfDosesTaken: 2)!
        HepatitBVaccination1.manualEndDate = HepatitBVaccination2.startDate
         let PneumokockerVaccination2 = Vaccination(vaccine: .Pneumokocker, startDate: date + 13176000, amountOfDosesTaken: 2)!
        PneumokockerVaccination1.manualEndDate = PneumokockerVaccination2.startDate
         
         let DifteriVaccination3 = Vaccination(vaccine: .Difteri, startDate: date + 31557600, amountOfDosesTaken: 3)!
        DifteriVaccination2.manualEndDate = DifteriVaccination3.startDate
         let StelkrampVaccination3 = Vaccination(vaccine: .Stelkramp, startDate: date + 31557600, amountOfDosesTaken: 3)!
        StelkrampVaccination2.manualEndDate = StelkrampVaccination3.startDate
         let KikhostaVaccination3 = Vaccination(vaccine: .Kikhosta, startDate: date + 31557600, amountOfDosesTaken: 3)!
        KikhostaVaccination2.manualEndDate = KikhostaVaccination3.startDate
         let PolioVaccination3 = Vaccination(vaccine: .Polio, startDate: date + 31557600, amountOfDosesTaken: 3)!
        PolioVaccination2.manualEndDate = PolioVaccination3.startDate
         let HibVaccination3 = Vaccination(vaccine: .Haemophilus_influenzae_typ_b_Hib, startDate: date + 31557600, amountOfDosesTaken: 3)!
        HibVaccination2.manualEndDate = HibVaccination3.startDate
         let HepatitBVaccination3 = Vaccination(vaccine: .Hepatit_B, startDate: date + 31557600, amountOfDosesTaken: 3)!
        HepatitBVaccination2.manualEndDate = HepatitBVaccination3.startDate
         let PneumokockerVaccination3 = Vaccination(vaccine: .Pneumokocker, startDate: date + 31557600, amountOfDosesTaken: 3)!
        PneumokockerVaccination2.manualEndDate = PneumokockerVaccination3.startDate
         
         let DifteriVaccination4 = Vaccination(vaccine: .Difteri, startDate: date + 157788000, amountOfDosesTaken: 4)!
        DifteriVaccination3.manualEndDate = DifteriVaccination4.startDate
         let StelkrampVaccination4 = Vaccination(vaccine: .Stelkramp, startDate: date + 157788000, amountOfDosesTaken: 4)!
        StelkrampVaccination4.manualEndDate = StelkrampVaccination4.startDate
         let KikhostaVaccination4 = Vaccination(vaccine: .Kikhosta, startDate: date + 157788000, amountOfDosesTaken: 4)!
        KikhostaVaccination3.manualEndDate = KikhostaVaccination4.startDate
         let PolioVaccination4 = Vaccination(vaccine: .Polio, startDate: date + 157788000, amountOfDosesTaken: 4)!
        PolioVaccination3.manualEndDate = PolioVaccination4.startDate

         
         
        let MässlingVaccination1 = Vaccination(vaccine: .Mässling, startDate: date + 47336400, amountOfDosesTaken: 1)!
        let PåssjukaVaccination1 = Vaccination(vaccine: .Påssjuka, startDate: date + 47336400, amountOfDosesTaken: 1)!
        let RödaHundVaccination1 = Vaccination(vaccine: .Röda_hund, startDate: date + 47336400, amountOfDosesTaken: 1)!
        
        let MässlingVaccination2 = Vaccination(vaccine: .Mässling, startDate: date + 220903200, amountOfDosesTaken: 2)!
        MässlingVaccination1.manualEndDate = MässlingVaccination2.startDate
        let PåssjukaVaccination2 = Vaccination(vaccine: .Påssjuka, startDate: date + 220903200, amountOfDosesTaken: 2)!
        PåssjukaVaccination1.manualEndDate = PåssjukaVaccination2.startDate
        
        let RödaHundVaccination2 = Vaccination(vaccine: .Röda_hund, startDate: date + 220903200, amountOfDosesTaken: 2)!
        RödaHundVaccination1.manualEndDate = RödaHundVaccination2.startDate
        
        
        let DifteriVaccination5 = Vaccination(vaccine: .Difteri, startDate: date + 473040000, amountOfDosesTaken: 5)!
        DifteriVaccination4.manualEndDate = DifteriVaccination5.startDate
        DifteriVaccination5.manualEndDate = DifteriVaccination4.startDate + 20*year
        let StelkrampVaccination5 = Vaccination(vaccine: .Stelkramp, startDate: date + 473040000, amountOfDosesTaken: 5)!
        StelkrampVaccination4.manualEndDate = StelkrampVaccination5.startDate
        StelkrampVaccination5.manualEndDate = StelkrampVaccination4.startDate + 20*year

        let KikhostaVaccination5 = Vaccination(vaccine: .Kikhosta, startDate: date + 473040000, amountOfDosesTaken: 5)!
        KikhostaVaccination4.manualEndDate = KikhostaVaccination5.startDate
        
        let HPVVaccination1 = Vaccination(vaccine: .Humant_papillomvirus_HPV, startDate: date + 378691200, amountOfDosesTaken: 1)!
        let HPVVaccination2 = Vaccination(vaccine: .Humant_papillomvirus_HPV, startDate: date + 378691200 + 15789600, amountOfDosesTaken: 2)!
        HibVaccination1.manualEndDate = HPVVaccination2.startDate

        
        if vaccBool {
            comingVaccinations.append(RotaVirusVaccination1)
            makeNotification(identifier: RotaVirusVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: RotaVirusVaccination1.startDate), deliveryDate: RotaVirusVaccination1.startDate, vaccination: RotaVirusVaccination1)
            
            comingVaccinations.append(DifteriVaccination1)
            makeNotification(identifier: DifteriVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: DifteriVaccination1.startDate), deliveryDate: DifteriVaccination1.startDate, vaccination: DifteriVaccination1)
            comingVaccinations.append(StelkrampVaccination1)
            makeNotification(identifier: StelkrampVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: StelkrampVaccination1.startDate), deliveryDate: StelkrampVaccination1.startDate, vaccination: StelkrampVaccination1)
            comingVaccinations.append(PolioVaccination1)
            makeNotification(identifier: PolioVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: PolioVaccination1.startDate), deliveryDate: PolioVaccination1.startDate, vaccination: PolioVaccination1)
            comingVaccinations.append(HibVaccination1)
            makeNotification(identifier: HibVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: HibVaccination1.startDate), deliveryDate: HibVaccination1.startDate, vaccination: HibVaccination1)
            comingVaccinations.append(PneumokockerVaccination1)
            makeNotification(identifier: PneumokockerVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: PneumokockerVaccination1.startDate), deliveryDate: PneumokockerVaccination1.startDate, vaccination: PneumokockerVaccination1)
            
            comingVaccinations.append(MässlingVaccination1)
            makeNotification(identifier: MässlingVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: MässlingVaccination1.startDate), deliveryDate: MässlingVaccination1.startDate, vaccination: MässlingVaccination1)
            comingVaccinations.append(PåssjukaVaccination1)
            makeNotification(identifier: PåssjukaVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: PåssjukaVaccination1.startDate), deliveryDate: PåssjukaVaccination1.startDate, vaccination: PåssjukaVaccination1)
            comingVaccinations.append(RödaHundVaccination1)
            makeNotification(identifier: RödaHundVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: RödaHundVaccination1.startDate), deliveryDate: RödaHundVaccination1.startDate, vaccination: RödaHundVaccination1)
            comingVaccinations.append(HepatitBVaccination1)
            makeNotification(identifier: HepatitBVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: HepatitBVaccination1.startDate), deliveryDate: HepatitBVaccination1.startDate, vaccination: HepatitBVaccination1)
            comingVaccinations.append(KikhostaVaccination1)
            makeNotification(identifier: KikhostaVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: KikhostaVaccination1.startDate), deliveryDate: KikhostaVaccination1.startDate, vaccination: KikhostaVaccination1)
            comingVaccinations.append(HPVVaccination1)
            makeNotification(identifier: HPVVaccination1.vaccine.simpleDescription() + datumsFormat.string(from: HPVVaccination1.startDate), deliveryDate: HPVVaccination1.startDate, vaccination: HPVVaccination1)
            
            
        }
        else {
            let year = 365.25*24*3600
            
            
            if date > Date(timeIntervalSince1970: -27*year) {
                allVaccinations.append(DifteriVaccination1)
                allVaccinations.append(DifteriVaccination2)
                allVaccinations.append(DifteriVaccination3)

            }
            
            if date > Date(timeIntervalSince1970: -17*year) {
                
                allVaccinations.append(StelkrampVaccination1)
                allVaccinations.append(StelkrampVaccination2)
                allVaccinations.append(StelkrampVaccination3)
                
            }
            
            if date > Date(timeIntervalSince1970: 32*year) {
                allVaccinations.append(DifteriVaccination4)
                allVaccinations.append(StelkrampVaccination4)
                allVaccinations.append(DifteriVaccination5)
                allVaccinations.append(StelkrampVaccination5)

            }
            
            if date > Date(timeIntervalSince1970: -5*year) && date < Date(timeIntervalSince1970: 32*year){
                let oldDifteri4 = Vaccination(vaccine: .Difteri, startDate: date + 7.5*year, amountOfDosesTaken: 4)!
                let oldStelkramp4 = Vaccination(vaccine: .Stelkramp, startDate: date + 7.5*year, amountOfDosesTaken: 4)!
                allVaccinations.append(oldDifteri4)
                allVaccinations.append(oldStelkramp4)

            }
            
            if (date > Date(timeIntervalSince1970: -17*year) && date < Date(timeIntervalSince1970: 9*year)) || (date > Date(timeIntervalSince1970: 26*year)) {
                allVaccinations.append(KikhostaVaccination1)
                allVaccinations.append(KikhostaVaccination2)
                allVaccinations.append(KikhostaVaccination3)

            }
            if date > Date(timeIntervalSince1970: 25*year) {
                allVaccinations.append(KikhostaVaccination4)

            }
            if date > Date(timeIntervalSince1970: 32*year) {
                allVaccinations.append(KikhostaVaccination5)

            }
            
            if (date > Date(timeIntervalSince1970: -13*year) && date < Date(timeIntervalSince1970: 16*year)) {
                let oldPolio1 = Vaccination(vaccine: .Polio, startDate: date + 3600*24*9*30, amountOfDosesTaken: 1)!
                let oldPolio2 = Vaccination(vaccine: .Polio, startDate: date + 3600*24*12*30, amountOfDosesTaken: 2)!
                let oldPolio3 = Vaccination(vaccine: .Polio, startDate: date + 3600*24*18*30, amountOfDosesTaken: 3)!
                allVaccinations.append(oldPolio1)
                allVaccinations.append(oldPolio2)
                allVaccinations.append(oldPolio3)

            }
            if (date > Date(timeIntervalSince1970: -5*year) && date < Date(timeIntervalSince1970: 7*year)){
                let oldPolio4 = Vaccination(vaccine: .Polio, startDate: date + 3600*24*365.25*7.5, amountOfDosesTaken: 3)!
                allVaccinations.append(oldPolio4)
            }
            if date > Date(timeIntervalSince1970: 16*year) {
                allVaccinations.append(PolioVaccination1)
                allVaccinations.append(PolioVaccination2)
                allVaccinations.append(PolioVaccination3)

            }
            if date > Date(timeIntervalSince1970: 2*year) {
                allVaccinations.append(PolioVaccination4)

            }
            if date > Date(timeIntervalSince1970: 1*year) {
                allVaccinations.append(MässlingVaccination1)
            }
            if date > Date(timeIntervalSince1970: 12*year){
                allVaccinations.append(PåssjukaVaccination1)
                allVaccinations.append(RödaHundVaccination1)

                
                
                if date < Date(timeIntervalSince1970: 32*year) {
                    let oldMässling2 = Vaccination(vaccine: .Mässling, startDate: date + 3600*24*365.25*12, amountOfDosesTaken: 2)!
                    let oldPåssjuka2 = Vaccination(vaccine: .Påssjuka, startDate: date + 3600*24*365.25*12, amountOfDosesTaken: 2)!
                    let oldRödaHund2 = Vaccination(vaccine: .Röda_hund, startDate: date + 3600*24*365.25*12, amountOfDosesTaken: 2)!

                    allVaccinations.append(oldMässling2)
                    allVaccinations.append(oldPåssjuka2)
                    allVaccinations.append(oldRödaHund2)

                }
                else {
                    allVaccinations.append(MässlingVaccination2)
                    allVaccinations.append(PåssjukaVaccination2)
                    allVaccinations.append(RödaHundVaccination2)
                }
                

            }
            if date > Date(timeIntervalSince1970: 22*year) {
                allVaccinations.append(HibVaccination1)
                allVaccinations.append(HibVaccination2)
                allVaccinations.append(HibVaccination3)

            }
            if date > Date(timeIntervalSince1970: 39*year) {
                allVaccinations.append(PneumokockerVaccination1)
                allVaccinations.append(PneumokockerVaccination2)
                allVaccinations.append(PneumokockerVaccination3)

            }
            if date > Date(timeIntervalSince1970: 42*year) {
                allVaccinations.append(HepatitBVaccination1)
                allVaccinations.append(HepatitBVaccination2)
                allVaccinations.append(HepatitBVaccination3)

            }
            
            
            
            if gender == "Kvinna" {
                if date > Date(timeIntervalSince1970: 30*year) {
                    allVaccinations.append(HPVVaccination1)
                    allVaccinations.append(HPVVaccination2)
                }
            }
            else {
                if date > Date(timeIntervalSince1970: 40*year) {
                    allVaccinations.append(HPVVaccination1)
                    allVaccinations.append(HPVVaccination2)
                }
            }
            if date > Date(timeIntervalSince1970: 44*year) {
                allVaccinations.append(RotaVirusVaccination1)

                allVaccinations.append(RotaVirusVaccination2)

            }
            
            
            
            
            
            
            
            
            
            


            
            
            

            
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
        if vaccinationsWithThisVaccine.count == 0 {
            return 0
        }
        var vaccination = Vaccination(vaccine: vaccine, startDate: Date(), amountOfDosesTaken: 0)
        vaccination?.manualEndDate = Date(timeIntervalSince1970: -999999999999999999)
        for i in vaccinationsWithThisVaccine {
            if i.amountOfDosesTaken! >= (vaccination?.amountOfDosesTaken!)! && (i.getEndDate(amountOfDosesTaken: i.amountOfDosesTaken) ?? Date()) > (vaccination?.getEndDate(amountOfDosesTaken: vaccination?.amountOfDosesTaken!) ?? Date()){
                vaccination = i
            }
        }
        
        let user = PFUser.current()
        let indic = user?.object(forKey: "VaccinationProgramIndicator") as! Int
        let birthDate = user?.object(forKey: "birthDate") as! Date
        
        if vaccination!.vaccine.protection(amountOfDosesTaken: vaccination!.amountOfDosesTaken) == .lifeLong {
            return 2
        }
        let endDate: Date? = vaccination!.getEndDate(atDate: vaccination!.startDate, amountOfDosesTaken: vaccination!.amountOfDosesTaken)
        if  (endDate ?? Date()) <= Date() {
            print("Couldn't make it: \(vaccination!.vaccine.rawValue)")
            return 0
        }
        print("Made it: \(vaccination!.vaccine.rawValue)")
        if vaccination!.amountOfDosesTaken! >= (vaccination?.vaccine.getTotalAmountOfDoses(vaccinationProgramIndicator: indic, birthDay: birthDate))! {
            return 2
        }
            else {
                switch vaccination?.vaccine {
                case .Bältros:
                    return 0
                case .Difteri:
                    switch vaccination?.amountOfDosesTaken {
                    case 1:
                        return 1
                    case 2:
                        return 1
                    case 3:
                        return 2
                    case 4:
                        return 2
                    default:
                        return 2
                    }
                case .Gulafebern:
                    return 0
                case .Haemophilus_influenzae_typ_b_Hib:
                    return 0
                case .Hepatit_A:
                    let coverageDate: Date? = vaccination!.getEndDate(amountOfDosesTaken: vaccination!.amountOfDosesTaken) ?? Date() + 3600*24*365.25/2
                    if (coverageDate ?? Date()) >= Date() {
                        return 2
                    }
                    else {
                        return 0
                        
                    }
                case .Hepatit_B:
                    return 0
                case .Hepatit_A_och_B:
                    return 0
                case .Humant_papillomvirus_HPV:
                    return 0
                case .Influensa:
                    return 0
                case .Japansk_encefalit:
                    return 0
                case .Kikhosta:
                    switch vaccination?.amountOfDosesTaken {
                    case 1, 2:
                        return 0
                    case 3:
                        return 1
                    case 4, 5:
                        return 2
                    default:
                        return 2
                    }
                case .Kolera:
                    return 0
                case .Mässling:
                    switch vaccination?.amountOfDosesTaken {
                    case 1:
                        return 1
                    case 2:
                        return 2
                    default:
                        return 2
                    }
                case .Meningokocker_A_C_Y_W, .Meningokocker_B:
                    return 0
                case .Påssjuka:
                    switch vaccination?.amountOfDosesTaken {
                    case 1:
                        return 1
                    case 2:
                        return 2
                    default:
                        return 2
                    }
                case .Pneumokocker:
                    return 0
                case .Polio:
                    switch vaccination?.amountOfDosesTaken {
                    case 1:
                        return 1
                    case 2:
                        return 1
                    case 3:
                        return 2
                    case 4:
                        return 2
                    default:
                        return 2
                    }
                case .Rabies:
                    return 0
                case .Rotavirus:
                    return 0
                case .Röda_hund:
                    switch vaccination?.amountOfDosesTaken {
                    case 1:
                        return 1
                    case 2:
                        return 2
                    default:
                        return 2
                    }
                case .Stelkramp:
                    switch vaccination?.amountOfDosesTaken {
                    case 1:
                        return 1
                    case 2:
                        return 1
                    case 3:
                        return 2
                    case 4:
                        return 2
                    default:
                        return 2
                    }
                case .Tick_Borne_Encephalitis_TBE:
                    if vaccination?.vaccine.getTotalAmountOfDoses(vaccinationProgramIndicator: indic, birthDay: birthDate) == 5 {
                        switch vaccination?.amountOfDosesTaken {
                        case 1:
                            return 0
                        case 2:
                            return 0
                        case 3:
                            return 0
                        case 4:
                            return 2
                        case 5:
                            return 2
                        default:
                            return 2
                        }
                    }
                    else {
                        switch vaccination?.amountOfDosesTaken {
                        case 1:
                            return 0
                        case 2:
                            return 0
                        case 3:
                            return 2
                        case 4:
                            return 2
                        default:
                            return 2
                        }
                    }
                case .Tyfoidfeber:
                    return 0
                case .Tuberkulos_TB:
                    return 0
                case .Vattkoppor:
                    switch vaccination?.amountOfDosesTaken {
                    case 1:
                        return 1
                    case 2:
                        return 2
                    default:
                        return 2
                    }
                default:
                    return 0
                }
            }
        
    }
    
    func getLatestVaccinationOf(vaccine: Vaccine) -> Vaccination {
        var vaccinationsWithThisVaccine: [Vaccination] = []
        for i in allVaccinations {
            if i.vaccine == vaccine {
                vaccinationsWithThisVaccine.append(i)
            }
        }
        var vaccination = Vaccination(vaccine: vaccine, startDate: Date(), amountOfDosesTaken: 0)!
        for i in vaccinationsWithThisVaccine {
            if i.amountOfDosesTaken! > (vaccination.amountOfDosesTaken!) {
                vaccination = i
            }
        }
        return vaccination
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
    
    func makeNotification(identifier: String, deliveryDate: Date, vaccination: Vaccination) {
         let content = UNMutableNotificationContent()
        
        let vaccineName = (vaccination.vaccine.simpleDescription()).lowercased()
           print(vaccineName)
           content.title = "Det finns ett vaccin att ta!"
           content.subtitle = ""
        content.body = "Vaccinet mot \(String(describing: vaccineName)) kan tas nu."
           content.sound = UNNotificationSound.default
           content.threadIdentifier = "local-notifications temp"
           
           
           let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: (deliveryDate + 3600 * 12))
           
        
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        print(identifier)
           
           let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
           center.add(request) { (error) in
               if error != nil {
                print(error as Any)
               }
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






