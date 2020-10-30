//
//  Theme.swift
//  Vaccess
//
//  Created by emil on 2020-09-23.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class Theme {
    static let mainFontName = "Futura-Medium"
    static let mainFontNameBold = "Futura-Bold"
    static let mainFontNameItalic = "Futura-Italic"
    static let primary = UIColor(named: "Primary")!
    static let primaryDark = UIColor(named: "PrimaryDark")!
    static let primaryLight = UIColor(named: "PrimaryLight")!

    static let secondary = UIColor(named: "Secondary")!
    static let secondaryDark = UIColor(named: "SecondaryDark")!
    static let secondaryLight = UIColor(named: "SecondaryLight")!
    
    static let background = UIColor(named: "background")
    
    static let secondaryCG = secondary.cgColor
    
    static let primaryCG = primary.cgColor
    
    static let primaryLightCG = primaryLight.cgColor

    @available(iOS 13.0, *)
    static let backgroundCG = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1.0)


    
}
