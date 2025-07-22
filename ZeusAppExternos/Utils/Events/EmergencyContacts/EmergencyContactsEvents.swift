//
//  EmergencyContactsEvents.swift
//  ZeusAppExternos
//
//  Created by Rafael - Work on 12/05/25.
//


import ZeusEventCollector

struct EmergencyContactsEvents {
    
    static var shared = EmergencyContactsEvents()
    private let categoryID = "15"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: indicator.get().subcategory,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: indicator.setMetadata(event: event))
    }
}

extension EmergencyContactsEvents {
    enum IndicatorEventType {
        case screenError(idRequest: String)
        case contactOptions
        case addContact
        case optionsModal
        case closeOptionsModal
        case editContact
        case deleteContact
        case deleteModalView
        case deleteModalConfirm
        case deleteModalCancel
        
        func get() -> (id: String, subcategory: String, action: ZECAction) {
            switch self {
            case .screenError:
                return("422", "81", .error)
            case .contactOptions:
                return ("407", "81", .click)
            case .addContact:
                return ("408", "81", .click)
            case .optionsModal:
                return ("409", "81", .view)
            case .closeOptionsModal:
                return ("410", "81", .click)
            case .editContact:
                return ("411", "81", .click)
            case .deleteContact:
                return ("412", "81", .click)
            case .deleteModalView:
                return ("419", "83", .view)
            case .deleteModalConfirm:
                return ("420", "83", .click)
            case .deleteModalCancel:
                return ("421", "83", .click)
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
