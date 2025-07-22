//
//  EditEmergencyContactEvents.swift
//  ZeusAppExternos
//
//  Created by Rafael - Work on 12/05/25.
//

import ZeusEventCollector

struct EditEmergencyContactEvents {
    
    static var shared = EditEmergencyContactEvents()
    private let categoryID = "15"
    private let subcategoryID = "82"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: subcategoryID,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: indicator.setMetadata(event: event))
    }
}

extension EditEmergencyContactEvents {
    enum IndicatorEventType {
        case screenError(idRequest: String)
        case view
        case back
        case actionButton
        
        func get() -> (id: String, action: ZECAction) {
            switch self {
            case .screenError:
                return("416", .error)
            case .view:
                return("416", .view)
            case .back:
                return("417", .click)
            case .actionButton:
                return("418", .click)
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
