//
//  AnnouncementResponse.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 03/09/24.
//
import UPAXNetworking

struct CarrouselResponse: UNCodable {
    
    var announcements: [CarrouselModel]?
    
    enum CodingKeys: String, CodingKey {
        case announcements = "comunicados"
    }
    
    public  func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "announcements", serializedName: "comunicados", requiresEncryption: false)
        ]
    }
}
