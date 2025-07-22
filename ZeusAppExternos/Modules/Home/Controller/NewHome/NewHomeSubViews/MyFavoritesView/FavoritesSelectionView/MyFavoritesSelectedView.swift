//
//  MyFavoritesSelectedView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 05/07/24.
//

import Foundation
import UIKit
class MyFavoritesSelectedView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate {
    
    var myFavoritesDelegate: MyFavoritesSelectedViewDelegate?
    
    var permissionsViewModel = [PermissionsViewModel]() {
        didSet {
            self.reloadData()
        }
    }
    
    var selectFavorites: ((_ permissionItem: PermissionsViewModel, _ isRemovingItem: Bool) -> Void)? = nil
    
    private let spacing = 0.0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
             
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(MyFavoritesCell.self, forCellWithReuseIdentifier: MyFavoritesCell.identifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isScrollEnabled = false
        self.dropDelegate = self
        self.dataSource = self
        self.delegate = self
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFavoritesCell.identifier, for: indexPath) as? MyFavoritesCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.row < permissionsViewModel.count {
            let data = permissionsViewModel[indexPath.row]
            cell.configureCell(data: PermissionMenuModel(idPermission: data.id ?? -1, name: data.name, categoryColor: "", order: 0, showChilds: 0, childs: [], badgePriority: 0), badge: 0, shouldChangeBackground: true)
        } else {
            cell.configureCell(data: PermissionMenuModel(idPermission: -1, name: "", categoryColor: "", order: 0, showChilds: 0, childs: [], badgePriority: 0), badge: 0, shouldShowPlus: false, shouldChangeBackground: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewHeight = collectionView.frame.height
        let padding: CGFloat = 40 // 16 points on each side
        let collectionViewSize = collectionView.frame.size.width - padding
        
        let width = collectionViewSize / 3 // Three cells in a row
        let height: CGFloat = (collectionView.frame.height - 20) / 3 //
//        if viewHeight <= 276, isAnnouncementsHidden {
//            return CGSize(width: width, height: height)
//        }
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < permissionsViewModel.count {
            let permission = permissionsViewModel[indexPath.row]
            selectFavorites?(permission, true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
                
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }

        coordinator.session.loadObjects(ofClass: PermissionsObject.self) { items in
            guard let item = items as? [PermissionsObject] else { return }
            if let permission = item.first {

                if self.permissionsViewModel.contains(where: { $0.position == destinationIndexPath.row }) {
                    return
                }
                
                
                //MARK: CHANGE DELEGATE TO CALLBACK
                self.myFavoritesDelegate?.addFavorite(
                    permissionsViewModel:
                        PermissionsViewModel(id: permission.id, name: permission.name, isFavorite: permission.isFavorite, position: destinationIndexPath.row),
                    comeFromDrag: true)
                
                self.selectFavorites?(PermissionsViewModel(id: permission.id, name: permission.name, isFavorite: permission.isFavorite, position: destinationIndexPath.row), true)
            }
        }
        
        if coordinator.proposal.operation == .copy {

        }
    }
}

protocol MyFavoritesSelectedViewDelegate: AnyObject {
    func removeFavorite(permissionsViewModel: PermissionsViewModel)
    func addFavorite(permissionsViewModel: PermissionsViewModel, comeFromDrag: Bool)
}
