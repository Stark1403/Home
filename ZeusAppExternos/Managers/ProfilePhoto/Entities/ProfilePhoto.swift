//
//  ProfilePhoto.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 28/11/23.
//

import Foundation
import UPAXNetworking

struct UserPhotoUrlRequest: UNCodable {
    let bucket: String
    let code: String
    let format: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case bucket
        case code
        case format
        case key
    }
    
    func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "bucket", requiresEncryption: false),
            .init(property: "code", requiresEncryption: false),
            .init(property: "format", requiresEncryption: false),
            .init(property: "key", requiresEncryption: false)
        ]
    }
}


struct ProfileImageUrlRequest: UNCodable {
    let collaboratorId: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case collaboratorId = "id_collaborator"
        case image = "profile_image"
    }
    
    func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "collaboratorId", serializedName: "id_collaborator", requiresEncryption: true),
            .init(property: "image", serializedName: "profile_image", requiresEncryption: true)
        ]
    }
}

public struct UserPhotoUrl: UNCodable {
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "url", requiresEncryption: false)
        ]
    }
    
}
