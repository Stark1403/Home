//
//  CompanyValidatorNetwork.swift
//  ZeusAppExternos
//
//  Created by Rafael on 16/11/23.
//

import Foundation
import UPAXNetworking
import ZeusKeyManager

class CompanyValidatorNetwork {
    
    private let networking = ZeusV2NetworkManager.shared.networking
    
    func updateCompanyConfiguration(id idUser: String, lastName: String) {
        let url = TalentoZeusConfiguration.baseURL.absoluteString + "/auth/account"
        let params = CompanyConfigurationRequest(id: idUser, lastName: lastName)
        
        networking.call(url: url, method: .get, params: params) { (_ result: Swift.Result<CompanyConfigurationResponse, NetError>) in
            switch result {
            case .success(let response):
                response.saveSessionInfo()
                response.saveSessionInfoUser()
                UserDefaults.standard.setLastUpdateCompanyInfo(timestamp: Date().timeIntervalSince1970)
                break
            case .failure(let error):
                return
            }
        }
    }
}
