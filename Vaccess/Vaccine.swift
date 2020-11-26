//
//__Vaccine.swift
//__Vaccess
//
//__Created_by_Gustav_Ryd_on_2019-09-22.
//__Copyright_©_2019_Ryd_Corporation._All_rights_reserved.
//

import Foundation
import Parse
enum Vaccine: String, Codable, Comparable {
    
    
    case
    Bältros = "Bältros",
    Difteri = "Difteri",
    Gulafebern = "Gula febern",
    Haemophilus_influenzae_typ_b_Hib = "Haemophilus influenzae typ b (Hib)",
    Hepatit_A_och_B = "Hepatit A och B",
    Hepatit_A = "Hepatit A",
    Hepatit_B = "Hepatit B",
    Humant_papillomvirus_HPV = "Humant papillomvirus (HPV)",
    Influensa = "Influensa",
    Japansk_encefalit = "Japansk encefalit",
    Kikhosta = "Kikhosta",
    Kolera = "Kolera",
    Meningokocker_A_C_Y_W = "Meningokocker A, C, Y, W",
    Meningokocker_B = "Meningokocker B",
    Mässling = "Mässling",
    Pneumokocker = "Pneumokocker",
    Polio = "Polio",
    Påssjuka = "Påssjuka",
    Rabies = "Rabies",
    Rotavirus = "Rotavirus",
    Röda_hund = "Röda hund",
    Stelkramp = "Stelkramp",
    Tick_Borne_Encephalitis_TBE = "Tick Borne Encephalitis (TBE)",
    Tuberkulos_TB = "Tuberkulos (TB)",
    Tyfoidfeber = "Tyfoidfeber",
    Vattkoppor = "Vattkoppor"
    
    static let allValues = [
        Bältros,
        Difteri,
        Gulafebern,
        Haemophilus_influenzae_typ_b_Hib,
        Hepatit_A_och_B,
        Hepatit_A,
        Hepatit_B,
        
        Humant_papillomvirus_HPV,
        Influensa,
        Japansk_encefalit,
        Kikhosta,
        Kolera,
        Meningokocker_A_C_Y_W,
        Meningokocker_B,
        Mässling,
        Pneumokocker,
        Polio,
        Påssjuka,
        Rabies,
        Rotavirus,
        Röda_hund,
        Stelkramp,
        Tick_Borne_Encephalitis_TBE,
        Tuberkulos_TB,
        Tyfoidfeber,
        Vattkoppor]
    
    
    func simpleDescription() -> String {
        return self.rawValue
    }
    
    func simpleTableDescription() -> String {
        if self == .Haemophilus_influenzae_typ_b_Hib {
            return "Hib"
        }
        if self == .Humant_papillomvirus_HPV {
            return "HPV"
        }
        if self == .Tick_Borne_Encephalitis_TBE {
            return "TBE"
        }
        if self == .Tuberkulos_TB {
            return "Tuberkulos"
        }
        if self == .Meningokocker_B || self == .Meningokocker_A_C_Y_W {
            return "Meningokocker"
        }
        if self == .Hepatit_A_och_B {
            return Vaccine.Hepatit_A.rawValue
        }
        else {
            return self.simpleDescription()
        }
    }
    
    
    func simpleHistoryTableDescription() -> String {
        
        return self.simpleTableDescription()
    }
        
    /*func takenOnce() -> Bool {
        switch self {
        case .Bältros,
            
            .Gulafebern,
            .Influensa,
            .Meningokocker_A_C_Y_W,
            .Meningokocker_B,
            .Tuberkulos_TB,
            .Tyfoidfeber:
            return true
        default:
            return false
        }
    }*/
    
    
    func numberOfShots() -> Int {
        switch self {
        default:
            return 1
        }
    }
    
