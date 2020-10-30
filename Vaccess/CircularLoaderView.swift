//
//  CircularLoaderView.swift
//  Vaccess
//
//  Created by emil on 2020-01-27.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class CircularLoaderView: UIView {

    @IBInspectable let circlePathLayer = CAShapeLayer()
    @IBInspectable let circleTrackLayer = CAShapeLayer()
    @IBInspectable let circleRadius: CGFloat = 50.0
    @IBInspectable var progressLabel = UILabel()
    @IBInspectable var indicator: Int = 0
    
    var progress: CGFloat {
      get {
        return circlePathLayer.strokeEnd
      }
      set {
        if newValue > 1 {
          circlePathLayer.strokeEnd = 1
        } else if newValue < 0 {
          circlePathLayer.strokeEnd = 0
        } else {
          circlePathLayer.strokeEnd = newValue
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
        progressLabel.text = "0%"
        
      configure()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      configure()
    }

    
    func configure() {
        progress = 0
        
        
        
        circleTrackLayer.frame = bounds
        circleTrackLayer.lineWidth = 10
        circleTrackLayer.fillColor = UIColor.clear.cgColor
        circleTrackLayer.lineCap = CAShapeLayerLineCap.round

        circleTrackLayer.strokeColor = UIColor.lightGray.cgColor
        
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 10
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.lineCap = CAShapeLayerLineCap.round

        if #available(iOS 13.0, *) {
            circlePathLayer.strokeColor = Theme.primaryCG
        } else {
            // Fallback on earlier versions
        }
        
        progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 2 * circleRadius, height: circleRadius))
        progressLabel.adjustsFontSizeToFitWidth = false
        progressLabel.font = UIFont(name: "Futura-CondensedExtraBold", size: 25.0)
        progressLabel.textAlignment = .center
        progressLabel.frame.origin.x = circleTrackLayer.frame.midX - progressLabel.frame.width/2
        progressLabel.frame.origin.y = circleTrackLayer.frame.midY - progressLabel.frame.height/2
        
        
        

        addSubview(progressLabel)
        layer.addSublayer(circleTrackLayer)
        layer.addSublayer(circlePathLayer)
        
        backgroundColor = nil
    }
    
    func circleFrame() -> CGRect {
      var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
      let circlePathBounds = circlePathLayer.bounds
      circleFrame.origin.x = circlePathBounds.midX - circleFrame.midX
      circleFrame.origin.y = circlePathBounds.midY - circleFrame.midY
    
      return circleFrame
    }

    func circlePath() -> UIBezierPath {
        //var path = UIBezierPath(ovalIn: circleFrame())
        let path = UIBezierPath(arcCenter: CGPoint(x: circleFrame().midX, y: circleFrame().midY), radius: circleFrame().width/2, startAngle: 3*CGFloat.pi/2, endAngle: 7*CGFloat.pi/2, clockwise: true)
        return path
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circleTrackLayer.frame = bounds
        circlePathLayer.path = circlePath().cgPath
        circleTrackLayer.path = circlePath().cgPath
    }
    
    func handleTap(numerator: Double, denominator: Double) {
        print("Lägg den")
        let toValue = numerator/denominator
        if (toValue).isNaN {
            progressLabel.text = "0%"
        }
        else {
            progressLabel.text = "\(Int(numerator))/\(Int(denominator))"
        }
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = toValue
        
        basicAnimation.duration = 1
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        self.circlePathLayer.add(basicAnimation, forKey: "urSoBASIC")
        
    }
    
}
