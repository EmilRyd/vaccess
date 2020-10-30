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
        
        let animationView = AnimationView(name: "5081-empty-box")
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        //animationView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //animationView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Futura-Bold", size: 21)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "Futura-Medium", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(animationView)
        emptyView.addSubview(messageLabel)
        
        /*animationView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 100).isActive = true*/
        animationView.frame = emptyView.bounds
        
        let height: CGFloat = 30
        
        messageLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: -(49 + height + 20)).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 16).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -16).isActive = true
        
        titleLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -16).isActive = true
        
        messageLabel.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.textAlignment = .center
        messageLabel.textAlignment = .center
        
        emptyView.bringSubviewToFront(messageLabel)
        emptyView.bringSubviewToFront(titleLabel)
        
        print("Här är dem: \(messageLabel.frame)")
        print(titleLabel.frame)
        
        animationView.play()
        //animationView.image = image
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        /*UIView.animate(withDuration: 1, animations: {
            
            animationView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                animationView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    animationView.transform = CGAffineTransform.identity
                })
            })
            
        })*/
        
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
