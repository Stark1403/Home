//
//  HomeEventCollector.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 15/07/24.
//

import Foundation
import ZeusEventCollector

class HomeEventCollector {
    static func send(category: HomeEventCategory,
                     subCategory: HomeEventSubCategory,
                     event: HomeEvent,
                     action: ZECAction,
                     metadata: String? = nil) {
        let event = self.getEvent(category: category, subCategory: subCategory, event: event, action: action, metadata: metadata)
        ZEEventCollector.sendEvent(event: event)
    }
    
    static func getEvent(category: HomeEventCategory, subCategory: HomeEventSubCategory,
                  event: HomeEvent,
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

enum HomeEventCategory {
    case homeEvent
    
    func get() -> (name: String, id: Int) {
        switch self {
        case .homeEvent:
            return ("Home", 6)
        }
    }
}

enum HomeEventSubCategory {
    case mainView
    
    func get() -> (name: String, id: Int) {
        switch self {
        case .mainView:
            return ("Pantalla_principal", 30)
        }
    }
}


enum HomeEvent {
    case openView
    case tapSideMenu
    case tapGafeteButton
    case tapEditFavorites
    case tapFavorite
    case tapBanner
    case tapNavBarHome
    case tapNavBarSuport
    case tapNavBarNotification
    case tapNavBarChat
    case tapModuleHome

    func get() -> (name: String, id: Int) {
        switch self {
        case .openView:
            return ("Vista_pantalla", 117)
        case .tapSideMenu:
            return ("Menu_hamburguesa", 118)
        case .tapGafeteButton:
            return ("Boton_Gafete", 119)
        case .tapEditFavorites:
            return ("Editar_favoritos", 121)
        case .tapFavorite:
            return ("Seccion_favoritos", 122)
        case .tapBanner:
            return ("Ver_banner", 120)
        case .tapNavBarHome:
            return ("Nav_Bar_Home", 123)
        case .tapNavBarSuport:
            return ("Nav_Bar_soporte", 124)
        case .tapNavBarNotification:
            return ("Nav_Bar_notificacion", 125)
        case .tapNavBarChat:
            return ("Nav_Bar_chat", 126)
        case .tapModuleHome:
            return ("ModuleHome", 405)
        }
    }
}
