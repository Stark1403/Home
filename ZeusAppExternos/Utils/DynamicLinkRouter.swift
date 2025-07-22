//
//  DynamicLinkRouter.swift
//  ZeusAppExternos
//
//  Created by Jesus Rivera on 10/07/23.
//

import Foundation
import ZeusUtils
import FirebaseDynamicLinks

final class DynamicLinkRouter {
    
    static func redirectFlow(url: URL) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let urlHost = urlComponents.host,
              let urlScheme = urlComponents.scheme,
              let queryItems = urlComponents.queryItems,
              urlHost != "" else { return }
        
        let actionParams = getActionAndParams(from: queryItems)
        if let action = actionParams.action { self.addFlow(action: action, parameters: actionParams.parameters) }
    }
    
    static func redirectFlow(userActivity: NSUserActivity) {
        var permissionKey: String?
        var parameters: [String: Any] = [:]
        switch userActivity.activityType {
        case NSUserActivityTypeBrowsingWeb:
            guard let incomingURL = userActivity.webpageURL,
                  let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
                  let queryItems = components.queryItems,
                  queryItems.contains(where: { $0.name == "idPermiso" }) else { return }
            let actionParams = getActionAndParams(from: queryItems)
            permissionKey = actionParams.action
            parameters = actionParams.parameters
            
        default:
            break
        }
        if let action = permissionKey { self.addFlow(action: action, parameters: parameters) }
    }
    
    private static func getActionAndParams(from queryItems: [URLQueryItem]) -> (action: String?, parameters: [String: Any]) {
        var permissionKey: String?
        var parameters: [String: Any] = [:]
        queryItems.forEach({ queryItem in
            if queryItem.name == "idPermiso"{ permissionKey = queryItem.value ?? "" }
            parameters[queryItem.name] = queryItem.value
        })
        
        return (permissionKey, parameters)
    }
    
    private static func addFlow(action: String, parameters: [String: Any]) {
        NavigatorWaitModule.shared.addToWaitList(module: action, aditionalInfo: parameters)
    }
}
