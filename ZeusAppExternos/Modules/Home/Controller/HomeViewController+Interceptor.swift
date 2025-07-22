//
//  HomeViewController+Interceptor.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 03/07/23.
//

import Foundation
import UIKit
import Firebase
import ZeusSessionInfo
import ZeusCoreInterceptor
import SwiftUI

extension HomeViewController {
    func openModule(permission: PermissionMenuModel) {
        
        var parameters = [String: Any]()
     
        if permission.childs.count > 0 {
            let vc = ZMTSubModulesRouter.createModule(permission: permission.childs, titleMenu: permission.name)
            delegate?.pushToMainNavigationController(viewController: vc)
            return
        }
     
        guard let menu = ZCIExternalZeusKeys(rawValue: String(permission.idPermission)) else { return }
        
        let metadata = "modulo: " + "\(menu)"
        HomeEventCollector.send(category: .homeEvent, subCategory: .mainView, event: .tapModuleHome, action: .click, metadata: metadata)
        
        switch menu {
        case .trainings:
            parameters["isMobileDataEnabled"] = UserDefaultsManager.getBool(key: .mobileDataactivated)
                ZeusCoreInterceptor.Navigator.shared.startFlow(forAction: ZCIExternalZeusKeys.trainings, navigateDelegate: self, withInfo: parameters)
            break
        case .tareasID:
            self.openSurveys(permission: permission)
        case .comunicadosID:
            if UserDefaultsManager.getIsFirstUserLoadAnnouncements(for: SessionInfo.shared.user?.zeusId ?? "") {
                parameters = ["delegate": self, "counter": 0]
                ZeusCoreInterceptor.Navigator.shared.startFlow(forAction: ZCIExternalZeusKeys.comunicadosID, navigateDelegate: self, interruptorDatasource: nil, withInfo: parameters)
            } else {
                UserDefaultsManager.setIsFirstUserLoadAnnouncements(for: SessionInfo.shared.user?.zeusId ?? "", value: true)
                let swiftUIView = TipsView(delegate: self)
                let hostingController = UIHostingController(rootView: swiftUIView)
                hostingController.modalPresentationStyle = .fullScreen
                self.headerColor = .white
                self.present(hostingController, animated: true, completion: nil)
            }
            break
        case .drive:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.drive, navigateDelegate: self, withInfo: parameters)
            break
        case .teamManagement:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.teamManagement, navigateDelegate: self, interruptorDatasource: nil, withInfo: parameters)
            break
        case .missionVision:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.missionVision, navigateDelegate: self)
            break
        case .attendance:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.attendance, navigateDelegate: self)
            break
        case .documentRequest:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.documentRequest, navigateDelegate: self)
            break
        case .organizationChart:
                ZeusCoreInterceptor.Navigator.shared.startFlow(forAction: ZCIExternalZeusKeys.organizationChart, navigateDelegate: self, withInfo:  ["companyID" : SessionInfo.shared.company?.companyId ?? 0, "collaboratorID" : SessionInfo.shared.user?.employeeNumber ?? "", "zeusID" : SessionInfo.shared.user?.zeusId ?? "", "delegate" : self, "primaryColor" : SessionInfo.shared.company?.primaryUIColor ?? UIColor.white, "secondaryColor" : SessionInfo.shared.company?.secondaryUIColor ?? UIColor.white ])
            break
        case .managementIndicators:
                ZCInterceptor.shared.startFlow(
                    forAction: ZCIExternalZeusKeys.managementIndicators,
                    navigateDelegate: self,
                    withInfo: [
                        "companyID" : SessionInfo.shared.company?.companyId ?? 0,
                        "collaboratorID" : SessionInfo.shared.user?.zeusId ?? "",
                        "delegate" : self
                    ]
                )
            break
        case .happinessSurvey:
            self.openHappinessSurveys(permission: permission)
        case .learningCenter:
            ZeusCoreInterceptor.Navigator.shared.startFlow(forAction: ZCIExternalZeusKeys.learningCenter, navigateDelegate: self, withInfo: ["delegate" : self])
            break

        case .onboarding:
            ZCInterceptor.shared.startBackgroundTask(forAction: ZCIExternalZeusKeys.onboarding, navigateBackgroundDelegate: self, withInfo: [:])
            break
        case .myTalent:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.myTalent, navigateDelegate: self, withInfo: parameters)
            break
        case .documentManager:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.documentManager, navigateDelegate: self, withInfo: [:])
            break
        case .laborQuality:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.laborQuality, navigateDelegate: self, withInfo: [:])
            break
        default:
            break
        }
    }
}
extension HomeViewController: ZeusCoreInterceptor.NavigatorDelegate {
    func didFailToEnterFlow(error: NSError) {
        let dialogMessage = UIAlertController(title: error.userInfo["value"] as? String, message: error.userInfo["description"] as? String, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func didFinishFlow() {
        let tab = HomeViewController.self
        if let topController = getHomeTopViewController() {
            if topController is HomeViewController {
                if shouldOpenModules {
                    goToModulesMenu()
                    shouldOpenModules = false
                }
            }
        }
    }
    
    func willFinishFlow(withInfo info: [String : Any]?) {
    }
    
    func getHomeTopViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first,
              let rootViewController = window.rootViewController else {
            return nil
        }
        return getTopViewController(from: rootViewController)
    }

    private func getTopViewController(from viewController: UIViewController) -> UIViewController? {
        if let presentedViewController = viewController.presentedViewController {
            return getTopViewController(from: presentedViewController)
        }
        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return getTopViewController(from: visibleViewController)
        }
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return getTopViewController(from: selectedViewController)
        }
        return viewController
    }
}

extension HomeViewController: ZCInterceptorBackgroundDelegate {
    func didFinishTask(withInfo info: [String : Any]?) {
        
        // MARK: The delegate doesnt know which framework it comes from
        guard let ZeusKey = info?["ZeusKey"] as? String else {
            // MARK: Send ZeusKey from your framework inside info dictionary
            return
        }
        
        let menu = ZCIExternalZeusKeys(rawValue: ZeusKey)

        switch menu {
        case .onboarding:
            if let hasOnboarding = info?["hasOnboarding"], hasOnboarding as? Bool ?? false {
                ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.onboarding, navigateDelegate: self, withInfo: ["delegate" : self])
            }
        default:
            break
        }
        
       
    }
}
