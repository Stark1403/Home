//
//  VersionValidator.swift
//  ZeusAppExternos
//
//  Created by Jesus Rivera on 08/06/23.
//

import UIKit
import Firebase
import FirebaseRemoteConfig
import ZeusUtils


final class VersionValidator {
    
    private static let updateAppCollectioniOS = "version_app_ios"
    private static let versionCodeCollection = "version_code"
    private static let obligatoryKeyCollection = "obligatory"
    
    static func checkAppVersion() {
        DispatchQueue.main.async {
            self.getLastAppVersionRemoteConfig { itIsObligatory in
                itIsObligatory ? showAlertObligatory() : showAlert()
            }
        }
    }
    
    private static func showAlertObligatory() {
        UIAlertController.showUDNSingleWith(title: "Actualización disponible",
                                            message: "Hay una nueva versión de la aplicación en la App Store. ¿Desea descargarla?",
                                            actionTitle: "Continuar",
                                            actionHandler:  {

            if let url = URL(string: "https://talentozeus.page.link/download"),
               UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10.0, *) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                   UIApplication.shared.openURL(url)
               }
           }
        })
    }
    
    private static func showAlert() {
        UIAlertController.showUDNDoubleWith(title: "Actualización disponible",
                                            message: "Hay una nueva versión de la aplicación en la App Store. ¿Desea descargarla?",
                                            firstActionTitle: "Cancelar",
                                            secondActionTitle: "Continuar",
                                            secondActionHandler:  {
            
            UIApplication.topUtilViewController()?.dismiss(animated: true)
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1444687630"),
               UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        })
        return
    }
    
    static func getLastAppVersionRemoteConfig(completionHandler: @escaping (Bool) -> Void) {
        var currentVersionCode = 0.0
        if let currentVersionCodeString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            currentVersionCode = getValidFormatFor(number: currentVersionCodeString)
        }
        var versionCode = 0.0
        var isObligatory = false
        
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetch()
        remoteConfig.fetchAndActivate { status, error in
            guard error == nil else {
                debugPrint("Error listening for config updates: \(String(describing: error))")
                return
            }
            switch status {
            case .successFetchedFromRemote, .successUsingPreFetchedData:
                let dataDict = remoteConfig.configValue(forKey: updateAppCollectioniOS).jsonValue as? [String: Any]
                if let gottenVersion = dataDict?[versionCodeCollection] as? Double, let obligatory = dataDict?[obligatoryKeyCollection] as? Bool {
                    versionCode = gottenVersion
                    isObligatory = obligatory
                }
                
                PrintManager.print("version code: \(versionCode). current version code: \(currentVersionCode). Is it required: \(isObligatory)")
                if versionCode > currentVersionCode {
                    completionHandler(isObligatory)
                }
            case .error:
                debugPrint("Error listening for config updates: \(String(describing: error))")
                break
            @unknown default:
                break
            }
        }
    }
    
    private static func getValidFormatFor(number: String) -> Double {
        var final_num = ""
        let versionPaths = number.split(separator: ".")
        
        final_num = String(versionPaths.first ?? "0")
        
        return Double(final_num) ?? 0
    }
}
