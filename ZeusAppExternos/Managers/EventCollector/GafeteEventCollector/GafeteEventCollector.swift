//
//  GafeteEeventCollector.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 23/07/24.
//

import Foundation
import ZeusEventCollector

class GafeteEventCollector {
    static func send(category: GafeteEventCategory,
                     subCategory: GafeteEventSubCategory,
                     event: GafeteEvent,
                     action: ZECAction,
                     metadata: String? = nil) {
        let event = self.getEvent(category: category ,subCategory: subCategory, event: event, action: action, metadata: metadata)
        ZEEventCollector.sendEvent(event: event)
    }
    
    static func getEvent(category: GafeteEventCategory, subCategory: GafeteEventSubCategory,
                  event: GafeteEvent,
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

enum GafeteEventCategory {
    case homeEvent
    
    func get() -> (name: String, id: Int) {
        switch self {
        case .homeEvent:
            return ("Home", 6)
        }
    }
}

enum GafeteEventSubCategory {
    case mainView
    
    func get() -> (name: String, id: Int) {
        switch self {
        case .mainView:
            return ("Pantalla_principal", 30)
        }
    }
}

enum GafeteEvent {
    case gafete
    
    func get() -> (name: String, id: Int) {
        switch self {
        case .gafete:
            return ("Gafete", 127)
        }
    }
}

