//
//  GradientView.swift
//  PhotoBomb
//
//  Created by Sehajbir Randhawa on 6/21/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }

}
