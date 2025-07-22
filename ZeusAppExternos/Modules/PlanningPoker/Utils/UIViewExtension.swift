//
//  UIViewExtension.swift
//  LocationEKT
//
//  Created by ARIEL DÍAZ on 7/30/19.
//  Copyright © 2019 Latbc. All rights reserved.
//

import UIKit
import ZeusCoreDesignSystem
enum ViewFeatures {
    case rounded, shadow, color(UIColor), bordered(UIColor, CGFloat), image(UIImage), roundedView(RoundedType, UIColor), topRounded, fullRounded, customRounded(UIRectCorner), customRoundedCorner(UIRectCorner, _ cornerRadius: CGFloat), vGradient([UIColor]), hGradient([UIColor])
    
}

enum RoundedType {
    case full, onlyLayer
}

@objc extension UIView {
    
    @objc func setOffset(at yPosition: CGFloat) {
        UIView.animate(withDuration: 0.4, animations: {
            self.frame.origin.y = yPosition
            
        })
    }
    
    @objc func setDayView(with color: UIColor) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = .identity
                
            }, completion: { _ in
                self.makeViewWith(features: [.color(color)])
                
            })
        })
    }
    
    func hideWithAnimation(hidden: Bool) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.isHidden = hidden
        })
    }
    
}

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.local.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
        
    }
    
    func makeViewWith(features: [ViewFeatures]?) {
        if let features = features as [ViewFeatures]? {
            features.forEach({
                switch $0 {
                case .rounded: self.layer.cornerRadius = 10; self.clipsToBounds = true
                case .shadow: self.setShadow()
                case .color(let color): self.backgroundColor = color
                case .bordered(let color, let borderWidth): self.setCornerRadius(color: color, borderWidth: borderWidth)
                case .image(let image): (self as! UIImageView).image = image
                case .roundedView(let roundedType, let color): self.setRounded(roundedType: roundedType, color: color)
                case .topRounded: self.setTopRounded()
                case .fullRounded: self.setFullRounded()
                case .customRounded(let corners): self.setRounded(at: corners, cornerRad: 10)
                case .customRoundedCorner(let corners, let cornerRadius): setRounded(at: corners, cornerRad: cornerRadius)
                case .vGradient(let colors): vGradient(colors: colors)
                case .hGradient(let colors): hGradient(colors: colors)
                }
            })
        }
    }
    
    func animateLoadingOverSelf() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        self.addSubview(activityIndicator)
        activityIndicator.frame = self.bounds
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        if let button = self as? ZDSButtonAlt {
            button.setTitle("", for: .normal)
        }
        self.isUserInteractionEnabled = false
        
    }
    
    func animateLoadingOverSelf(with color: UIColor?) {
        var defaultColor: UIColor!
        if #available(iOS 13.0, *) { defaultColor = .label }
        else { defaultColor = .black }
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        self.addSubview(activityIndicator)
        activityIndicator.frame = self.bounds
        activityIndicator.color = color ?? defaultColor
        activityIndicator.startAnimating()
        if let button = self as? ZDSButtonAlt {
            button.setTitle("", for: .normal)
        }
        self.isUserInteractionEnabled = false
    }
    
    func endAnimateOverSelf(originalFrame: CGRect, title: String) {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = originalFrame
            self.isUserInteractionEnabled = true
            if let button = self as? ZDSButtonAlt {
                button.setTitle(title, for: .normal)
            }
        })
        self.subviews.forEach {
            if let activity = $0 as? UIActivityIndicatorView {
                activity.removeFromSuperview()
                
            }
        }
    }
    
    func endAnimateOverSelf(with title: String) {
        isUserInteractionEnabled = true
        if let button = self as? ZDSButtonAlt {
            button.setTitle(title, for: .normal)
            
        }
        self.subviews.forEach {
            if let activity = $0 as? UIActivityIndicatorView {
                activity.removeFromSuperview()
                
            }
        }
    }
    
    func setRounded(roundedType: RoundedType, color: UIColor) {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.endEditing(true)
    }
    
}

@objc extension UIView {
    
    @objc func vGradient(colors: [UIColor]) {
        let gradientLayer = (layer.sublayers?.first as? CAGradientLayer) ?? CAGradientLayer()
        gradientLayer.frame.size = frame.size
        gradientLayer.colors = colors.map { $0.cgColor }
        let locations: [CGFloat] = (0 ..< colors.count).map { CGFloat($0) / CGFloat(colors.count-1) }
        gradientLayer.locations = locations as [NSNumber]
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    @objc func hGradient(colors: [UIColor]) {
        let gradientLayer = (layer.sublayers?.first as? CAGradientLayer) ?? CAGradientLayer()
        gradientLayer.frame.size = frame.size
        gradientLayer.colors =  colors.map{ $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    @objc func setRounded(at roundingCorners: UIRectCorner, cornerRad: CGFloat) {
        self.layer.mask = {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: cornerRad, height:  cornerRad))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            return maskLayer
        }()
    }
    
    @objc func setTopRounded() {
        self.setRounded(at: [.topLeft, .topRight], cornerRad: 30)
        
    }
    
    @objc func setFullRounded() {
        self.setRounded(at: [.topRight, .topLeft, .bottomLeft, .bottomRight], cornerRad: 10)
        
    }
    
    @objc func setShadow(){
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        
    }
    
    @objc func setCornerRadius(color: UIColor, borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
        
    }
    
    @objc func addActivityIndicator(bgColor: UIColor?) {
        self.addSubview({
            let childView = UIView()
            childView.backgroundColor = bgColor ?? .red
            childView.frame = self.bounds
            childView.addSubview({
                let activityIndicator = UIActivityIndicatorView(style: .gray)
                activityIndicator.color = .white
                activityIndicator.frame = self.bounds
                activityIndicator.startAnimating()
                return activityIndicator
                
            }())
            return childView
            
        }())
    }
    
    @objc func gradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = frame.size
        gradientLayer.colors = colors.map { $0.cgColor }
        var locations = [CGFloat]()
        for i in 0 ..< colors.count {
            locations.append(CGFloat(i) / CGFloat(colors.count-1))
        }
        gradientLayer.locations = locations as [NSNumber]
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func animateAsNotAllowed() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(translationX: -15, y: 0)
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveLinear, animations: {
                self.transform = CGAffineTransform(translationX: 15, y: 0)
                
            }, completion: { _ in
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveLinear, animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: 0)
                    
                })
            })
        })
    }
    
}
