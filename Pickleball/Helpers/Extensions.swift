//
//  Extensions.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/3/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}


extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIButton {
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 0.05
        flash.toValue = 0.7
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        flash.autoreverses = true
        flash.repeatCount = 0
        layer.add(flash, forKey: nil)
    }
}

extension Double {
    func round(nearest: Double) -> Double {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }
    
    func floor(nearest: Double) -> Double {
        let intDiv = Double(Int(self / nearest))
        return intDiv * nearest
    }
}
