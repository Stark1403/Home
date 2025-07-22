//
//  Entity.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Perez on 10/19/23.
//

import Foundation
import UPAXNetworking

struct NewNotification: Codable {
    let id: String
    let title: String
    let description: String
    var startDate: String
    var endDate: String
    var icon: String
    var status: Int
    var module: ModuleNewNotification
    
    enum CodingKeys: String, CodingKey {
        case id = "id_notification",
             title = "title",
             description = "description",
             startDate = "start_date",
             endDate = "end_date",
             icon = "icon",
             status = "status",
             module = "module"
    }
}

struct ModuleNewNotification: Codable {
    let id: Int
    var idItem: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_module",
             idItem = "id_item"
    }
}

struct NotificationUpdateRequest: Codable {
    let idNotification: String
    let idCollaborator: String
    
    enum CodingKeys: String, CodingKey {
        case idNotification = "notification_id"
        case idCollaborator = "collaborator_id"
    }
}

struct NotificationUpdateResponse: UNCodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
    
    func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "message", requiresEncryption: false)
        ]
    }
}
