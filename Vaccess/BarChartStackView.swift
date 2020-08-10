//
//  BarChartStackView.swift
//  Vaccess
//
//  Created by Emil Ryd on 2020-07-11.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class BarChartStackView: UIStackView {
    //MARK: Properties
        
        private var bars = [BarChartView]()
        
        //@IBInspectable var progressLabel = UILabel()

        
    @IBInspectable var barSize: CGSize = CGSize(width: 30.0, height: 70.0) {
            didSet {
                setupBars()
            }
        }

        @IBInspectable var barCount: Int = 3 {
            didSet {
                setupBars()
            }
        }
        
        //MARK: Initialization
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            //progressLabel.text = "0%"
            self.alignment = .center
            self.distribution = .equalSpacing

            self.layer.borderWidth = 5
            self.layer.borderColor = UIColor.red.cgColor

            setupBars()
        }

        required init(coder: NSCoder) {
            super.init(coder: coder)
            self.alignment = .center
            self.distribution = .equalSpacing
            self.layer.borderWidth = 5
            self.layer.borderColor = UIColor.red.cgColor

            setupBars()
        }
        
    
    
    
        
        
        
        //MARK: Private Methods
        
        private func setupBars() {
            
            self.alignment = .center

            print(self.bounds)
            
            // Clear any existing buttons
            for bar in bars {
                removeArrangedSubview(bar)
                bar.removeFromSuperview()
            }
            bars.removeAll()
            
            let totalSpacing = (self.frame.width - (barSize.width * CGFloat(barCount)))
            self.alignment = .center
            self.distribution = .equalSpacing

            

            self.spacing = totalSpacing/CGFloat((barCount-1))
            
            for index in 0..<barCount {
                // Create the button
                let bar = BarChartView()
                
                // Set the button images
                
                
                // Add constraints
                bar.translatesAutoresizingMaskIntoConstraints = false
                bar.heightAnchor.constraint(equalToConstant: barSize.height).isActive = true
                bar.widthAnchor.constraint(equalToConstant: barSize.width).isActive = true
                
                // Set the accessibility label
                
                
                // Setup the button action
                
                
                // Add the button to the stack
                addArrangedSubview(bar)
                if index == 2 {
                    self.setCustomSpacing(0, after: bar)

                }

                
                // Add the new button to the rating button array
                bars.append(bar)
                
                print(index)
            }
            
            /*progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
            progressLabel.adjustsFontSizeToFitWidth = false
            progressLabel.font = UIFont(name: "Futura-CondensedExtraBold", size: 25.0)
            progressLabel.textAlignment = .center
            progressLabel.frame.origin.x = self.frame.midX - progressLabel.frame.width/2
            progressLabel.frame.origin.y = self.frame.midY - progressLabel.frame.height/2
            
            
            

            addSubview(progressLabel)*/
            
            
        }
        
    func handleTap(increase: Bool) {
        
           //progressLabel.text = "0"
        
        
        var toValues = [0.3, 0.7, 1.0]
        if !increase {
            toValues = [0.0, 0.0, 0.0]
            
        }
        
        var index = 0
        for i in bars {
            i.handleTap(toValue: toValues[index])
            print(i.frame)

            index += 1
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
