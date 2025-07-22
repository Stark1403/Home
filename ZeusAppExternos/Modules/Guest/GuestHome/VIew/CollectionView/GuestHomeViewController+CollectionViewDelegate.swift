//
//  GuestHomeViewController+CollectionViewDelegate.swift
//  ZeusAppExternos
//
//  Created by Rafael on 18/08/23.
//

import Foundation
import UIKit
import ZeusCoreInterceptor

extension GuestHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuFrameworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuestHomeCollectionViewCell", for: indexPath) as? GuestHomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = menuFrameworks[indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let permisson = menuFrameworks[indexPath.row]
        switch permisson.permissionID {
        case 600:
            let view = ZeusBlogRouter.createModule()
            navigationController?.pushViewController(view, animated: true)
        case 114:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.planningPoker, navigateDelegate: self)
        default:
            let info = GuestModuleInfo(icon: UIImage(named: "guest.home.\(permisson.permissionID ?? 0)"),
                                       name: permisson.name ?? "SN",
                                       description: permisson.description ?? "")
            debugPrint(permisson.name ?? "SN")
            presenter?.openDetailView(withInfo: info)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension GuestHomeViewController: NavigatorDelegate {
    func didFailToEnterFlow(error: NSError) {
        
    }
}
