//
//  Vaccine.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-14.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import Foundation

class Vaccination {
    
    //MARK: Properties
    
    var vaccine: Vaccine
    var startDate: Date
    var manualEndDate: Date?
    
    //MARK: Initialization
    
    init?(vaccine: Vaccine, startDate: Date) {
        
        // Namnet får inte vara tomt
//        guard !namn.isEmpty else {
//            return nil
//        }
        
        // Initiera klassens attribut
        self.vaccine = vaccine
        self.startDate = startDate
        
    }
    
    func getVaccinationTimeLeft(atDate: Date) -> VaccinationTimeLeft {
        let endDate = self.getEndDate(atDate: atDate)

        if (endDate != nil) {
            let years = Set([Calendar.Component.year])
            let yearInterval = Calendar.current.dateComponents(years, from: atDate, to: endDate!).year!
            
            let months = Set([Calendar.Component.month])
            let monthInterval = Calendar.current.dateComponents(months, from: atDate, to: endDate!).month!
            
            let days = Set([Calendar.Component.day])
            let dayInterval = Calendar.current.dateComponents(days, from: atDate, to: endDate!).day!
            
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
        switch vaccine.protection() {
        case Protection.unknown:
            return VaccinationTimeLeft(status: VaccinationStatus.unknown, years: 0, months: 0, days: 0)
        default:
            return VaccinationTimeLeft(status: .ok, years: 0, months: 0, days: 0)            
        }
        
    }
    
    func setEndDate (endDate: Date) {
        self.manualEndDate = endDate
        
    }
    
    func getEndDate () -> Date? {
        return self.getEndDate(atDate: self.startDate)
        
    }
    
    func getEndDate (atDate: Date) -> Date? {
        var endDate: Date?
        if self.manualEndDate == nil {
            endDate = self.vaccine.endDate(startDate: atDate)
        } else {
            endDate = self.manualEndDate
        }
        return endDate
        
    }
}
