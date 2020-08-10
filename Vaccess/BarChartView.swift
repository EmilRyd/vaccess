//
//  BarChartView.swift
//  Vaccess
//
//  Created by Emil Ryd on 2020-07-11.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class BarChartView: UIView {

    
        @IBInspectable let barPathLayer = CAShapeLayer()
        @IBInspectable let barTrackLayer = CAShapeLayer()
        @IBInspectable let barWidth: CGFloat = 30.0
        @IBInspectable let barHeight: CGFloat = 70.0

        @IBInspectable var indicator: Int = 0
        
        var progress: CGFloat {
          get {
            return barPathLayer.strokeEnd
          }
          set {
            if newValue > 1 {
              barPathLayer.strokeEnd = 1
            } else if newValue < 0 {
              barPathLayer.strokeEnd = 0
            } else {
              barPathLayer.strokeEnd = newValue
            }
          }
        }
        /*
        // Only override draw() if you perform custom drawing.
        // An empty implementation adversely affects performance during animation.
        override func draw(_ rect: CGRect) {
            // Drawing code
        }
        */
        override init(frame: CGRect) {
          super.init(frame: frame)
            
          configure()
        }

        required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          configure()
        }

        func configure() {
            progress = 0
            
            
            
            barTrackLayer.frame = bounds
            barTrackLayer.lineWidth = barWidth
            barTrackLayer.fillColor = UIColor.clear.cgColor
            barTrackLayer.lineCap = CAShapeLayerLineCap.square
            barTrackLayer.strokeColor = UIColor.clear.cgColor
            
            barPathLayer.frame = bounds
            barPathLayer.lineWidth = barWidth
            barPathLayer.fillColor = UIColor.clear.cgColor
            barPathLayer.lineCap = CAShapeLayerLineCap.square
            

            barPathLayer.strokeColor = CGColor(srgbRed: 0.108, green: 0.684, blue: 0.356, alpha: 1.0)
            
            layer.addSublayer(barTrackLayer)
            layer.addSublayer(barPathLayer)
            
            backgroundColor = nil
        }
        
        func circleFrame() -> CGRect {
          var circleFrame = CGRect(x: 0, y: 0, width: barWidth, height: barHeight)
          let circlePathBounds = barPathLayer.bounds
          circleFrame.origin.x = circlePathBounds.midX - circleFrame.midX
          circleFrame.origin.y = circlePathBounds.midY - circleFrame.midY
        
          return circleFrame
        }

        func circlePath() -> UIBezierPath {
            var path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: circleFrame().midX, y: circleFrame().maxY))
            path.addLine(to: CGPoint(x: circleFrame().midX, y: circleFrame().minY))
            return path
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            barPathLayer.frame = bounds
            barTrackLayer.frame = bounds
            barPathLayer.path = circlePath().cgPath
            barTrackLayer.path = circlePath().cgPath
        }
        
        func handleTap(toValue: Double) {
            print("Lägg den")
            
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            
            basicAnimation.toValue = toValue
            
            basicAnimation.duration = 1
            
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
            self.barPathLayer.add(basicAnimation, forKey: "urSoBASIC")
            
        }
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


