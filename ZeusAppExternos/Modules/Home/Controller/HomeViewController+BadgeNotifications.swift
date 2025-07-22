//
//  HomeViewController+BadgeNotifications.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 02/08/23.
//

import Foundation
import UIKit
import ZeusSessionInfo

extension HomeViewController{
    
    func setObserverNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(pushNotificationHandler(_:)) , name: NSNotification.Name(rawValue: "newPushNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openHamburguerMenu) , name: NSNotification.Name(rawValue: "OpenMenu"), object: nil)
    }
    
    func updateNotifications(indexPath: IndexPath){        
        let idPermission = menuFrameworks[indexPath.row].idPermission
        NotificationsManager.shared.updateNotifications(idPermission: idPermission, element: "")
        getNotifications()
        let indexPath = IndexPath(item: indexPath.row, section: 0)
        menuCollectionView.reloadItems(at: [indexPath])
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func getNotifications(){
        notifications = NotificationsManager.shared.getNotifications()
    }
    
    func reloadNotifications(){
        notifications = NotificationsManager.shared.getNotifications()
        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
    }
}
