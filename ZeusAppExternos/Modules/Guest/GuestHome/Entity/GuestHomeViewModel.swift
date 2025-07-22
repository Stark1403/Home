//
//  GuestHomeViewModel.swift
//  ZeusAppExternos
//
//  Created by Rafael on 17/08/23.
//

import UIKit
import UPAXNetworking

struct GuestMenuPathParams: UNCodable {
    let zeusID: String
    
    func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "zeusID", requiresEncryption: true)
        ]
    }
}


// MARK: - DataClass
struct GuestMenuResponse: UNCodable {
    let menus: [GuestMenu]?
}

// MARK: - Menu
struct GuestMenu: UNCodable {
    let label: String?
    let list: [GuestMenuList]?
    let typeMenu: Int?

    enum CodingKeys: String, CodingKey {
        case label, list
        case typeMenu = "type_menu"
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "typeMenu", serializedName: "type_menu")
        ]
    }
}

// MARK: - List
struct GuestMenuList: UNCodable {
    let name: String?
    let order: Int?
    let childs: [GuestMenuList]?
    let permissionID, showChilds: Int?
    let categoryColor: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case name, order, childs
        case permissionID = "permission_id"
        case showChilds = "show_childs"
        case categoryColor = "category_color"
        case description
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "permissionID", serializedName: "permission_id"),
            .init(property: "categoryColor", serializedName: "category_color"),
            .init(property: "showChilds", serializedName: "show_childs")
        ]
    }
    
    func getPermissionModel() -> PermissionMenuModel {
        var childsModel: [PermissionMenuModel] = []
        if let childs = childs {
            childs.forEach({childsModel.append($0.getPermissionModel())})
        }
        let model = PermissionMenuModel(idPermission: self.permissionID ?? 0,
                                        name: self.name,
                                        categoryColor: self.categoryColor,
                                        order: self.order ?? 1,
                                        showChilds: self.showChilds ?? 0,
                                        childs: childsModel, badgePriority: 0)
        return model
    }
    
}


struct GuestHomeViewModel {

}

