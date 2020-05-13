//
//  UIViewExtension.swift
//  
//
//  Creat

















import UIKit

extension UIView {
    func addShadowAndRoundedCorners() {
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 10
    }
    func addRoundedCorners() {
        layer.cornerRadius = 10
    }
}
