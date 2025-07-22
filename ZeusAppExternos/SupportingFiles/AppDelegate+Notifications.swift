//
//  AppDelegate+Notifications.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 03/08/23.
//

import Foundation
import ZeusSessionInfo
import UIKit
import FirebaseMessaging
import ZeusChat
import ZeusCoreInterceptor
import Intercom
import ZeusAttendanceControl

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Intercom.setDeviceToken(deviceToken)
    }
    
    //    MARK: Notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let info = notification.request.content.userInfo as? [String : AnyObject] {
            
            guard let action = info["action"] as? String  else {
                completionHandler([.banner, .badge, .sound])
                return
            }
            
            let module = ZCIExternalZeusKeys(rawValue: action)
            
            switch module{
                case .chatZeus:
                    ChatZeusItem.validateCurrentChat(withInfo: info) ? completionHandler([]) : completionHandler([.banner, .badge, .sound])
            case .logOut:
                print("logut")
                completionHandler([.banner, .badge, .sound])
                SessionManager.logout()
                BiometricAuthManager.shared.setBiometricSwitchState(isOn: false)
            case .myTalent:
                print("Opening talents")
                default:
                    completionHandler([.banner, .badge, .sound])
            }
        }
    }
    
    //    MARK: Notification in background
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let info = userInfo as? [String : AnyObject] {
            
            guard let action = info["action"] as? String  else {
                completionHandler(UIBackgroundFetchResult.newData)
                return
            }
            
            let module = ZCIExternalZeusKeys(rawValue: action)
            switch module{
            case .logOut:
                print("logut")
                SessionManager.logout()
                BiometricAuthManager.shared.setBiometricSwitchState(isOn: false)
            default:
                storeNotification(info: info)
            }
        }
        completionHandler(UIBackgroundFetchResult.newData)
        
    }

    //    MARK: Tap on notification
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let info = response.notification.request.content.userInfo as? [String : Any] {
            addToWaitListPush(info: info)
            removeBadgeOnTap(info: info)

            if let infoDefault = UserDefaultsManager.getDictionary(key: .remoteNotification) {
                if infoDefault.count >= 1{
                    return
                }
            }
            startLastTrackPush(info: info)
            if let itemId = info["idNotificationMessage"] as? String {
                ZNExternosServices.updateNotificationStatus(dataToSend: NotificationUpdateRequest(idNotification: itemId, idCollaborator: "")) { response in
                    if let _ = response {
                        DatabaseNotificationManager.shared.saveNotificationStatus(notification: NewNotification(id: itemId, title: "", description: "", startDate: "", endDate: "", icon: "", status: 2, module: ModuleNewNotification(id: 0, idItem: "")))
                    }
                    completionHandler()
                }
            }
            handleNotificationActions(didReceive: response, withCompletionHandler: completionHandler)
        }
    }
    
    func addToWaitListPush(info: [String: Any]){
        guard let action = info["action"] as? String  else {
            return
        }
        var pushInfo: [String: Any] = info
        pushInfo["comeFromPushNotification"] = true
        
        NavigatorWaitModule.shared.addToWaitListPush(module: action, aditionalInfo: pushInfo)
        
    }
    
    func startLastTrackPush(info: [String: Any]) {
        if let redirectToHome = info["redirectToHome"] as? Bool,
           redirectToHome == true {
            ZCInterceptor.shared.releaseFlows()
        }
        guard let action = info["action"] as? String  else {
            return
        }
        
        let module = ZCIExternalZeusKeys(rawValue: action)
        switch module{
        case .logOut:
            print("logut")
            SessionManager.logout()
            BiometricAuthManager.shared.setBiometricSwitchState(isOn: false)
        default:
            // Get redirection id
            if let redirect = getNotificationItem(fromNotificationInfo: info)?.redirect {
                NavigatorWaitModule.shared.aditionalInfo?["redirect"] = redirect
            } else {
                // If item info don't have redirection id but needs some redirection from notifications
                if action == ZCIExternalZeusKeys.attendance.rawValue {
                    NavigatorWaitModule.shared.aditionalInfo?["redirect"] = 0
                }
            }
            
            if let additionalInfo = getModuleConfigurations(action) {
                NavigatorWaitModule.shared.aditionalInfo?.merge(additionalInfo, uniquingKeysWith: { (current, _) in current })
            }
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            NavigatorWaitModule.shared.startLastTrackPush(module: action)
        }
    }
    
    func didHomeAppear(){
        
        guard let info = UserDefaultsManager.getDictionary(key: .remoteNotification) else { return }

        if info.count >= 1{
            UserDefaultsManager.removeObject(key: .remoteNotification)
            startLastTrackPush(info: info)
        }
    }
    
    func storeNotification(info: [String: Any]){
        guard let action = info["action"] as? String  else {
            return
        }
        if let idPermissionInt = Int(action){
            NotificationsManager.shared.insertNotifications(idPermission: idPermissionInt, element: "", number: 1)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPushNotification") , object: nil, userInfo: info)
        }
    }
    
    func handleNotificationWhenAppIsKilled(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let info = launchOptions?[.remoteNotification] as?  [AnyHashable : Any] {
            UserDefaultsManager.setDictionary(key: .remoteNotification, value: info)
        }
    }
    
    func deleteStoredNotificationsData(){
        UserDefaultsManager.removeObject(key: .remoteNotification)
        UserDefaultsManager.removeObject(key: .currentChat)
    }
    
    func removeBadgeOnTap(info: [String: Any]){
        guard let action = info["action"] as? String  else {
            return
        }
        if let idPermission = Int(action){
            NotificationsManager.shared.updateNotifications(idPermission: idPermission, element: "")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPushNotification") , object: nil, userInfo: info)
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

extension AppDelegate {
    func handleNotificationActions(didReceive response: UNNotificationResponse,
                                   withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case AttendancesNotificationsManager.shared.actionIdentifierCheckin,
                AttendancesNotificationsManager.shared.actionIdentifierCheckout :
            AttendanceOpenClass.shared.registerAttendance(completionHandler: completionHandler)
            break
        case AttendancesNotificationsManager.shared.actionIdentifierLunchtimeCheckin,
            AttendancesNotificationsManager.shared.actionIdentifierLunchtimeCheckout:
            AttendanceOpenClass.shared.registerLunchtime(completionHandler: completionHandler)

        default:
            completionHandler()
        }
    }
}

extension AppDelegate {
    
    /// Get dictionary with the required information to start the flow
    /// - Parameter module: String: ID of the module to prepare configurations
    /// - Returns: [String:Any]?: Dictionary with the required information to start the flow
    func getModuleConfigurations(_ module: String) -> [String:Any]? {
        switch module {
        case ZCIExternalZeusKeys.managementIndicators.rawValue:
            let params: [String:Any] = [
                "companyID" : SessionInfo.shared.company?.companyId ?? 0,
                "collaboratorID" : SessionInfo.shared.user?.zeusId ?? "",
                "delegate" : self
            ]
            return params
        default:
            return nil
        }
    }
    
    
    /// Get "item" object from notification info
    /// - Parameter info: [String:Any] - Notification user info
    /// - Returns: NotificationItemModel
    func getNotificationItem(fromNotificationInfo info: [String:Any]) -> NotificationItemModel? {
        do {
            let infoDict = try JSONSerialization.data(withJSONObject: info, options: [])
            let notificationInfo = try JSONDecoder().decode(NotificationUserInfoModel.self, from: infoDict)
            if let itemStr = notificationInfo.item {
                guard let jsonData = itemStr.data(using: .utf8) else { return nil }
                let item = try JSONDecoder().decode(NotificationItemModel.self, from: jsonData)
                return item
            }
            return nil
        } catch {
            return nil
        }
    }
}

struct NotificationUserInfoModel: Codable {
    let item: String?
    let action: String?
}

struct NotificationItemModel: Codable {
    let redirect: Int?
}
