//
//  UIAlertView.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 04/04/23.
//

import UIKit
import Alamofire

class UIAlertView {
    class func showYesNoAlert(title: String, message: String, viewController: UIViewController, yesCompletion: @escaping () ->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (alertAction) in
            DispatchQueue.main.async {yesCompletion()}
        }))
        viewController.present(alert, animated: true)
    }
    
    class func showRequireWifiAlert(viewController: UIViewController, closure: @escaping (Bool) -> Void) {
        if ReachabilityNetworkManagerStatus.networtkIsReachable {
            if ReachabilityNetworkManagerStatus.isReachableOnCellular {
                let alert = UIAlertController(title: "Advertencia", message: "Se requiere descargar información adicional, esto consumirá tus datos móviles", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler:
                { _ in
                        closure(true)
                        
                }))
                alert.addAction(UIAlertAction(title: "Esperar Wifi", style: .cancel, handler: nil))
                viewController.present(alert, animated: true)
            } else {
                closure(true)
            }
        } else {
            closure(false)
        }
    }
}

class ReachabilityNetworkManagerStatus {
    public static var networtkIsReachable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    public static var isReachableOnCellular: Bool {
        return NetworkReachabilityManager()?.isReachableOnWWAN ?? false
    }
}
