//
//  Vaccine.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-14.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import Foundation

class Vaccination: Equatable, Comparable, Codable {
    
    //MARK: Properties
    
    var isPartOfVaccinationProgram: Bool?
    var vaccine: Vaccine
    var startDate: Date
    var manualEndDate: Date?
    var amountOfDosesTaken: Int?
    var protectionManuallySetToLifelong: Bool?
    //MARK: Initialization
    
    init?(vaccine: Vaccine, startDate: Date, amountOfDosesTaken: Int?) {
        
        // Namnet får inte vara tomt
//        guard !namn.isEmpty else {
//            return nil
//        }
        
        // Initiera klassens attribut
        self.vaccine = vaccine
        self.startDate = startDate
        self.amountOfDosesTaken = amountOfDosesTaken
    }
    
    func getVaccinationTimeLeft(atDate: Date, amountOfDosesTaken: Int?) -> VaccinationTimeLeft {
        //let endDate = self.getEndDate(atDate: startDate, amountOfDosesTaken: amountOfDosesTaken)

        //if (endDate != nil) {
            let years = Set([Calendar.Component.year])
            let yearInterval = Calendar.current.dateComponents(years, from: atDate, to: startDate).year!
            
            let months = Set([Calendar.Component.month])
            let monthInterval = Calendar.current.dateComponents(months, from: atDate, to: startDate).month!
            
            let days = Set([Calendar.Component.day])
            let dayInterval = Calendar.current.dateComponents(days, from: atDate, to: startDate).day!
            
            var status: VaccinationStatus
            if dayInterval < 0 {
                status = VaccinationStatus.expired
            } else if monthInterval < 6 {
                status = VaccinationStatus.soon_to_expiry
            } else {
                status = VaccinationStatus.ok
            }
            
            return VaccinationTimeLeft(status: status, years: yearInterval, months: monthInterval, days: dayInterval)
       
        
    }
    
    func setEndDate (endDate: Date) {
        self.manualEndDate = endDate
        
    }
    
    func getEndDate (amountOfDosesTaken: Int?) -> Date? {
        return self.getEndDate(atDate: self.startDate, amountOfDosesTaken: amountOfDosesTaken)
        
    }
    
    func getEndDate (atDate: Date, amountOfDosesTaken: Int?) -> Date? {
        var endDate: Date?
        if self.manualEndDate == nil {
            endDate = self.vaccine.endDate(startDate: atDate, amountOfDosesTaken: amountOfDosesTaken)
        } else {
            endDate = self.manualEndDate
        }
        return endDate
        
    }
    
    //MARK: Equatable Protocol functions
    
    static func == (vaccination1: Vaccination, vaccination2: Vaccination) -> Bool {
       
        
        return vaccination1.startDate == vaccination2.startDate && vaccination1.vaccine == vaccination2.vaccine && vaccination1.getEndDate(amountOfDosesTaken: vaccination1.amountOfDosesTaken) == vaccination2.getEndDate(amountOfDosesTaken: vaccination2.amountOfDosesTaken)
    }
    
    static func != (vaccination1: Vaccination, vaccination2: Vaccination) -> Bool {
        return !(vaccination1.startDate == vaccination2.startDate && vaccination1.vaccine == vaccination2.vaccine && vaccination1.getEndDate(amountOfDosesTaken: vaccination1.amountOfDosesTaken) == vaccination2.getEndDate(amountOfDosesTaken: vaccination2.amountOfDosesTaken))
    
        
    }
    
    //MARK: Comparable Protocol functions
    static func < (vaccination1: Vaccination, vaccination2: Vaccination) -> Bool {
        switch vaccination1.vaccine.protection(amountOfDosesTaken: vaccination1.amountOfDosesTaken) {
        case .time:
            switch vaccination2.vaccine.protection(amountOfDosesTaken: vaccination2.amountOfDosesTaken) {
            case .time:
                return (vaccination1.getEndDate(amountOfDosesTaken: vaccination1.amountOfDosesTaken)! < vaccination2.getEndDate(amountOfDosesTaken: vaccination2.amountOfDosesTaken)!)
            
            default:
                return (vaccination1.startDate < vaccination2.startDate)
            }
        default:
            return (vaccination1.startDate < vaccination2.startDate)
        }
    }
    
  
    
    
}


