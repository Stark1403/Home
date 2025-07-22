//
//  MyProfileEvents.swift
//  ZeusAppExternos
//
//  Created by Julio Cesar Michel Torres Licona on 25/02/25.
//

import Foundation
import ZeusEventCollector

struct MyProfileEvents {
    
    static var shared = MyProfileEvents()
    private let categoryID = "15"
    private let subcategoryID = "77"
    
    func sendEvent(_ indicator: IndicatorEventType) {
        let event = ZECEvent(eventID: indicator.get().id,
                             categoryID: categoryID,
                             subcategoryID: subcategoryID,
                             action: indicator.get().action)
        
        ZEEventCollector.sendEvent(event: event)
    }
}

extension MyProfileEvents {
    enum IndicatorEventType {
        case screenView
        case back
        case profilePhoto
        case myInformation
        case myPrivateData
        case emergencyData
        case digitalFile

        func get() -> (id: String, action: ZECAction) {
            switch self {
            case .screenView:
                return ("382", .view)
            case .back:
                return ("383", .click)
            case .profilePhoto:
                return ("384", .click)
            case .myInformation:
                return ("385", .click)
            case .myPrivateData:
                return ("386", .click)
            case .emergencyData:
                return ("387", .click)
            case .digitalFile:
                return ("388", .click)
            }
        }
    }
}
