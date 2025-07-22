//
//  HomeViewController+class RTLCollectionViewFlowLayout- UICollectionViewFlowLayout.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 29/08/23.
//

import Foundation
import UIKit

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuCollectionView {
            let yourWidth = (collectionView.bounds.width/3)
            return CGSize(width: yourWidth, height: 128)
        } else {
            return CGSize(width: 240, height: screenFrame.height * 0.14)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == menuCollectionView {
            return 0
        } else {
            return 16
        }
    }
}
