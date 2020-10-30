//
//  FloatingActionButton.swift
//  Vaccess
//
//  Created by emil on 2020-02-01.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if #available(iOS 13.0, *) {
            layer.backgroundColor = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1.0)
        } else {
            // Fallback on earlier versions
        }
        layer.cornerRadius = frame.height / 2
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
        
    }
    
    
    

}
