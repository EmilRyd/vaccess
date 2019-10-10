//
//__Vaccine.swift
//__Vaccess
//
//__Created_by_Gustav_Ryd_on_2019-09-22.
//__Copyright_©_2019_Ryd_Corporation._All_rights_reserved.
//

import Foundation

enum Vaccine: String {
    case
    Bältros = "Bältros",
    Difteri = "Difteri",
    Gulafebern = "Gula febern",
    Haemophilus_influenzae_typ_b_Hib = "Haemophilus influenzae typ b (Hib)",
    Hepatit_A = "Hepatit A",
    Hepatit_B = "Hepatit B",
    Humant_papillomvirus_HPV = "Humant papillomvirus (HPV), 2-valent",
    Influensa = "Influensa",
    Japansk_encefalit = "Japansk encefalit",
    Kikhosta = "Kikhosta",
    Kolera = "Kolera",
    Meningokocker_A_C_Y_W = "Meningokocker A, C, Y, W",
    Meningokocker_B = "Meningokocker B",
    Meningokocker_C = "Meningokocker C",
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
    Hepatit_A,
    Hepatit_B,
    Humant_papillomvirus_HPV,
    Influensa,
    Japansk_encefalit,
    Kikhosta,
    Kolera,
    Meningokocker_A_C_Y_W,
    Meningokocker_B,
    Meningokocker_C,
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
        
    func takenOnce() -> Bool {
        switch self {
        case .Bältros,
            .Difteri,
            .Gulafebern,
            .Influensa,
            .Meningokocker_A_C_Y_W,
            .Meningokocker_B,
            .Meningokocker_C,
            .Pneumokocker,
            .Tuberkulos_TB:
            return true
        default:
            return false
        }
    }
    
    
    func numberOfShots() -> Int {
        switch self {
        default:
            return 1
        }
    }
    
    func protection(amountOfDosesTaken: Int?) -> Protection {
        switch self {
        case .Gulafebern:
            return Protection.lifeLong
        case .Meningokocker_A_C_Y_W, .Meningokocker_B, .Meningokocker_C, .Bältros, .Pneumokocker:
            return Protection.unknown
        case .Tuberkulos_TB:
            return Protection.time([10*12])
        case .Difteri:
            return Protection.time([20*12])
        case .Influensa:
            return Protection.time([1*12])
        case .Haemophilus_influenzae_typ_b_Hib:
            switch amountOfDosesTaken {
            case 1:
                return Protection.time([2])
            case 2:
                return Protection.time([6])
            default:
                return Protection.unknown
            }
        
        case .Hepatit_A:
            switch amountOfDosesTaken {
            case 1:
                return Protection.time([1])
            case 2:
                return Protection.time([20*12])
            default:
                return Protection.unknown
            }
            
        case .Hepatit_B:
            switch amountOfDosesTaken {
            case 1:
                return Protection.time([1])
            case 2:
                return Protection.time([5, 12])
            default:
                return Protection.lifeLong
            }
       /* case .Humant_papillomvirus_HPV:
            switch amountOfDosesTaken {
                
            }*/
        default:
            return Protection.time([0])
        }
    }
    
    
    func endDate(startDate: Date) -> Date? {        
        var varingstid = DateComponents()
        switch self.protection(amountOfDosesTaken: nil) {
        case let .time(months):
            varingstid.year = months[1]/12
            let slutDatum = Calendar.current.date(byAdding: varingstid, to: startDate)
            return slutDatum
        case .lifeLong, .unknown:
            return nil
        }
    }

    
    



}
