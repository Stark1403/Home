//
//  NavigatorLegacy.swift
//  ZeusAppExternos
//
//  Created by Jesus Rivera on 14/07/23.
//

import UIKit
import ZeusUtils
import ZeusCoreInterceptor
import ZeusSessionInfo

extension ZeusUtils.Navigator {
    func startFlow(forAction actionName: NavigatorKeys,
                           withInfo parameters: [String: Any]? = nil ) {
        
        switch actionName {
        case .notFound:
            break
        default:
            break
        }
    }
    
    private func presentFlowLegacy(flowItem: UIViewController) {
        UIApplication.topUtilViewController()?.navigationController?.pushViewController(flowItem, animated: true)
    }
}

extension ZeusCoreInterceptor.Navigator {
    func startFlow(forAction actionName: ZCInterceptorKeys,
                   withInfo parameters: [String: Any]? = nil ) {
        
        switch actionName {
            case ZCIExternalZeusKeys.notFound, ZCIInternalZeusKeys.notFound:
                break
            default:
                break
        }
    }
    
    private func presentFlowLegacy(flowItem: UIViewController) {
        UIApplication.topUtilViewController()?.navigationController?.pushViewController(flowItem, animated: true)
    }
}
