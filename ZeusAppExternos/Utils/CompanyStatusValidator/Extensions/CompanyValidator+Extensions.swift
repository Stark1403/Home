//
//  CompanyValidator+Extensions.swift
//  ZeusAppExternos
//
//  Created by Rafael on 16/11/23.
//

import Foundation


extension UserDefaults {
    enum UserDefaultsGenericKeys: String {
        case lastUpdateCompanyInfo = "key.lastUpdateCompanyInfo"
    }
    
    func setLastUpdateCompanyInfo(timestamp: Double) {
        self.set(timestamp, forKey: UserDefaultsGenericKeys.lastUpdateCompanyInfo.rawValue)
    }
    
    func getLastUpdateCompanyInfo() -> Double {
        self.double(forKey: UserDefaultsGenericKeys.lastUpdateCompanyInfo.rawValue)
    }
}
