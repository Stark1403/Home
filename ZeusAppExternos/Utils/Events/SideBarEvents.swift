//
//  SideBarEvents.swift
//  ZeusAppExternos
//
//  Created by Rafael on 21/01/25.
//

import Foundation
import ZeusEventCollector

struct SideBarEvents {
    
    static var shared = SideBarEvents()
    private let categoryID = "7"
    private let subcategoryID = "31"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: subcategoryID,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: indicator.setMetadata(event: event))
    }
}

extension SideBarEvents {
    enum IndicatorEventType {
        case configurationClick
        
        func get() -> (id: String, action: ZECAction) {
            switch self {
            case .configurationClick: return ("318", .view)
            }
        }
        
        func setMetadata(event: ZECEvent) -> ZECEvent {
            switch self {
            default:
                return event
            }
        }
    }
}
