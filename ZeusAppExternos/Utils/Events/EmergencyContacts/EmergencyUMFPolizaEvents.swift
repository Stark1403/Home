//
//  EmergencyUMFPolizaEvents.swift
//  ZeusAppExternos
//
//  Created by Julio Cesar Michel Torres Licona on 13/05/25.
//

import ZeusEventCollector

struct EmergencyUMFPolizaEvents {
    
    static var shared = EmergencyUMFPolizaEvents()
    private let categoryID = "15"
    private let subcategoryID = "85"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: subcategoryID,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: indicator.setMetadata(event: event))
    }
}

extension EmergencyUMFPolizaEvents {
    enum IndicatorEventType {
        case opcionUMF
        case screenEdit
        case closeEdit
        case edit
        case save(edit: String)
        case saveError(idRequest: String)
        
        func get() -> (id: String, action: ZECAction) {
            switch self {
            case .opcionUMF:
                return ("427", .click)
            case .screenEdit:
                return("428", .view)
            case .closeEdit:
                return ("429", .click)
            case .edit:
                return ("430", .click)
            case .save:
                return ("431", .click)
            case .saveError:
                return ("431", .error)
            }
        }
        
        func setMetadata(event: ZECEvent) -> ZECEvent {
            switch self {
            case .save(let edit):
                return event.set(key: "edit", value: edit)
            case .saveError(let idRequest):
                return event.set(key: "idRequest", value: idRequest)
            default:
                return event
            }
        }
    }
}
