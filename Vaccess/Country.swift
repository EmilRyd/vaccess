//
//  Country.swift
//  Vaccess
//
//  Created by emil on 2019-10-30.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import Foundation

class Country: CustomStringConvertible {
    var description: String {
        return self.name
    }
    
    
    var continent: Continent
    var name: String
    
    init(name: String, continent: String) {
        self.continent = Continent(rawValue: continent)!
        self.name = name
    }
    
    enum Continent: String {
        case         Alla = "Alla",
        Afrika = "Afrika",
        Asien = "Asien",
        Europa = "Europa",
        Oceanien = "Oceanien",
        Amerika = "Amerika"
        
        static let allCases = [
        Alla, Afrika, Asien, Europa, Oceanien, Amerika
        ]
        
        
        
        
        func simpleDescription() -> String {
            return self.rawValue
        }
        
    }
    

}
