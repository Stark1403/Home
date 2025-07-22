//
//  UIViewController+Extension.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 07/09/23.
//

import Foundation
import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo

extension UIViewController {
    enum SlideDirection {
        case right, left
    }
    
    func presentSlide(_ viewController: SlideViewController, direction: SlideDirection = .right, margin: CGFloat = 80.0, permissionModel: [PermissionMenuModel], isGuest: Bool = false) {
        let width = UIScreen.main.bounds.width
        let childViewControllerTranslation = direction == .right ? width - margin : -width + margin
        
        if let sideMenuBackView = UIApplication.shared.sideMenuBackView {
            UIView.animate(withDuration: 0.40) {
                sideMenuBackView.alpha = 1
            }
        }
        if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
            slideView.setMenu(permissions: permissionModel)
            slideView.transform = CGAffineTransform(translationX: childViewControllerTranslation, y: 0.0)
            UIView.animate(withDuration: 0.40) {
                slideView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            }
        }
      
    }
    
    
}

extension UIApplication {
    var sliderView: UIView? {
        let tag = 1348250
        
        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first
        
        if let loaderView = keyWindow?.viewWithTag(tag) {
            return loaderView
        } else {
            let frame = keyWindow?.frame ?? .zero
            let loaderView = DetailMenuRouter.createModule(menuPermissions: [])
            loaderView.frame = frame
            loaderView.tag = tag
            loaderView.layer.zPosition = 100_010

            keyWindow?.addSubview(loaderView)
            return loaderView
        }
    }
}

extension UIApplication {
    var biometricAlert: UIView? {
        let tag = 1348251
        
        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first
        
        if let loaderView = keyWindow?.viewWithTag(tag) {
            return loaderView
        } else {
            let loaderView = DeactivateBiometricsAlertView.get(on: keyWindow ?? UIView(), tag: 1348251)
            return loaderView
        }
    }
    
    var activateBiometricsAlert: UIView? {
        let tag = 1348251
        
        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first
        
        if let loaderView = keyWindow?.viewWithTag(tag) {
            return loaderView
        } else {
            let loaderView = ActivateBiometricsAlertView.get(on: keyWindow ?? UIView(), tag: 1348251)
            return loaderView
        }
    }
    
    var biometricDisabledAlert: UIView? {
        let tag = 1348251
        
        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first
        
        if let loaderView = keyWindow?.viewWithTag(tag) {
            return loaderView
        } else {
            var alert = ZDSAlert()
            alert.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor ?? .blue
            alert.title = "Datos biométricos no configurados"
            alert.message = "Para activar esta función, primero debes configurar el desbloqueo por reconocimiento facial o huella dactilar en los ajustes del dispositivo."
            alert.primaryTitle = "Ok"
            
            let view = alert.asUIKitView()
            view.tag = tag
            view.isHidden = true
            view.layer.zPosition = 100_011
            keyWindow?.addSubview(view)
            
            let keyWindow = keyWindow ?? UIView()
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: keyWindow.topAnchor),
                view.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
            ])
            
            alert.onPrimaryAction = {
                if let slideView = UIApplication.shared.biometricDisabledAlert {
                    slideView.isHidden = true
                }
            }
            return view
        }
    }
    
    var mobileDataAlert: UIView? {
        let tag = 1348251
        
        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first
        
        if let loaderView = keyWindow?.viewWithTag(tag) {
            return loaderView
        } else {
            let frame = keyWindow?.frame ?? .zero
            let loaderView = MobileDataAlert()
            loaderView.isHidden = true
            loaderView.frame = frame
            loaderView.tag = tag
            loaderView.layer.zPosition = 100_011

            keyWindow?.addSubview(loaderView)
            return loaderView
        }
    }
}

extension UIApplication {
    var closeSessionAlert: UIView? {
        let tag = 1348251
        
        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first
        
        if let loaderView = keyWindow?.viewWithTag(tag) {
            return loaderView
        } else {
            let frame = keyWindow?.frame ?? .zero
            let loaderView = CloseSessionAlert()
            loaderView.isHidden = true
            loaderView.frame = frame
            loaderView.tag = tag
            loaderView.layer.zPosition = 100_011

            keyWindow?.addSubview(loaderView)
            return loaderView
        }
    }
}


extension UIApplication {
    var sideMenuBackView: UIView? {
        let tag = 1348247
        
        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first
        
        if let loaderView = keyWindow?.viewWithTag(tag) {
            return loaderView
        } else {
            let frame = keyWindow?.frame ?? .zero
            let loaderView = UIView()
            loaderView.backgroundColor = .black.withAlphaComponent(0.4)
            loaderView.alpha = 0
            loaderView.frame = frame
            loaderView.tag = tag
            loaderView.layer.zPosition = 100_002

            keyWindow?.addSubview(loaderView)
            return loaderView
        }
    }
}



extension UIView {
    func roundCornersNew(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
