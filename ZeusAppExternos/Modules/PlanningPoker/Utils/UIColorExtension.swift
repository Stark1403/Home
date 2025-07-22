//
//  UIColorExtension.swift
//  LocationEKT
//
//  Created by ARIEL DIAZ on 4/22/19.
//  Copyright © 2019 Latbc. All rights reserved.
//

import UIKit

extension UIColor {
    class var gsColor: UIColor { return UIColor(displayP3Red: 255.0/255.0, green: 205.0/255.0, blue: 0.0/255.0, alpha: 1) }
    class var verdeComprobacion: UIColor { return UIColor(displayP3Red: 51/255, green: 115/255, blue: 34/255, alpha: 1) }
    class var amarilloComprobacion: UIColor { return UIColor(displayP3Red: 249/255, green: 197/255, blue: 70/255, alpha: 1) }
    class var azulComprobacion: UIColor { return UIColor(displayP3Red: 26/255, green: 111/255, blue: 211/255, alpha: 1) }
    class var grisComprobacion: UIColor { return UIColor(displayP3Red: 129/255, green: 129/255, blue: 129/255, alpha: 1) }
    
    class var rojoHComprobacion: UIColor { return UIColor(displayP3Red: 255/255, green: 197/255, blue: 197/255, alpha: 1) }
    
    class var vacationsGray: UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.secondaryLabel
        } else {
            return UIColor(red:170/255, green:170/255, blue:170/255, alpha:1)
        }
    }
    
    class var vacationsGreen: UIColor { return UIColor(red:124/255, green:220/255, blue:97/255, alpha:1) }
    class var vacationsGreen2: UIColor { return UIColor(red:126/255, green:196/255, blue:167/255, alpha:1) }
    class var vacationsBlue: UIColor { return UIColor(red:83/255, green:143/255, blue:207/255, alpha:1) }
    class var vacationsRed: UIColor { return UIColor(red:210/255, green:87/255, blue:83/255, alpha:1) }
    class var vacationsOrange: UIColor { return UIColor(red:231/255, green:137/255, blue:82/255, alpha:1) }
    class var vacationsBlack: UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.label
        } else {
             return UIColor(red:1/255, green:1/255, blue:1/255, alpha:1)
        }
    }
    
    class var agileGreenActionSide: UIColor { return UIColor(red:84/255, green:171/255, blue:50/255, alpha:1) }
    class var agileGreenAction: UIColor { return UIColor(red:133/255, green:196/255, blue:127/255, alpha:1) }
    class var agileGreenPresent: UIColor { return UIColor(red:134/255, green:209/255, blue:63/255, alpha:1) }
    class var agileRedAction: UIColor { return UIColor(red:234/255, green:90/255, blue:102/255, alpha:1) }
    class var agileOrange: UIColor { return UIColor(red:240/255, green:196/255, blue:118/255, alpha:1) }
    class var agileBlue: UIColor { return UIColor(red:61/255, green:143/255, blue:237/255, alpha:1) }
    class var eventTrainingBlue: UIColor { return UIColor(red:113/255, green:159/255, blue:237/255, alpha:1) }
    class var eventTrainingGreen: UIColor { return UIColor(red:95/255, green:200/255, blue:109/255, alpha:1) }
    class var orangePlanningPoker: UIColor { return UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)}
    class var orangePlanningPoker2: UIColor { return UIColor(red: 250/255, green: 162/255, blue: 7/255, alpha: 1)}
    class var grayPlanningPoker: UIColor { return .gray }
    class var grayPlanningPoker2: UIColor { return .darkGray }
    
    var hexString: String {
        let colorRef = cgColor.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha
        
        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
        
        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a)))
        }
        
        return color
    }
    
    class var guest0: UIColor { return UIColor(hexString: "ffc605") }
    class var guest1: UIColor { return UIColor(hexString: "ffb305") }
    class var guest2: UIColor { return UIColor(hexString: "fe8100") }
    class var guest3: UIColor { return UIColor(hexString: "ff9305") }
    class var guest4: UIColor { return UIColor(hexString: "d60000") }
    class var guest5: UIColor { return UIColor(hexString: "700808") }
    class var guest6: UIColor { return UIColor(hexString: "28c9ae") }
    class var guest7: UIColor { return UIColor(hexString: "08473e") }

    class var FSGreen: UIColor { return UIColor(red: 27/255, green: 155/255, blue: 0/255, alpha: 1)}
    
    class var labelColor: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
	}
    }
    
    class var tertiarySystemBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiarySystemBackground
        } else {
            return .white
        }
    }
    class var secondaryLabelColor: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .lightGray
        }
    }
    class var systemBGColor: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
