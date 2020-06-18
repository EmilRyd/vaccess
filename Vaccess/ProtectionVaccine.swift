//
//  ProtectionVaccine.swift
//  Vaccess
//
//  Created by emil on 2020-05-13.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import Foundation

class ProtectionVaccine: CustomStringConvertible {
    var description: String {
        return self.name
    }
    
    
    var totalProtection: TotalProtection
    var name: String
    
    init(name: String, protection: String) {
        self.totalProtection = TotalProtection(rawValue: protection)!
        self.name = name
    }
    
    enum TotalProtection: String {
        case
        Alla = "Alla",
        Ingen = "Ingen",
        Partiellt = "Partiellt",
        Fullt = "Fullt"
        
        
        static let allCases = [
        Alla, Ingen, Partiellt, Fullt
        ]
        
        
        
        
        func simpleDescription() -> String {
            return self.rawValue
        }
        
    }
    

}
