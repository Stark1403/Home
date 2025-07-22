//
//  MyPrivateDataEvents.swift
//  ZeusAppExternos
//
//  Created by Julio Cesar Michel Torres Licona on 26/02/25.
//

import Foundation
import ZeusEventCollector

struct MyPrivateDataEvents {
    
    static var shared = MyPrivateDataEvents()
    private let categoryID = "15"
    private let subcategoryID = "79"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: subcategoryID,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: indicator.setMetadata(event: event))
    }
}

extension MyPrivateDataEvents {
    enum IndicatorEventType {
        case screenView
        case screenError(idRequest: String)
        case back
        case privateData
        case address
        case updateAddress(data: String)
        case updateAddressError(idRequest: String)
        case screenAlert
        case goOut
        case keepEditing
        case screenAlertError
        case acceptError
        
        func get() -> (id: String, action: ZECAction) {
            switch self {
            case .screenView:
                return ("395", .view)
            case .screenError:
                return("395", .error)
            case .back:
                return ("396", .click)
            case .privateData:
                return ("397", .click)
            case .address:
                return ("398", .click)
            case .updateAddress:
                return ("398", .click)
            case .updateAddressError:
                return ("399", .error)
            case .screenAlert:
                return ("400", .view)
            case .goOut:
                return ("401", .click)
            case .keepEditing:
                return ("402", .click)
            case .screenAlertError:
                return ("403", .view)
            case .acceptError:
                return ("404", .click)
            }
        }
        
        func setMetadata(event: ZECEvent) -> ZECEvent {
            switch self {
            case .screenError(let idRequest):
                return event.set(key: "id_request", value: idRequest)
            case .updateAddress(let data):
                return event.set(key: "data", value: data)
            case .updateAddressError(let idRequest):
                return event.set(key: "id_request", value: idRequest)
            default:
                return event
            }
        }
    }
}
