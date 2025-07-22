//
//  FCMTokenManager.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 08/08/23.
//

import Foundation
class FCMTokenManager {
    
    static let shared = FCMTokenManager()
    
    var currentToken: String? {
        get {
            UserDefaultsManager.getString(key: UserDefaultsKey.fcmTokenManager)
        }

        set {
            UserDefaultsManager.setString(key: UserDefaultsKey.fcmTokenManager, value: newValue ?? "")
        }
    }
}
