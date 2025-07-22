//
//  SessionManager.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 29/08/23.
//

import Foundation
import ZeusSessionInfo
import UIKit
import ZeusIntercomExterno
import ZeusAttendanceControl
import ZeusUtils
import ZeusNewSurveys
import TalentoZeusMyTalent

class SessionManager {
    
    static var shared: SessionManager = SessionManager()
    
    func addListener() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LogOut"), object: nil, queue: nil) { [weak shared = SessionManager.shared] _ in
            shared?.logOut()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func logOut() {
        RegisterActions.removeModulesData()
        SingleSessionValidator.shared.logOutSessionActive()
        SessionInfo.shared.logOut()
        ZeusIntercomSDK.intercomLogout()
        AttendancesNotificationsManager.shared.removePendingNotifications(withNotificationTypes: [
            .checkIn(""),
            .checkOut(""),
            .noCheckOut,
            .lunchtimeCheckIn,
            .lunchtimeCheckOut,
            .lunchtimeNoCheckOut
        ])
        LocalFileManager.shared.deleteFile(subDirectory: .profilePhoto, fileName: .profilePhoto)
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = LaunchScreenViewController()
        (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
    }
    
    static func logout(isRemoteLogOut: Bool = false){
        UserDefaultsManager.setIsFirstUserLoad(for: SessionInfo.shared.user?.zeusId ?? "", value: false)
        SurveysMultimediaSendingManager.shared.wipeSyncData()
        TalentoZeusMyTalent.cleanUser()
        if let sideMenuBackView = UIApplication.shared.sideMenuBackView{
            UIView.animate(withDuration: 0.40) {
                sideMenuBackView.alpha = 0
            } completion: { _ in
                sideMenuBackView.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.30, animations: {
        }) { _ in
            if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
                slideView.removeFromSuperview()
            }
        }
        
        if !isRemoteLogOut{
            SingleSessionValidator.shared.removeTokenInZeusUsers()
        }
        RegisterActions.removeModulesData()
        SingleSessionValidator.shared.logOutSessionActive()
        SessionInfo.shared.logOut()
        ZeusIntercomSDK.intercomLogout()
        UDNSkin.global.color = UIColor(named: "udn-zeus-color") ?? .clear
        UDNSkin.global.secondaryColor = UIColor(named: "udn-zeus-color") ?? .clear
        AttendancesNotificationsManager.shared.removePendingNotifications(withNotificationTypes: [
            .checkIn(""),
            .checkOut(""),
            .noCheckOut,
            .lunchtimeCheckIn,
            .lunchtimeCheckOut,
            .lunchtimeNoCheckOut
        ])
        LocalFileManager.shared.deleteFile(subDirectory: .profilePhoto, fileName: .profilePhoto)
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = LaunchScreenViewController()
        (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
    }
    
    func dismissThisMenu(animated: Bool) {
        if animated {
            
            if let sideMenuBackView = UIApplication.shared.sideMenuBackView{
                UIView.animate(withDuration: 0.40) {
                    sideMenuBackView.alpha = 0
                } completion: { _ in
                    sideMenuBackView.removeFromSuperview()
                }
            }
            
            UIView.animate(withDuration: 0.30, animations: { [weak self] in
                self?.performDismissActivities()
            }) { [weak self] _ in
                if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
                    slideView.removeFromSuperview()
                }
            }
        } else {
            performDismissActivities()
            if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
                slideView.removeFromSuperview()
                slideView.shadowGray.alpha = 0
            }
            if let sideMenuBackView = UIApplication.shared.sideMenuBackView{
                sideMenuBackView.alpha = 0
                sideMenuBackView.removeFromSuperview()
            }
        }
    }
        
    private func performDismissActivities() {
//        let width = UIScreen.main.bounds.width
//        let translation = direction == .right ? width : -width + margin
//        self.transform = CGAffineTransform(translationX: translation, y: 0.0)
    }
    
    static func openDashboard(){
        let initialNavigationController: UINavigationController? = NavigationSubclass()
        let tabBarViewController = TabBarViewController()
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = initialNavigationController
        (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
        initialNavigationController?.isNavigationBarHidden = true
        initialNavigationController?.pushViewController(tabBarViewController, animated: true)
    }
    
    static func openGuestDashboard(){
        let initialNavigationController: UINavigationController? = NavigationSubclass()
        let tabBarViewController = GuestHomeTabBar()
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = initialNavigationController
        (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
        initialNavigationController?.isNavigationBarHidden = true
        initialNavigationController?.pushViewController(tabBarViewController, animated: true)
    }
}
