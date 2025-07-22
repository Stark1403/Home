//
//  PermissionPathParams.swift
//  ZeusAppExternos
//
//  Created by Karen Irene Arellano Barrientos on 19/03/24.
//

import Foundation
import UPAXNetworking

struct PermissionPathParams: UNCodable {
    let zeusID: String
    
    func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "zeusID", requiresEncryption: true)
        ]
    }
}
