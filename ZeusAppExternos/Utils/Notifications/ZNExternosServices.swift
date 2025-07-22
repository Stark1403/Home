//
//  ZNExternosServices.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Perez on 10/19/23.
//

import Foundation
import Alamofire
import AVFoundation
import ZeusSessionInfo

import ZeusKeyManager

struct ZNExternosServices {
    static func updateNotificationStatus(dataToSend: NotificationUpdateRequest, completion: @escaping (NotificationUpdateResponse?) -> Void) {
        
        let user = SessionInfo.shared.user
        guard let zeusId = user?.zeusId else {
            return
        }
        
        let url = TalentoZeusConfiguration.baseURL.absoluteString + "/notifications/\(dataToSend.idNotification)?collaborator_id=\(zeusId)"
        
        let finalURL = URL(string: url)
        
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.configuration.timeoutIntervalForRequest = 30
       
        sessionManager.request(finalURL!, method: .put, parameters: ["status" : 2], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                if let response = JSON as? NSDictionary {
                    if let data = response["message"] as? String {
                        if let _ = response["error"] as? [String : Any] {
                            completion(nil)
                        } else {
                            DatabaseNotificationManager.shared.createDB()
                            DatabaseNotificationManager.shared.saveNotificationStatus(notification: NewNotification(id: dataToSend.idNotification, title: "", description: "", startDate: "", endDate: "", icon: "", status: 2, module: ModuleNewNotification(id: 0, idItem: "")))
                            completion(NotificationUpdateResponse(message: data))
                        }
                        
                    } else {
                        completion(nil)
                    }
                    
                } else {
                    debugPrint("Error")
                    completion(nil)
                }
                
            case .failure(_):
                debugPrint("Error")
                completion(nil)
            }
        }
    }
}

