//
//  UIColorExtension.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 19/04/23.
//

import UIKit

extension UIColor {
    
//    MARK: Splash Screen
    static var ZESplashGradient1: UIColor {
        return UIColor(named: "splashScreenGradiant1") ?? .red
    }
    
    static var ZESplashGradient2: UIColor {
        return UIColor(named: "splashScreenGradiant2") ?? .red
    }
    
    static var ZESplashGradient3: UIColor {
        return UIColor(named: "splashScreenGradiant3") ?? .red
    }
    
    static var ZESplashGradientElllipse1: UIColor {
        return UIColor(named: "splashScreenGradientElllipse1") ?? .red
    }
    static var ZESplashGradientElllipse2: UIColor {
        return UIColor(named: "splashScreenGradientElllipse2") ?? .red
    }

//    MARK: Menu options
    static var menuOptionsTitles: UIColor {
        return UIColor(named: "menuOptionsTitles") ?? .red
    }
    static var menuOptionsIcons: UIColor {
        return UIColor(named: "menuOptionsIcons") ?? .red
    }
    
    //    MARK: Home modules cell
    static var homeNameUser: UIColor {
        return UIColor(named: "homeNameUser") ?? .red
    }
    
    static var homeCellTitle: UIColor {
        return UIColor(named: "homeCellTitle") ?? .red
    }
  
    static var secundaryGray: UIColor {
      return UIColor(named: "secundary.gray") ?? .gray
    }
}

func getLighterColor(from color: UIColor, factor: CGFloat) -> UIColor {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    // Extract the RGB components from the given color
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    // Apply the factor to lighten the color
    let newRed = min(red + (1.0 - red) * factor, 1.0)
    let newGreen = min(green + (1.0 - green) * factor, 1.0)
    let newBlue = min(blue + (1.0 - blue) * factor, 1.0)
    
    return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
}

func getDarkerColor(from color: UIColor, factor: CGFloat) -> UIColor {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    // Extraer los componentes RGB del color dado
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    // Aplicar el factor para oscurecer el color
    let newRed = max(red - red * factor, 0.0)
    let newGreen = max(green - green * factor, 0.0)
    let newBlue = max(blue - blue * factor, 0.0)
    
    return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
}

