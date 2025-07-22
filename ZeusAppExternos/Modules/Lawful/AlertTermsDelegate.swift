//
//  AlertTermsDelegate.swift
//  ZeusAppExternos
//
//  Created by Karen Irene Arellano Barrientos on 22/08/23.
//

import Foundation
import UIKit
import ZeusSessionInfo
import ZeusCoreInterceptor

class AlertTermsDelegate: ZCInterceptorDelegate {
    var viewController: UIViewController?
    var accepted: Bool = false

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func didFailToEnterFlow(error: NSError) {

    }

    func willFinishFlow(withInfo info: [String : Any]?) {
        guard let info = info else { return }
        guard let declined = info["declinePrivacyTerms"] as? Bool else { return }
        accepted = !declined
    }

    func didFinishFlow() {
        if !accepted {
            SessionManager.logout()
        }
    }
}
