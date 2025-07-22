//
//  TabBarViewController+Notifications.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 03/08/23.
//

import Foundation
import ZeusSessionInfo
import UIKit
import ZeusCoreDesignSystem

extension TabBarViewController{
    
    func updateNotifications(idPermission: Int) {
        
        if let tabItems = self.tabBar.items {
            tabItems.forEach { item in
                if item.tag == idPermission{
                    item.badgeValue = nil
                }else if item.tag == idPermission {
                    item.badgeValue = nil
                }
            }
        }
        NotificationsManager.shared.updateNotifications(idPermission: idPermission, element: "")
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func reloadNotifications() {
        notifications = NotificationsManager.shared.getNotifications()
        if let tabItems = self.tabBar.items {
            tabItems.enumerated().forEach { (index, item) in
                if item.tag == notificationPermission {
                    if notifications.count > 0 {
                        item.badgeColor = .error
                        item.badgeValue = "●"
                        item.badgeColor = .clear
                        item.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.error ?? UIColor.red], for: .normal)
                    } else {
                        item.badgeValue = nil
                    }
                }
            }
        }
    }
}
