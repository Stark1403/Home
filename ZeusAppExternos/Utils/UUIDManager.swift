//
//  UUIDManager.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 21/08/23.
//

import Foundation
import ZeusUtils
import ZeusSessionInfo
import UIKit

class UUIDMAnager{
    
    let accountUUID = "UUIDZeus"
    func setUUIDInSessionInfo(){
        getUUID { UUID in
            SessionInfo.shared.UUIDDevice = UUID
        }
    }
    
    func getUUID(finished: @escaping (String) -> Void){
        
        ZUKeychainHelper().getPassword(account: accountUUID, completion: { account, UUID, error in
            if let UUID = UUID{
                finished(UUID)
            }else{
                self.setUUID { UUID in
                    finished(UUID)
                }
            }
        })
    }
    
    func setUUID(finished: @escaping (String) -> Void){
        let id = UIDevice.current.identifierForVendor?.uuidString ?? ""
        ZUKeychainHelper().savePassword(account: accountUUID, password: id) { error in
            finished(id)
        }
    }
    
}
