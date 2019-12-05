//
//  GradientView.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 04/12/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation
import UIKit

class GradiantView: UIView {
    
    private let gradient : CAGradientLayer = CAGradientLayer()
    
    func setgradientBackground(startColour: UIColor, endColour: UIColor) {
        
        gradient.frame = self.bounds // Defines the bounds of the view you apply this to
        gradient.colors = [startColour.cgColor, endColour.cgColor]
        gradient.locations = [0.0, 1.0] // Distrubtion of colors
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0) // Start vector
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0) // End vector
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient.frame = self.bounds
    }
}
