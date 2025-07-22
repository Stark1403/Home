//
//  UIStoryboard+Extension.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 12/09/23.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func overFullScreen(type: String) -> UIViewController {
        let vc = UIStoryboard(name: type, bundle: nil).instantiateInitialViewController()!
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
