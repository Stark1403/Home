//
//  HomeViewController+WorkFlowDelegate.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 24/05/24.
//

import Foundation
import ZeusWorkFlow
import UIKit

extension HomeViewController: WorkFlowDeviceOrientationDelegate {
    func rotateDevice(orientation: UIInterfaceOrientationMask) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.orientationLock = orientation
        }
    }
}
