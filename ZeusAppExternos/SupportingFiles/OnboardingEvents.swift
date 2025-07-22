//
//  OnboardingEvents.swift
//  ZeusExternosLogin
//
//  Created by Rafael on 16/10/23.
//

import Foundation
import ZeusEventCollector

class OnboardingEvents {
    
    static var shared = OnboardingEvents()
    
    private var iteration = UUID()
    private var module = "T&C"
    
    func sendEvent(_ event: EventType) {
        let metadata = ZECMetadataBuilder()
            .set(iteration: UUID())
            .set(module: OnboardingEvents.shared.module)
            .metadata
        
        ZEEventCollector.sendEvent(event: Event(fromApp: .talentoZeus,
                                                eventId: "\(event.get().id)",
                                                event: "\(event.get().name)",
                                                metadata: metadata))
    }
    
    func change(module: String) {
        self.module = module
    }
}

extension OnboardingEvents {
    enum EventType: Int {
        case inTandC
        case ouputTandC
        case inAP
        case outputAp
        case serviceFailureTandC
        case serviceFailureAP

        func get() -> (name: String, id: Int) {
            switch self {
            case .inTandC:
                return ("Ingreso_T&C", 75)
            case .ouputTandC:
                return ("Salida_T&C", 76)
            case .inAP:
                return ("Ingreso_AP", 77)
            case .outputAp:
                return ("Salida_Ap", 78)
            case .serviceFailureTandC:
                return ("Falla_servicios_T&C", 79)
            case .serviceFailureAP:
                return ("Falla_servicios_AP", 80)
            }
        }
    }
}
