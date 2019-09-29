//
//  VaccinationStatus.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-22.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import Foundation

enum VaccinationStatus {
    case ok, soon_to_expiry, expired, unknown
}

class VaccinationTimeLeft {
    let years: Int
    let months: Int
    let days: Int
    let status: VaccinationStatus
    
    init(status: VaccinationStatus, years: Int, months: Int, days: Int) {
        self.status = status
        self.years = years
        self.months = months
        self.days = days
    }
    
}
