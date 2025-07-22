//
//  SideMenuCollector.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 15/07/24.
//

import Foundation
import ZeusEventCollector

class SideMenuCollector {
    static func send(category: SideMenuCategory,
                     subCategory: SideMenuSubCategory,
                     event: SideMenuEvent,
                     action: ZECAction,
                     metadata: String? = nil) {
        let event = self.getEvent(category: category, subCategory: subCategory, event: event, action: action, metadata: metadata)
        ZEEventCollector.sendEvent(event: event)
    }
    
    static func getEvent(category: SideMenuCategory, subCategory: SideMenuSubCategory,
                  event: SideMenuEvent,
                  action: ZECAction, metadata: String? = nil) -> ZECEvent {
        var event = ZECEvent(
            eventID: "\(event.get().id)", categoryID: "\(category.get().id)",
            subcategoryID: "\(subCategory.get().id)", action: action
        )
        if let metadata = metadata {
            event = event.set(key: "metadata", value: metadata)
        }
        return event
    }
}

enum SideMenuCategory {
    case sideBar
    case legalSideBar
    
    func get() -> (name: String, id: Int) {
        switch self {
        case .sideBar:
            return ("Side_bar", 7)
        case .legalSideBar:
            return ("Legales_side_bar", 8)
        }
    }
}

enum SideMenuSubCategory {
    case sideBarDetail
    case dataUsageAlert
    case legalDetail
    case tyc
    
    func get() -> (name: String, id: Int) {
        switch self {
        case .sideBarDetail:
            return ("Detalle_side_bar", 31)
        case .dataUsageAlert:
            return ("Alerta_uso_datos", 32)
        case .legalDetail:
            return ("Detalle_legales", 33)
        case .tyc:
            return ("Tyc", 34)
        }
    }
}

enum SideMenuEvent {
    case openView
    case tapMibleData
    case tapLegal
    case tapChangePass
    case tapDeleteAccount
    case tapCloseSession
    
    // MARK: Data Usage Alert
    case tapCancel
    case tapAccept
    
    // MARK: Legales view
    case tapTemsAndCond
    case tapPrivacy
    
    func get() -> (name: String, id: Int) {
        switch self {
        case .openView:
            return ("Vista_pantalla", 128)
        case .tapMibleData:
            return ("Uso_datos", 129)
        case .tapLegal:
            return ("Legales", 130)
        case .tapChangePass:
            return ("cambio_contraseña", 131)
        case .tapDeleteAccount:
            return ("eliminar_cuenta", 132)
        case .tapCloseSession:
            return ("cerrar_sesion", 133)
        case .tapCancel:
            return ("Cancelar", 135)
        case .tapAccept:
            return ("Aceptar", 136)
        case .tapTemsAndCond:
            return ("Tyc", 138)
        case .tapPrivacy:
            return ("aviso_privacidad", 139)
        }
    }
}
