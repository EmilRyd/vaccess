//
//  StatisticsWheel.swift
//  Vaccess
//
//  Created by emil on 2020-01-27.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import Foundation
import UIKit

/*@IBDesignable class StatisticsWheel: UIView {
    
    private var color: CGColor?

    @IBInspectable var position: CGPoint? {
        didSet {
            
        }
    }
    
    @IBInspectable var circleSize: CGSize = CGSize(width: 75.0, height: 75.0)
    
    override init(color: CGColor, position: CGPoint) {
        let shapeLayer = CAShapeLayer
        
        
        // Create my track
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -0.5 * CGFloat.pi, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        
        
        trackLayer.lineCap = kCALineCapRound
        
        
        view.layer.addSublayer(trackLayer)
        
        
        //Circle
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeEnd = 0
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.layer.addSublayer(shapeLayer)
    }
    
    
    
}*/
