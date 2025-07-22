//
//  SideBarConfigurationEvents.swift
//  ZeusAppExternos
//
//  Created by Rafael on 21/01/25.
//

import Foundation
import ZeusEventCollector

struct SideBarConfigurationEvents {
    
    static var shared = SideBarConfigurationEvents()
    private let categoryID = "7"
    private let subcategoryID = "59"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: subcategoryID,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: indicator.setMetadata(event: event))
    }
}

extension SideBarConfigurationEvents {
    enum IndicatorEventType {
        case screen
        case back
        case biometricsSwitch
        case verifyCollaborator
        
        func get() -> (id: String, action: ZECAction) {
            switch self {
            case .screen: return ("319", .view)
            case .back: return ("320", .click)
            case .biometricsSwitch: return ("321", .click)
            case .verifyCollaborator: return ("322", .click)
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

