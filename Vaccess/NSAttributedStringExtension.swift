//
//  NSAttributedStringExtension.swift
//  Vaccess
//
//  Created by emil on 2020-11-01.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    static func makeHyperLink(for path: String, in string: String, as substring: String, for2 path2: String, as2 substring2: String) -> NSAttributedString {
       
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        
        let substringRange2 = nsString.range(of: substring2)
        attributedString.addAttribute(.link, value: path2, range: substringRange2)

        return attributedString
        
    }
    
    static func makeHyperLink(for path: String, in string: String, as substring: String) -> NSAttributedString {
       
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        

        return attributedString
        
    }
    
    
    
}
