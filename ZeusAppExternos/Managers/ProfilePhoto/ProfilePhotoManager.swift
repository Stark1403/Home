//
//  UserEndPointts.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 28/11/23.
//

import Foundation
import ZeusSessionInfo

import UPAXNetworking
import ZeusKeyManager

class ProfilePhotoManager {
    
    static let shared = ProfilePhotoManager()
    private let networking = ZeusV2NetworkManager.shared.networking
    
    func uploadPhoto(photo: UIImage, completion: @escaping (Bool) -> Void) {
        
        let data = photo.compress(to: 400)
        guard let imageRezised = UIImage(data: data) else{
            completion(false)
            return
        }
        
        let imageString = data.base64EncodedString()
        
        let key = "Zeus/\(SessionInfo.shared.company?.companyId ?? 0)/foto-perfil/\(SessionInfo.shared.user?.zeusId ?? "")/\(NSDate().timeIntervalSince1970).jpg"
        
        let url = TalentoZeusConfiguration.baseURL.absoluteString + "/files/upload"
        let bucketUrl = TalentoZeusConfiguration.bucketURL.absoluteString
        let body = UserPhotoUrlRequest(bucket: bucketUrl, code: imageString, format: "image/jpg", key: key)
        
        networking.call(url: url, method: .post, body: body) { [weak self] (_ result: Swift.Result<UserPhotoUrl, NetError>) in
            switch result {
            case .success( let response):
                guard let url = response.url else {
                    completion(false)
                    return
                }
                self?.sendPhoto(url: url, photo: imageRezised) { success in
                    if success{
                        completion(true)
                        return
                    }
                    completion(false)
                }
                break
            case .failure( _):
                completion(false)
                break
            }
        }
    }
    
    func sendPhoto(url imageURL: String, photo: UIImage, completion: @escaping (Bool) -> Void) {
        let zeusId = SessionInfo.shared.user?.zeusId ?? ""
        let apiUrl = TalentoZeusConfiguration.baseURL.absoluteString + "/collaborator/profileimage"
        let body = ProfileImageUrlRequest(collaboratorId: zeusId, image: imageURL)
        
        networking.call(url: apiUrl, method: .put, body: body) { (_ result: Swift.Result<UserPhotoUrl, NetError>) in
            switch result {
            case .success(_):
                SessionInfoQueries.shared.updateUser(zeusId: SessionInfo.shared.user?.zeusId ?? "", photo: imageURL, photoLocal: photo)
                completion(true)
                break
            case .failure(_):
                completion(false)
                break
            }
        }
    }
}
