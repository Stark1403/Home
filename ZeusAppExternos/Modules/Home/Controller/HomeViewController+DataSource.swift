//
//  HomeViewController+DataSource.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 18/06/23.
//

import Foundation
import UIKit
import ZeusUtils

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuCollectionView {
            return menuFrameworks.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView {
            let data = menuFrameworks[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCollectionViewCell.identifier, for: indexPath) as? HomeViewCollectionViewCell else {
                return UICollectionViewCell()
            }
            var badgeNumber = 0
         
            if let row = notifications.first(where: {$0.idPermission == data.idPermission}) {
                badgeNumber = row.notificationsElements.count
            }
            
            cell.configureCell(data: data, badge: badgeNumber)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunicateCell", for: indexPath) as! CommunicateCell
            
            let backgroundImage = UIImage(named: "communicate")
            cell.configure(with: backgroundImage, title: "Comunicado", description: "Descripción de la celda")
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let permisson = menuFrameworks[indexPath.row]
        openModule(permission: permisson)
        updateNotifications(indexPath: indexPath)
    }
}
