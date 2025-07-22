//
//  EmergencyViewEvents.swift
//  ZeusAppExternos
//

import ZeusEventCollector

struct EmergencyViewEvents {
    
    static var shared = EmergencyViewEvents()
    private let categoryID = "15"
    private let subcategoryID = "84"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: subcategoryID,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: indicator.setMetadata(event: event))
    }
}

extension EmergencyViewEvents {
    enum IndicatorEventType {
        case screenView
        case screenError(idRequest: String)
        case back
        case tapContacts
        case tapUMF
        
        func get() -> (id: String, action: ZECAction) {
            switch self {
            case .screenView:
                return ("422", .view)
            case .screenError:
                return("422", .error)
            case .back:
                return ("423", .click)
            case .tapContacts:
                return ("424", .click)
            case .tapUMF:
                return ("425", .click)
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
