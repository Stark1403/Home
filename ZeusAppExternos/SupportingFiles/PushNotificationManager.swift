//
//  PushNotificationManager.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 08/08/23.
//

import Foundation

import FirebaseMessaging

class PushNotificationManager: NSObject, ObservableObject {
    
    static let shared = PushNotificationManager()
    
    override init() {
        super.init()
        Messaging.messaging().delegate = self
    }
    
    func requestAuthorization(completionHandler: @escaping () -> Void) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .denied:
                    guard
                        let url = URL(string: UIApplication.openSettingsURLString),
                        UIApplication.shared.canOpenURL(url)
                    else {
                        return
                    }
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url)
                        completionHandler()
                    }
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
                        guard granted else { return completionHandler() }
                        DispatchQueue.main.async {
                            completionHandler()
                        }
                    }
                case .authorized:
                    DispatchQueue.main.async {
                        completionHandler()
                    }
                case .provisional, .ephemeral:
                    completionHandler()
                @unknown default:
                    completionHandler()
            }
        }
    }
}

extension PushNotificationManager: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        FCMTokenManager.shared.currentToken = fcmToken
    }
}
