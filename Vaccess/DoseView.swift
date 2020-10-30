//
//  DoseView.swift
//  Vaccess
//
//  Created by emil on 2020-03-18.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

@IBDesignable class DoseView: UIStackView {
    
    @IBInspectable var doseNumber: Int = 0

    //MARK: Initialization
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupImages(doseNumber: doseNumber)
    }
    init(coder: NSCoder, doseNumber: Int) {
        super.init(coder: coder)
        self.doseNumber = doseNumber
        setupImages(doseNumber: doseNumber)
    }
    init(frame: CGRect, doseNumber: Int) {
        super.init(frame: frame)
        self.doseNumber = doseNumber

        setupImages(doseNumber: doseNumber)
        

    }
    
    func changeDoseNumber(doseNumber: Int) {
        self.doseNumber = doseNumber
        for view in self.subviews {
            view.removeFromSuperview()
        }
        setupImages(doseNumber: doseNumber)
    }
    
    //MARK: Private methods
    
    private func setupImages(doseNumber: Int) {
        for _ in 0..<doseNumber {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "doseViewImage")
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
            
            self.spacing = -25
            imageView.backgroundColor = .clear
            if #available(iOS 13.0, *) {
                imageView.image?.withTintColor(.blue)
            } else {
                
            }
            
             
            
            addArrangedSubview(imageView)
        }
        self.backgroundColor = .clear
        
    }
    
    
    
    

}
