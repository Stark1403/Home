//
//  UIView+Extension.swift
//  ZeusAttendance
//
//  Created by Omar Becerra on 31/07/20.
//  Copyright © 2020 Gabriel Briseño. All rights reserved.
//

import UIKit.UIView
extension UIView {
    
    func setGradientWith(
        frame: CGRect,
        startPoint: CGPoint,
        endPoint: CGPoint,
        colorArray: [CGColor],
        type: CAGradientLayerType,
        locations: [NSNumber]? = [0, 1],
        cornerRadius: CGFloat = 25
    ) {
        
        let gradientLayer = CAGradientLayer()
        // An array of CGColorRef objects defining the color of each gradient stop. Animatable
        gradientLayer.type = type
        gradientLayer.colors = colorArray.map({$0})
        // An optional array of NSNumber objects defining the location of each gradient stop. Animatable.
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        // Frame of the layer
        gradientLayer.frame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: frame.height))
        gradientLayer.locations = locations
        gradientLayer.cornerRadius = cornerRadius
        
        // Mask of the layer into shimmerView
        if let _ = self.layer.sublayers?.first as? CAGradientLayer {
            layer.sublayers?[0] = gradientLayer
        }
        else {
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func setAnimationZoomOutWith(duration: TimeInterval = 0.3, completed: @escaping(_ : Bool) -> Void) {
        self.transform = CGAffineTransformIdentity
        
        UIView.animate(withDuration: duration, delay: 3, options: [.curveEaseOut], animations: { () -> Void in
            let translationMatrix = CGAffineTransform(translationX: 25.0, y: 6.5)
            let scale = CGAffineTransform(scaleX: 75, y: 75)
            self.transform = translationMatrix.concatenating(scale)
        }) { (animationCompleted: Bool) -> Void in
            completed(animationCompleted)
        }
    }
    
    func makeItCircular() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
}
