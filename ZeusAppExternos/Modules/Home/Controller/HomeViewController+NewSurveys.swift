//
//  HomeViewController+NewSurveys.swift
//  ZeusAppExternos
//
//  Created by Karen Irene Arellano Barrientos on 01/03/24.
//

import Foundation
import ZeusSessionInfo
import ZeusCoreInterceptor

extension HomeViewController {
    func openSurveys(permission: PermissionMenuModel) {
        
        var parameters = [String: Any]()
        let hasCreateTaskPermission = SessionInfo.shared.permissions?.contains(where: { $0.id == Int(ZCIExternalZeusKeys.createTask.rawValue) })
        
        parameters["isMobileDataEnabled"] = UserDefaultsManager.getBool(key: .mobileDataactivated)
        parameters["isCreateTaskEnabled"] = hasCreateTaskPermission
        
        ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.tareasID, navigateDelegate: self, withInfo: parameters)
    }
    
    func openHappinessSurveys(permission: PermissionMenuModel) {
        var parameters = [String: Any]()
        parameters["isMobileDataEnabled"] = UserDefaultsManager.getBool(key: .mobileDataactivated)
        parameters["isCreateTaskEnabled"] = false
        
        ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.happinessSurvey, navigateDelegate: self, withInfo: parameters)
    }
}
