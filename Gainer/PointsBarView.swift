//
//  PointsBarView.swift
//  Gainer
//
//  Created by Ashok Paudel on 2021-01-16.
//

import UIKit

class PointsBarView: UIView {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
