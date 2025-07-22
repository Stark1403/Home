//
//  MyInformationEvents.swift
//  ZeusAppExternos
//
//  Created by Julio Cesar Michel Torres Licona on 26/02/25.
//

import Foundation
import ZeusEventCollector

struct MyInformationEvents {
    
    static var shared = MyInformationEvents()
    private let categoryID = "15"
    private let subcategoryID = "78"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: subcategoryID,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: indicator.setMetadata(event: event))
    }
}

extension MyInformationEvents {
    enum IndicatorEventType {
        case screenView
        case screenError(idRequest: String)
        case back
        case requestInformation(data: String)
        case reasonInformation(idRequest: String)
        case screenAlert
        case goOut
        case keepEditing
        
        
        func get() -> (id: String, action: ZECAction) {
            switch self {
            case .screenView:
                return ("389", .view)
            case .screenError:
                return("389", .error)
            case .back:
                return ("390", .click)
            case .requestInformation:
                return ("391", .click)
            case .reasonInformation:
                return ("391", .error)
            case .screenAlert:
                return ("392", .view)
            case .goOut:
                return ("393", .click)
            case .keepEditing:
                return ("394", .click)
            }
        }
        
        func setMetadata(event: ZECEvent) -> ZECEvent {
            switch self {
            case .screenError(let idRequest):
                return event.set(key: "id_request", value: idRequest)
            case .requestInformation(let data):
                return event.set(key: "data", value: data)
            case .reasonInformation(let idRequest):
                return event.set(key: "id_request", value: idRequest)
            default:
                return event
            }
        }
    }
}
