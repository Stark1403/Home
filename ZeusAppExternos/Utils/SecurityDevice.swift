//
//  SecurityDevice.swift
//  ZeusAppExternos
//
//  Created by Jesus Rivera on 14/06/23.
//

import UIKit

struct ScurityDevice {
    func checkJailbreak() {
        guard !UIDevice.current.isSimulator else { return }
        guard UIDevice.current.isJailBroken else { return }
        UIAlertController.showUDNSingleWith(title: "Error", message: "Se detecto que este dispositivo tiene un sistema aperativo modificado") {
            debugPrint("error")
        }
    }
}
