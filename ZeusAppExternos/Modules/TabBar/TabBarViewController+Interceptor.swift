//
//  TabBarViewController+Interceptor.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 12/09/23.
//

import Foundation
import ZeusUtils
import ZeusCoreInterceptor
import UIKit

extension TabBarViewController: ZeusUtils.NavigatorDelegate, ZeusCoreInterceptor.NavigatorDelegate {
    func didFailToEnterFlow(error: NSError) {
        let dialogMessage = UIAlertController(title: error.userInfo["value"] as? String, message: error.userInfo["description"] as? String, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    func didFinishFlow() {

    }
    func willFinishFlow(withInfo info: [String : Any]?) {

    }
}
