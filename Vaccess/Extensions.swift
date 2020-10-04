//
//  Extensions.swift
//  QuickStartExampleApp
//
//  Created by emil on 2019-10-21.
//  Copyright © 2019 Back4App. All rights reserved.
//

import Foundation
import UIKit
import Lottie
extension UIViewController {
 class func displaySpinner(onView : UIView) -> UIView {
    
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
    
    var animationView: AnimationView? = .init(name: "890-loading-animation")
    animationView?.frame = onView.bounds
    animationView?.layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 80
    )
    animationView?.loopMode = .loop
    
    spinnerView.addSubview(animationView!)
    animationView?.play()
    
     
    //let ai = UIActivityIndicatorView.init(style: .whiteLarge)
    // ai.startAnimating()
    // ai.center = spinnerView.center

     DispatchQueue.main.async {
         //spinnerView.addSubview(ai)
        spinnerView.addSubview(animationView!)
         onView.addSubview(spinnerView)
     }

     return spinnerView
 }

 class func removeSpinner(spinner :UIView) {
     DispatchQueue.main.async {
         spinner.removeFromSuperview()
     }
 }
}


extension UITableView {
    
    func setEmptyView(title: String, message: String, image: String) {
        let image = UIImage(named: image)
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let imageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        imageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(imageView)
        emptyView.addSubview(messageLabel)
        
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        UIView.animate(withDuration: 1, animations: {
            
            imageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    imageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        
        self.backgroundView = nil
        self.separatorStyle = .singleLine
        
    }
    
}

extension UIView: CoachMarkSkipView {
    public var skipControl: UIControl? {
        return self as? UIControl
    }
    
    
}

public protocol CoachMarkSkipView: AnyObject {
    var skipControl: UIControl? { get }
}


extension UILabel {

    func animate(newText: String, characterDelay: TimeInterval) {

        DispatchQueue.main.async {

            self.text = ""

            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }

}
