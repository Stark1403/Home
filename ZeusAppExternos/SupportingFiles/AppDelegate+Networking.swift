//
//  AppDelegate+Networking.swift
//  ZeusAppExternos
//
//  Created by Uriel Rodolfo Olascoaga Gomez on 25/03/24.
//

import Foundation
import UPAXNetworking
import ZeusKeyManager

extension AppDelegate {
    func setupUPAXNetworking() {
        let unauthenticatedKey: String = TalentoZeusConfiguration.networkingUnauthenticatedKey
        ZeusV2NetworkManager.shared.networking.configuration.unauthenticatedKey = unauthenticatedKey.replacingOccurrences(of: "\\", with: "")
        
        ZeusV2NetworkManager.shared.networking.configuration.loginVersion = .zeusV2(
            loginUrl: "\(TalentoZeusConfiguration.baseURL)/v2/auth",
            refreshUrl: "\(TalentoZeusConfiguration.baseURL)/v2/auth/refresh"
        )
    }
}
