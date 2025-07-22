//
//  Services.swift
//  ZeusAppExternos
//
//  Created by Alexander Betanzos Lopez on 03/04/23.
//

import Foundation
import Alamofire
import UIKit
import ZeusSessionInfo
import UPAXNetworking
import ZeusKeyManager


class PermissionManager {
    let networking = ZeusV2NetworkManager.shared.networking
    static let shared = PermissionManager()
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    var networtkIsReachable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func getMenu(zeusId: String, info: @escaping ([CategoryMenuModel]) -> Void) {
        
        guard let zeusId = SessionInfo.shared.session?.zeusId else {
            return
        }
        
        if let permissions = SessionInfo.shared.permissions, permissions.count >= 1 {
            info(self.getMenuFromSession(reload: true))
            itemsInHeader = 0
            NotificationCenter.default.post(name: NSNotification.Name("FinishPermissions"), object: nil)
        }
        
        let pathParams = PermissionPathParams(zeusID: zeusId)
        
        let url = "\(TalentoZeusConfiguration.baseURL.absoluteString)/v2/collaborators/menu/{zeusID}"
        itemsInHeader = 0
        networking.call(url: url, method: .get, pathParams: pathParams) { [weak self] (_ result: Swift.Result<ResponsePermissionsMenu, NetError>) in
            switch result {
            case .success(let response):
                var permissionsArray = [Permission]()
                let response = response
                response.menus.forEach { permissions in
                    permissions.list.forEach { item in
                        var showChilds = item.showChilds >= 1 ? 1: 0
                        if item.childs.count >= 1 {
                            showChilds = 1
                            item.childs.forEach { itemChild in
                                permissionsArray.append(Permission(id: itemChild.idPermission, name: itemChild.name ?? "", orderId: itemChild.order, categoryColor: itemChild.categoryColor ?? "", hasChildren: itemChild.showChilds, zeusId: zeusId, type: permissions.typeMenu, parentId: item.idPermission, badgeCount: 0, description: "", openingCount: 0))
                            }
                        }
                        var badgePriority = item.extractVersionCreate() == self?.appVersion ? 3 : 0
                        permissionsArray.append(Permission(id: item.idPermission, name: item.name ?? "", orderId: item.order, categoryColor: item.categoryColor ?? "", hasChildren: showChilds, zeusId: zeusId, type: permissions.typeMenu, parentId: 0, badgeCount: 0, description: "", openingCount: 0, badgePriority: badgePriority))
                    }
                    
                    // Hamburguer menu
                    if permissions.typeMenu == 4 {
                        PermissionSingleton.shared.setValueForHamburgueMenu(value: permissions.list.isEmpty ? false : true)
                        NotificationCenter.default.post(name: NSNotification.Name("SetHamburguerPermission"), object: nil)
                    }
                    
                    // Entry item
                    if permissions.typeMenu == 5 {
                        permissions.list.contains { p in
                            return p.idPermission == 13
                        } ? PermissionSingleton.shared.setValueForEntry(value: true) : PermissionSingleton.shared.setValueForEntry(value: false)
                        NotificationCenter.default.post(name: NSNotification.Name("SetEntryPermission"), object: nil)
                    }
                    
                    if permissions.typeMenu == 5 {
                        permissions.list.contains { p in
                            return p.idPermission == 12
                        } ? PermissionSingleton.shared.setValueForGafete(value: true) : PermissionSingleton.shared.setValueForGafete(value: false)
                        NotificationCenter.default.post(name: NSNotification.Name("SetGafetePermission"), object: nil)
                    }
                    
                    if permissions.typeMenu == 2 {
                        if permissions.list.contains(where: { p in
                            return p.idPermission == 66
                        }) {
                            PermissionSingleton.shared.setValueForHelp(value: true)
                        } else {
                            PermissionSingleton.shared.setValueForHelp(value: false)
                            NotificationCenter.default.post(name: NSNotification.Name("SetHideHelpPermission"), object: nil)
                        }
                    }
                }
                
                SessionInfoQueries.shared.insertPermission(permissionsArray)
                info(self?.getMenuFromSession() ?? [])
               
                break
            case .failure:
                info(self?.getMenuFromSession(reload: true) ?? [])
                break
            }
            NotificationCenter.default.post(name: NSNotification.Name("FinishPermissions"), object: nil)
        }
    }
    
    func getMenuFromSession(reload: Bool = false) -> [CategoryMenuModel] {
        
        var categoryMenu: [CategoryMenuModel] = [CategoryMenuModel]()
        
        if let permissions = SessionInfo.shared.permissions{
            
            let itemParents = permissions.filter { item in
                return item.parentId == 0
            }
            
            itemParents.forEach { parents in
                
                var permissionsParent: [PermissionMenuModel] = [PermissionMenuModel]()
                
                let itemChilds = permissions.filter { item in
                    return item.parentId == parents.id
                }
                
                var permissionsChild: [PermissionMenuModel] = [PermissionMenuModel]()
                
                itemChilds.forEach { childs in
                    permissionsChild.append(PermissionMenuModel(idPermission: childs.id, name: childs.name, categoryColor: childs.categoryColor, order: childs.orderId, showChilds: childs.hasChildren, childs: [], badgePriority: 0))
                }
                
                let permission = PermissionMenuModel(idPermission: parents.id, name: parents.name, categoryColor: parents.categoryColor, order: parents.orderId, showChilds: parents.hasChildren, childs: permissionsChild, badgePriority: parents.badgePriority)
                
                permissionsParent.append(permission)
                
                if categoryMenu.contains(where: { category in
                    category.typeMenu == parents.type
                }){
                    
                    if let row = categoryMenu.firstIndex(where: {$0.typeMenu == parents.type}) {
                        categoryMenu[row].list.append(contentsOf: permissionsParent)
                    }
                    
                }else{
                    let menu = CategoryMenuModel(typeMenu: parents.type, label: "test", list: permissionsParent)
                    categoryMenu.append(menu)
                }
            }
        }
        
        if reload {
            categoryMenu.forEach { permission in
                // Hamburguer menu
                if permission.typeMenu == 4 {
                    PermissionSingleton.shared.setValueForHamburgueMenu(value: permission.list.isEmpty ? false : true)
                    NotificationCenter.default.post(name: NSNotification.Name("SetHamburguerPermission"), object: nil)
                }
                
                // Entry item
                if permission.typeMenu == 5 {
                    permission.list.contains { p in
                        return p.idPermission == 13
                    } ? PermissionSingleton.shared.setValueForEntry(value: true) : PermissionSingleton.shared.setValueForEntry(value: false)
                    NotificationCenter.default.post(name: NSNotification.Name("SetEntryPermission"), object: nil)
                }
                
                if permission.typeMenu == 5 {
                    permission.list.contains { p in
                        return p.idPermission == 12
                    } ? PermissionSingleton.shared.setValueForGafete(value: true) : PermissionSingleton.shared.setValueForGafete(value: false)
                    NotificationCenter.default.post(name: NSNotification.Name("SetGafetePermission"), object: nil)
                }
                
                if permission.typeMenu == 2 {
                    if permission.list.contains(where: { p in
                        return p.idPermission == 66
                    }) {
                        PermissionSingleton.shared.setValueForHelp(value: true)
                    } else {
                        PermissionSingleton.shared.setValueForHelp(value: false)
                        NotificationCenter.default.post(name: NSNotification.Name("SetHideHelpPermission"), object: nil)
                    }
                }
            }
        }
       
        
        return categoryMenu
    }
    
}
