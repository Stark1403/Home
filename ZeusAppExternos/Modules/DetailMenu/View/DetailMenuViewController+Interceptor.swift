//
//  DetailMenuViewController+Interceptor.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 05/07/23.
//

import Foundation
import ZeusCoreInterceptor
import ZeusTermsConditions

extension DetailMenuViewController {
    func openModule(permission: String) {
        let module = ZCIExternalZeusKeys(rawValue: permission)
        
        switch module {
            case .deleteAccount:
                
                break
            case .privacy:
            let closureFail: () -> Void = {
                OnboardingEvents.shared.sendEvent(.serviceFailureAP)
                //TYC
                SideMenuCollector.send(category: .legalSideBar, subCategory: .tyc, event: .openView, action: .error, metadata: "Error en el servicio")
                
            }
            
            OnboardingEvents.shared.sendEvent(.inAP)
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.webView, navigateDelegate: self,
                                       withInfo: ["url": LegalUrls.shared?.privacyUrl,
                                                  "title": Legal.privacyAnnounment.rawValue,
                                                  "eventFailed": closureFail])
                break
            case .termConditions:
            let closureFail: () -> Void = {
                //TYC
                SideMenuCollector.send(category: .legalSideBar, subCategory: .tyc, event: .openView, action: .error, metadata: "Error en el servicio")
                OnboardingEvents.shared.sendEvent(.serviceFailureTandC)
            }
            
            OnboardingEvents.shared.sendEvent(.inTandC)
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.webView, navigateDelegate: self,
                                           withInfo: ["url": LegalUrls.shared?.termsCondicionsUrl ?? "",
                                                      "title":  Legal.termsConditions.rawValue,
                                                      "eventFailed": closureFail])
                break
            case .passwordChange:
                
                break
            default:
                
                break
        }
        
    }
}

enum Legal: String {
    case privacyAnnounment = "Aviso de privacidad"
    case termsConditions = "Términos y condiciones"
}

