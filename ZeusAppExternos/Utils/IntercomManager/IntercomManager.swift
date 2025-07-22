//
//  IntercomManager.swift
//  ZeusAppExternos
//
//  Created by Victor De la Torre on 1/04/24.
//

import Foundation
import ZeusKeyManager

enum IntercomTypeOptions: String {
    case intercom = "ZeusIntercomSDK"
    case appID = "IntercomAppID"
    case key = "IntercomApiKey"
}

class IntercomManager {
    static func getIntercomKey() -> (appID: String, key: String) {
        let dict = TalentoZeusConfiguration.intercomConfiguration
        guard let appID = dict[IntercomTypeOptions.appID.rawValue],
              let key = dict[IntercomTypeOptions.key.rawValue] else { return ("","")}
        return (appID, key)
    }
}
