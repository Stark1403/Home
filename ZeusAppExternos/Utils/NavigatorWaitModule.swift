//
//  NavigatorWaitModule.swift
//  ZeusAppExternos
//
//  Created by Jesus Rivera on 14/07/23.
//

import ZeusUtils
import ZeusSessionInfo
import UIKit
import ZeusCoreInterceptor

public class NavigatorWaitModule: ZCInterceptorDelegate {
    
    public static let shared: NavigatorWaitModule = NavigatorWaitModule()
    public var hasWaitForPrecondition: Bool = false
    public var wasValidPrecondition: Bool = false
    public var waitModule: String?
    public var aditionalInfo: [String : Any]?
    public var hadWaitMethod: Bool {
        !SessionInfo.shared.isSessionActive
    }

    public func didFailToEnterFlow(error: NSError) {
        showError()
    }
    
    public func addToWaitList(module: String, aditionalInfo: [String : Any]? = nil) {
        
        let currentFlow = ZCInterceptor.shared.currentFlow

        if currentFlow == module{
            RegisterActions.updateInfoFlow(withInfo: aditionalInfo)
            return
        }
        
        cleanWaitModule()
        waitModule = module
        self.aditionalInfo = aditionalInfo
        guard !hadWaitMethod else { return }
        startLastTrack()
    }

    public func addToWaitListPush(module: String, aditionalInfo: [String : Any]? = nil) {
        guard !hadWaitMethod else { return }
        cleanWaitModule()
        waitModule = module
        self.aditionalInfo = aditionalInfo
    }
    
    public func startLastTrackPush(module: String) {
        guard !hadWaitMethod else { return }
        let currentFlow = ZCInterceptor.shared.currentFlow
        if currentFlow == module{
            RegisterActions.updateInfoFlow(withInfo: aditionalInfo)
            return
        }
        
        guard let actionString = waitModule, let action = ZCIExternalZeusKeys(rawValue: actionString) else { return }
        let navigatorKeys = NavigatorKeys.allCases
        var isMigratedModule = false
        for navigatorKey in navigatorKeys where navigatorKey.rawValue == waitModule {
            isMigratedModule = true
        } 
        
        if isMigratedModule {
            ZCInterceptor.shared.startFlow(forAction: action, navigateDelegate: self, withInfo: aditionalInfo)
        } else {
            guard let intModule = waitModule else { showError(); return }
            guard let menuItem = ZCIExternalZeusKeys(rawValue: intModule) else { showError(); return }
            ZCInterceptor.shared.startFlow(forAction: action, navigateDelegate: self, withInfo: aditionalInfo)
        }
        cleanWaitModule()
    }
    
    public func startLastTrack() {
        
        guard let actionString = waitModule, let action = ZCIExternalZeusKeys(rawValue: actionString) else { return }
        let navigatorKeys = NavigatorKeys.allCases
        var isMigratedModule = false
        for navigatorKey in navigatorKeys where navigatorKey.rawValue == waitModule {
            isMigratedModule = true
        }
        
        if isMigratedModule {
            ZCInterceptor.shared.startFlow(forAction: action, navigateDelegate: self, withInfo: aditionalInfo)
        } else {
            guard let intModule = waitModule else { showError(); return }
            guard let menuItem = ZCIExternalZeusKeys(rawValue: intModule) else { showError(); return }
            ZCInterceptor.shared.startFlow(forAction: menuItem, withInfo: aditionalInfo)
        }
        cleanWaitModule()
    }

    public func cleanWaitModule() {
        waitModule = nil
        aditionalInfo = nil
    }
    
    private func showError() {
        UIAlertController.showUDNSingleWith(title: "Zeus", message: "Error al lanzar el módulo")
    }
}
