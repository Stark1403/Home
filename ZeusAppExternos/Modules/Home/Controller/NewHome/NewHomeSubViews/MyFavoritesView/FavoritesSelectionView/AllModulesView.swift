//
//  AllModulesView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 05/07/24.
//

import Foundation
import UIKit
import ZeusSessionInfo

class AllModulesView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate {
   
    var favoritesdelegate: FavoritesCollectionDelegate?
    
    var permissionsViewModel = [PermissionsViewModel]() {
        didSet {
            self.reloadData()
        }
    }
    
    var favoritePermissions: [PermissionsViewModel]?
    
    var selectFavorites: ((_ permissionItem: PermissionsViewModel, _ isRemovingItem: Bool) -> Void)? = nil
    
    private let spacing = 8.0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
             
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.estimatedItemSize = .zero
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(MyFavoritesCell.self, forCellWithReuseIdentifier: MyFavoritesCell.identifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dragDelegate = self
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
        return permissionsViewModel.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFavoritesCell.identifier, for: indexPath) as? MyFavoritesCell else {
            return UICollectionViewCell()
        }
        let data = permissionsViewModel[indexPath.row]
        
        if let _ = favoritePermissions?.first(where: { $0.id == data.id }) {
            cell.isFavorite = true
        } else {
            cell.isFavorite = false
        }
        
        cell.configureCell(data: PermissionMenuModel(idPermission: data.id ?? -1, name: data.name, categoryColor: "", order: 0, showChilds: 0, childs: [], badgePriority: 0), badge: 0, shouldShowFavorite: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20 // 16 points on each side
        let collectionViewSize = collectionView.frame.size.width - padding
        
        let width = collectionViewSize / 3 // Three cells in a row
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = permissionsViewModel[indexPath.row]
        if favoritePermissions?.count ?? 0 >= 3 {
            if let _ = favoritePermissions?.first(where: { $0.id == data.id }) {
                selectFavorites?(permissionsViewModel[indexPath.row], true)
                return
            } else {
                return
            }
        }
        
        if let _ = favoritePermissions?.first(where: { $0.id == data.id }) {
            selectFavorites?(permissionsViewModel[indexPath.row], true)
        } else {
            selectFavorites?(permissionsViewModel[indexPath.row], false)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        if permissionsViewModel.filter({ $0.isFavorite }).count >= 3 || permissionsViewModel[indexPath.row].isFavorite {
            return [UIDragItem]()
        }

        let permission = permissionsViewModel[indexPath.row]
        let itemProvider = NSItemProvider.init(object: PermissionsObject(id: permission.id ?? -1, name: permission.name, isFavorite: permission.isFavorite, position: permission.position))
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = action
        return [dragItem]
    }
}

protocol FavoritesCollectionDelegate: AnyObject {
    func addFavorite(permissionsViewModel: PermissionsViewModel, comeFromDrag: Bool)
}

final class PermissionsObject: NSObject {
    public static let typeIdentifier = "PermissionsViewModel"

    let id: Int
    var name: String
    var isFavorite: Bool
    var position: Int

    internal init(id: Int, name: String, isFavorite: Bool, position: Int) {
        self.id = id
        self.name = name
        self.isFavorite = isFavorite
        self.position = position
    }
}

extension PermissionsObject: NSItemProviderReading {

    static var readableTypeIdentifiersForItemProvider: [String] = [typeIdentifier]

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> PermissionsObject {
        if let components = String(data: data, encoding: .utf8)?.split(separator: ",").map(String.init) {
            return PermissionsObject(id: Int(components[0]) ?? 0, name: components[1], isFavorite: Bool(components[2]) ?? true, position: Int(components[3]) ?? 0)
        }
        return PermissionsObject(id: 0, name: "", isFavorite: false, position: 0)
    }
}

extension PermissionsObject: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] = [typeIdentifier]

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        completionHandler("\(id),\(name),\(isFavorite),\(position)".data(using: .utf8), nil)
        let p = Progress(totalUnitCount: 1)
        p.completedUnitCount = 1
        return p
    }
}

extension Array where Element == PermissionsViewModel {
    func favorites() -> [PermissionsViewModel] {
        
        var favoriotes = [PermissionsViewModel]()

        let db: PermissionsDBProtocol = DBQuerys()
        let favorites = db.getFavorites()
        
        favorites.forEach { permission in
            favoriotes.append(PermissionsViewModel(id: permission.id, name: permission.name, isFavorite: true, position: permission.position))
        }
        return favoriotes
    }
    
    mutating func getModel() -> [PermissionsViewModel] {
        
        let db: PermissionsDBProtocol = DBQuerys()
        let favorites = db.getFavorites()
        
        for index in 0..<self.count {
            self[index].isFavorite = false

            let exist = favorites.contains { favorite in
                favorite.id == self[index].id
            }
            
            if exist {
                self[index].isFavorite = true
            }
        }
        return self
    }
}

protocol PermissionsDBProtocol {
    func inserFavorites(permissionsViewModel: [PermissionsViewModel])
    func getFavorites() -> [PermissionsViewModel]
}

struct PermissionsViewModel {
    let id: Int?
    var name: String
    var isFavorite: Bool
    var position: Int
}


class DBQuerys: PermissionsDBProtocol {
  
    func inserFavorites(permissionsViewModel: [PermissionsViewModel]) {
                
        _ = MyFavoritesDBLocal.shared.permissionsFavorites.delete().exec()
        
        permissionsViewModel.forEach { permission in
            MyFavoritesDBLocal.shared.permissionsFavorites.insert([
                .int(columnName: .id, value: permission.id),
                .text(columnName: .name, value: permission.name),
                .bool(columnName: .favorite, value: permission.isFavorite),
                .int(columnName: .position, value: permission.position),
            ])
        }
    }
    
    func getFavorites() -> [PermissionsViewModel] {
        
        var favoriotes = [PermissionsViewModel]()

        let favoritesDB: [PermissionsFavoriteDB] = MyFavoritesDBLocal.shared.permissionsFavorites.select()
            .get()
        
        favoritesDB.forEach { permission in
            favoriotes.append(PermissionsViewModel(id: permission.id, name: permission.name, isFavorite: permission.favorite, position: permission.position))
        }
        return favoriotes
    }
    
}


struct PermissionsFavoriteDB: Codable {
    let id: Int
    let name: String
    let favorite: Bool
    let position: Int
}
