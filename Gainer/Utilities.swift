//
//  Utilities.swift
//  Gainer
//
//  Created by Ashwin Paudel on 2021-05-09.
//  Copyright © 2020 Ashwin Paudel. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    static func styleTextField(_ textfield: UITextField) {
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.black.cgColor

        textfield.layer.cornerRadius = 5
    }

    static func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: (CGFloat)((rgbValue & 0xFF0000) >> 16)/255.0, green: (CGFloat)((rgbValue & 0x00FF00) >> 8)/255.0, blue: (CGFloat)(rgbValue & 0x0000FF)/255.0, alpha: 1.0)
    }

    static func styleFilledButton(_ button: UIButton) {
        // Filled rounded corner style
//        button.backgroundColor = UIColor.red
//        button.layer.cornerRadius = 5.0
//        button.tintColor = UIColor.white
//        button.titleLabel?.textColor = .white
//        button.setTitleColor(.white, for: .normal)
//
//                let l = CAGradientLayer()
//            l.frame = button.bounds
//                l.colors = [UIColor.systemYellow.cgColor, UIColor.systemPink.cgColor]
//                l.startPoint = CGPoint(x: 0, y: 0.5)
//                l.endPoint = CGPoint(x: 1, y: 0.5)
//                l.cornerRadius = 16
//        button.layer.insertSublayer(l, at: 0)
//
//

        button.applyGradient(colors: [self.UIColorFromRGB(0xBB0011).cgColor, self.UIColorFromRGB(0xFF081F).cgColor])
        button.layer.cornerRadius = 5
    }

    static func styleHollowButton(_ button: UIButton) {
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.black
    }

    static func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}

extension UIButton {
    func applyGradient(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.frame.height/2

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
        self.contentVerticalAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.titleLabel?.textColor = UIColor.white
    }
}

extension UIView {
    func applyGradienta(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
//        gradientLayer.cornerRadius = self.frame.height/2

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UITextField {
    func setGradient(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
//        gradientLayer.cornerRadius = self.frame.height/2

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
