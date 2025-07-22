//
//  AddEmergencyContact.swift
//  ZeusAppExternos
//
//  Created by Rafael - Work on 12/05/25.
//

import ZeusEventCollector

struct AddEmergencyContactEvents {
    
    static var shared = AddEmergencyContactEvents()
    private let categoryID = "15"
    private let subcategoryID = "81"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: subcategoryID,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: indicator.setMetadata(event: event))
    }
}

extension AddEmergencyContactEvents {
    enum IndicatorEventType {
        case screenError(idRequest: String)
        case view
        case back
        case actionButton
        
        func get() -> (id: String, action: ZECAction) {
            switch self {
            case .screenError:
                return("413", .error)
            case .view:
                return("413", .view)
            case .back:
                return("414", .click)
            case .actionButton:
                return("415", .click)
            }
        }
        
        func setMetadata(event: ZECEvent) -> ZECEvent {
            switch self {
            case .screenError(let idRequest):
                return event.set(key: "id_request", value: idRequest)
            default:
                return event
            }
        }
    }
}
