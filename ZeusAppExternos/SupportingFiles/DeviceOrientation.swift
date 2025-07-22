//
//  DeviceOrientation.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 23/05/24.
//

import Foundation
import UIKit

struct DeviceOrientation {
    
    /**
     Configure la vista de bloqueo a una disposición tipo Portrait y Landscape
     establesca .all haciendo disponible todas las configuraciones posibles de orientación
     */
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /**
     Bloquee la orientación del dispositivo segun sea su configuracion **UIInterfaceOrientationMask**
     
     - parameter orientation: Orientación de pantalla en la cual desea bloquear
     - parameter rotateOrientation: Disposición de pantalla use los tipos que sean necesarios segun desee
     */
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
}
