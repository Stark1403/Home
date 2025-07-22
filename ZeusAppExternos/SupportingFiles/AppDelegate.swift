//
//  AppDelegate.swift
//  ZeusAppExternos
//
//  Created by Alexander Betanzos Lopez on 07/03/23.
//

import UIKit
import FirebaseCore
import ZeusUtils
import FirebaseDynamicLinks
import ZeusServiceCoordinator
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import Intercom
import ZeusIntercomExterno
import ZeusCoreDesignSystem
import ZeusEventCollector
import ZeusCoreInterceptor
import Amplify
import AmplifyPlugins
import ZeusKeyManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isFinishLaunching = false
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupUPAXNetworking()
        initAmplify()

        FirebaseInstanceManager.shared.configure()
        NetworkConfig.isNewZeusApplication = true
        ZeusCoreInterceptor.Navigator.shared.rulerDelegate = NavigatorRuler.shared
        _ = PushNotificationManager.shared
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        handleNotificationWhenAppIsKilled(launchOptions)
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        UUIDMAnager().setUUIDInSessionInfo()
        let intercomOptions = IntercomManager.getIntercomKey()
        Intercom.setApiKey(intercomOptions.key, forAppId: intercomOptions.appID)
        Intercom.enableLogging()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LaunchScreenViewController()
        window?.makeKeyAndVisible()
        ZEEventCollector.startFlow(from: .externalZeus)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if isFinishLaunching == false {
            window?.rootViewController = LaunchScreenViewController()
            window?.makeKeyAndVisible()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DynamicLinkRouter.redirectFlow(url: url)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard let url = userActivity.webpageURL else { return false }

        let linkHandled: Bool = DynamicLinks.dynamicLinks()
            .handleUniversalLink(url) { (dynamicLink, error) in
            guard let url = dynamicLink?.url else { return }
            DynamicLinkRouter.redirectFlow(url: url)
        }
        return linkHandled
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        IQKeyboardManager.shared.isEnabled = false
        deleteStoredNotificationsData()
        ZeusIntercomSDK.intercomLogout()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
}

final class NavigationSubclass: ZDSNavigationController {
    override var shouldAutorotate: Bool {
        guard let viewController = viewControllers.last else { return true }
        if viewController.isKind(of: TabBarViewController.self), UIDevice.current.orientation != .portrait { return false }
        return true
    }
}