    func protection(amountOfDosesTaken: Int?) -> Protection {
        
        let user = PFUser.current()
        let birthDay = (user?.object(forKey: "birthDate") as? Date ?? Date())
        let vaccinationProgramIndicator: Int = (user?.object(forKey: "VaccinationProgramIndicator") as? Int ?? 2)
        let age: Double = Date().timeIntervalSince(birthDay)/(3600*24*365.25)

        //let birthDay = user?.object(forKey: "birthDate") as! Date
        //let months = Set([Calendar.Component.month])

        
        
        
        switch self {
        case .Bältros:
            return Protection.unknown
        case .Gulafebern:
            return Protection.lifeLong
        case .Meningokocker_A_C_Y_W, .Meningokocker_B:
            return Protection.unknown
        case .Tuberkulos_TB:
            return Protection.unknown
        case .Difteri:
            if vaccinationProgramIndicator == 1 || vaccinationProgramIndicator == 2{
                switch amountOfDosesTaken {
                
                case 1:
                    return Protection.time(2)
                    
                case 2:
                    return Protection.time(7)
                case 3:
                    return Protection.time(4*12)
                case 4:
                    return Protection.time(10*12)
                case 5:
                    return Protection.time(20*12)
                default:
                    return Protection.time(20*12)
                    
                }
            }
            else {
                switch amountOfDosesTaken {
                
                case 1:
                    return Protection.time(1)
                    
                case 2:
                    return Protection.time(5)
                case 3:
                    return Protection.time(10*12)
                case 4:
                    return Protection.time(20*12)
                default:
                    return Protection.time(20*12)
                    
                }
            }
            
            
        case .Influensa:
            if age > 8 {
                return Protection.time(1*12)
            }
            else {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(1)
                default:
                    return Protection.time(1*12)
                }
            }
        case .Haemophilus_influenzae_typ_b_Hib:
            //Kan påverkas av ålder, här antaget mindre än 1 år.
            if age < 1 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(2)
                case 2:
                    return Protection.time(7)
                case 3:
                    return Protection.lifeLong
                default:
                    return Protection.unknown
                }
            }
            else {
                return Protection.lifeLong
            }
            
        
        case .Hepatit_A:
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(6)
                case 2:
                    return Protection.time(30*12)
                default:
                    return Protection.time(30*12)
                }
        case .Hepatit_A_och_B:
            if age > 16 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(1)
                case 2:
                    return Protection.time(6)
                case 3:
                    return Protection.time(30*12)
                default:
                    return Protection.time(30*12)
                }
            }
            else {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(6)
                case 2:
                    return Protection.time(30*12)
                default:
                    return Protection.time(30*12)
                }
            }

        case .Hepatit_B:
            if vaccinationProgramIndicator == 1 || vaccinationProgramIndicator == 2 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(2)
                case 2:
                    return Protection.time(7)//, 12
                case 3:
                    return Protection.lifeLong
                default:
                    return Protection.unknown
                }
            }
            
            else {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(1)
                case 2:
                    return Protection.time(5)
                case 3:
                    return Protection.lifeLong
                default:
                    return Protection.unknown
                }
            }
            //Finns kombinationsvaccin tillsammans med Hepatit A, och har då andra tidsscheman
        
             
         case .Humant_papillomvirus_HPV:
             // Påverkas av personens ålder
            if age > 14 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(1)
                case 2:
                    return Protection.time(5)
                case 3:
                    return Protection.lifeLong
                default:
                    return Protection.unknown

                    
                }
            }
            else {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(6)
                case 2:
                    return Protection.lifeLong
                default:
                    return Protection.unknown
                }
            }
             
         case .Japansk_encefalit:
             // Påverkas av ålder
            if age < 18 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(1)
                case 2:
                    return Protection.time(1*12)
                default:
                    return Protection.time(10*12)

                    
                }
            }
            else if age > 60 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(1)
                case 2:
                    return Protection.time(2)
                case 3:
                    return Protection.time(1*12)
                default:
                    return Protection.time(10*12)
                }
            }
            else {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(1)
                case 2:
                    return Protection.time(1*12)
        
                default:
                    return Protection.time(10*12)
                }
            }
        case .Kikhosta:
            //3 månader + 5 månader + 12 månader
            //5 år
            //årskurs 8-9
            switch amountOfDosesTaken {
            case 1:
                return Protection.time(2)
            case 2:
                return Protection.time(7)
            case 3:
                return Protection.time(12*4)
            case 4:
                return Protection.time(9*12)//10*12
            case 5:
                return Protection.lifeLong
            default:
                
                return Protection.lifeLong //Inte helt säkert, fråga mamma
                
            }
         case .Kolera:
             // Påverkas av ålder
            if age > 6 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.unknown
                case 2:
                    return Protection.time(6)
                default:
                    return Protection.unknown

                    
                }
            }
            else {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.unknown
                case 2:
                    return Protection.unknown
                case 3:
                    return Protection.time(6)
                default:
                    return Protection.unknown
                }
            }
             
         case .Mässling:
             //Kan påverkas av ålder
            if vaccinationProgramIndicator == 1 || vaccinationProgramIndicator == 2  {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(66)//, 78
                case 2:
                    return Protection.lifeLong
                default:
                    return Protection.unknown
                }
            }
            else if age < 1.5 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.unknown//, 78
                case 2:
                    return Protection.unknown
                default:
                    return Protection.unknown
                }
            }
            else {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(5*12)//, 78
                case 2:
                    return Protection.lifeLong
                default:
                    return Protection.unknown
                }
            }
            
             
        case .Pneumokocker:
             if vaccinationProgramIndicator == 1 || vaccinationProgramIndicator == 2  {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(2)
                case 2:
                    return Protection.time(7)//, 12
                case 3:
                    return Protection.unknown
                default:
                    return Protection.unknown
                }
            }
            else {
                return Protection.unknown
            }
        
         case .Polio:
            if vaccinationProgramIndicator == 1 || vaccinationProgramIndicator == 2 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(2)
                case 2:
                    return Protection.time(7)
                case 3:
                    return Protection.time(4*12) //, 12]
                case 4:
                   return Protection.lifeLong
                default:
                    return Protection.unknown
                }
            }
            else {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(2)//Dos 1, 2, 3 nom sex månader
                case 2:
                    return Protection.time(2)
                case 3:
                    return Protection.time(4*12) //, 12]
                case 4:
                   return Protection.lifeLong
                default:
                    return Protection.unknown
                }
            }
             
         case .Påssjuka:
            if vaccinationProgramIndicator  == 1 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(66)//, 78]
                case 2:
                    return Protection.lifeLong
                default:
                    return Protection.unknown

                }
                
            }
            else {
                return Protection.unknown
            }
             
         case .Rabies:
            return Protection.unknown
             switch amountOfDosesTaken {
             case 1:
                 return Protection.unknown
             case 2:
                 return Protection.unknown//, 1000]
             default:
                 return Protection.unknown
             }
             
         case .Rotavirus:
            return Protection.unknown
             //Påverkas av ålder
            if vaccinationProgramIndicator == 1 || vaccinationProgramIndicator == 2  {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(2)
                case 2:
                    return Protection.lifeLong //, 1000]
                default:
                    return Protection.unknown
                }
            }
            else {
                return Protection.unknown
            }
             
        case .Röda_hund:
            if vaccinationProgramIndicator  == 1 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(66)//, 78]
                case 2:
                    return Protection.lifeLong
                default:
                    return Protection.unknown

                }
                
            }
            else {
                return Protection.unknown
            }
             
        case .Stelkramp:
            
            if vaccinationProgramIndicator == 1 || vaccinationProgramIndicator == 2  {
                
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(2)//,2]
                case 2:
                    return Protection.time(7)//,12]
                case 3:
                    return Protection.time(4*12)//, 10*12]
                case 4:
                    return Protection.time(10*12)//, 1000]
                case 5:
                    return Protection.time(20*12)
                default:
                    return Protection.time(20*12)
                }
            }
            else {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(1)
                case 2:
                    return Protection.time(5)
                case 3:
                    return Protection.time(10*12)
                case 4:
                    return Protection.time(20*12)
                default:
                    return Protection.time(20*12)
                }
            }
             
         case .Tick_Borne_Encephalitis_TBE:
             //Påverkas av ålder
            if age < 50 {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(1)
                case 2:
                    return Protection.time(5)
                case 3:
                    return Protection.time(3*12)
                case 4:
                    return Protection.time(5*12)
                default:
                    return Protection.time(5*12)
                }
            }
            else {
                switch amountOfDosesTaken {
                case 1:
                    return Protection.time(1)
                case 2:
                    return Protection.time(2)
                case 3:
                    return Protection.time(5)
                case 4:
                    return Protection.time(3*12)
                case 5:
                    return Protection.time(5*12)
                default:
                    return Protection.time(5*12)
                }
            }
         case .Tyfoidfeber:
             //Speciell, kan ske med både kapslar och sprutas och påverkas därav
            return Protection.time(3*12)
             
         case .Vattkoppor:
             switch amountOfDosesTaken {
             case 1:
                 return Protection.time(1)//, 1000]
             case 2:
                 return Protection.unknown
             default:
                 return Protection.unknown
             }
      
    }
    }
    
    func endDate(startDate: Date, amountOfDosesTaken: Int?) -> Date? {
        var varingstid = DateComponents()
        switch self.protection(amountOfDosesTaken: amountOfDosesTaken) {
        case let .time(months):
            varingstid.month = months
            let slutDatum = Calendar.current.date(byAdding: varingstid, to: startDate)
            return slutDatum
        case .lifeLong, .unknown:
            return nil
        }
    }
    
    func getTotalAmountOfDoses(vaccinationProgramIndicator: Int, birthDay: Date) -> Int {
        let age: Double = Date().timeIntervalSince(birthDay)/(3600*24*365.25)
        
            
        
        switch self {
        case .Bältros, .Influensa,
             .Meningokocker_A_C_Y_W,
             .Meningokocker_B,
             .Tuberkulos_TB,
             .Tyfoidfeber:
            return 1
        case .Difteri:
            switch vaccinationProgramIndicator {
            case 0:
                return 3
            case 1:
                return 5
            case 2:
                return 3
            default:
                return 5
            }
            
        case .Haemophilus_influenzae_typ_b_Hib:
            if age > 1 {
                return 3

            }
            else {
                return 1
            }
        case .Hepatit_A_och_B:
            if age > 16.0 {
                return 3
            }
            else {
                return 3
            }
        case .Hepatit_A:
            return 2
            
        case .Hepatit_B:
            return 3
        case .Humant_papillomvirus_HPV:
            //Påverkas av  ålder
            if age > 14 {
                return 3
            }
            else {
                return 2

            }
        case .Japansk_encefalit:
            //Påverkas av  ålder
            if age < 60 {
                return 2
            }
            else {
                return 3
            }
        case .Kikhosta:
            return 5
        case .Kolera:
            //Påverkas av  ålder
            if age < 6 {
                return 3
            }
            else {
                return 2
            }
            
        case .Mässling:
            //Kan påverkas av ålder
            return 2
        case .Pneumokocker:
            return 3
        case .Polio:
            return 4
        case .Påssjuka:
            return 2
        case .Rabies:
            return 2
        case .Rotavirus:
            //Påverkas av ålder
            return 2
        case .Röda_hund:
            //Påverkas av ålder
            return 2
        case .Stelkramp:
            if vaccinationProgramIndicator == 2 || age > 16 || vaccinationProgramIndicator == 0 {
                return 4
            }
            else {
                return 5
            }
            
        case .Tick_Borne_Encephalitis_TBE:
            //Påverkas av ålder
            if age < 50 {
                return 4
            }
            else {
                return 5
            }
            
        case .Tyfoidfeber:
            //Speciell, kan tas med kapslar vilket förändrar ALLT
            return 1
        case .Vattkoppor:
            return 2
        default:
            return 1
            
            
        }
    }
    
    func isPartOfVaccinationProgram() -> Bool {
        switch self {
        case .Rotavirus, .Difteri, .Stelkramp, .Polio, .Haemophilus_influenzae_typ_b_Hib, .Pneumokocker, .Mässling, .Påssjuka, .Röda_hund, .Hepatit_B, .Kikhosta:
            return true
        default:
            return false
        }
    }
    
    func isRecommended() -> Bool {
        if self.isPartOfVaccinationProgram() {
            return true
        }
        else {
            switch self {
            case .Tuberkulos_TB, .Tick_Borne_Encephalitis_TBE, .Hepatit_A:
                return true
            default:
                return false
            }
        }
    }
    
    
    //MARK: Comparable Protocol Functions
    static func < (vaccine1: Vaccine, vaccine2: Vaccine) -> Bool {
        let vaccines = Vaccine.allValues
        let indexForVaccine1 = vaccines.firstIndex(of: vaccine1)!
        let indexForVaccine2 = vaccines.firstIndex(of: vaccine2)!
        return indexForVaccine1 < indexForVaccine2
    }
    
   

    
    



}

