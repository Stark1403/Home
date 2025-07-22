//
//  AnnouncementRequest.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 03/09/24.
//
import UPAXNetworking

struct AnnouncementRequestPath: UNCodable {
    let idColaborador: String
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "idColaborador", requiresEncryption: true)
        ]
    }
}

