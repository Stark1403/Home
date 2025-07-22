//
//  NavigatorRuler.swift
//  ZeusAppExternos
//
//  Created by Jesus Rivera on 22/06/23.
//

import Foundation
import ZeusUtils
import ZeusCoreInterceptor

class NavigatorRuler: ZeusUtils.NavigatorRulesDelegate, ZeusCoreInterceptor.NavigatorRulesDelegate{
    
    static let shared = NavigatorRuler()
    
    var stackFunctions: [String]? {
        get {
            [""]
        }
        set(newValue) {
            
        }
    }
    
    var hasEnableStackFlow: Bool {
        return true
    }
    
    func deleteActionWithName(actionName: String?) {
    }
    
    func evaluateGoToAction(nameAction: String) -> (canGo: Bool, error: NavigatorErrors) {

        return (canGo: true, error: .noError)
    }
    
    func evaluateGoToAction(nameAction: String) -> (canGo: Bool, error: ZeusCoreInterceptor.ZCInterceptorErrors) {
        return (canGo: true, error: ZCInterceptorErrors.noError)
    }
    
    private func checkCurrentStack(nameAction: String) -> (canGo: Bool, error: NavigatorErrors) {
        
        return (canGo: false, error: .noError)
    }
    
    func isActionAvailable(nameAction: String) -> Bool {
        return true
    }
}

