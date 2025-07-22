//
//  MyAccountEvents.swift
//  ZeusAppExternos
//
//  Created by Julio Cesar Michel Torres Licona on 25/02/25.
//

import Foundation
import ZeusEventCollector

struct MyAccountEvents {
    
    static var shared = MyAccountEvents()
    private let categoryID = "7"
    private let subcategoryID = "76"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: subcategoryID,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: event)
    }
}

extension MyAccountEvents {
    enum IndicatorEventType {
        case myAccount
        
        func get() -> (id: String, action: ZECAction) {
            switch self {
            case .myAccount:
                return ("381", .view)
            }
        }
    }
}
