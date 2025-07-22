//
//  AddMyContactsInteractor.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 30/09/24.
//

import UIKit
import ZeusCoreDesignSystem
import UPAXNetworking
import ZeusSessionInfo
import ZeusKeyManager

class AddMyContactsInteractor: MyContactsInteractorInputProtocol {
    
    weak var presenter: MyContactsInteractorOutputProtocol?
    private let networking = ZeusV2NetworkManager.shared.networking
    
    func sendSaveContactData(contactData: SendMyContactsRequestPath) {
        presenter?.showLoader()
        guard let zeusId = SessionInfo.shared.user?.zeusId else {
            presenter?.hideLoader()
            return }
        let url = TalentoZeusConfiguration.baseURL.absoluteString + "/v2/colaborador/datos/emergencia"
        
        let pathParams = SendMyContactsRequestPath(idColaborador: zeusId, emergencyContact: contactData.emergencyContact)
            
        self.networking.call(url: url,
                             method: .post,
                             body: pathParams) { (_ result: Swift.Result<EmergencyContactResponseData, NetError>) in
            self.presenter?.hideLoader()
            switch result {
            case .success(let response):
                if let first = response.emergencyContact.emergencyContact.first {
                    self.presenter?.didSaveContactData(contact: first)
                }
                break
            case .failure(let error):
                switch error {
                case .invalidResponse(_, let error):
                    AddEmergencyContactEvents.shared.sendEvent(.screenError(idRequest: error?.requestID ?? ""))
                default:
                    break
                }
                self.presenter?.didFailSave()
            }
        }
    }
    
    func sendUpdateContact(contactData: SendMyContactsRequestPath) {
        presenter?.showLoader()
        guard let zeusId = SessionInfo.shared.user?.zeusId else {
            presenter?.hideLoader()
            return }
        let url = TalentoZeusConfiguration.baseURL.absoluteString + "/v2/colaborador/datos/emergencia"
        
        let pathParams = SendMyContactsRequestPath(idColaborador: zeusId, emergencyContact: contactData.emergencyContact)
        
        self.networking.call(url: url,
                             method: .post,
                             body: pathParams) { (_ result: Swift.Result<EmergencyContactResponseData, NetError>) in
            self.presenter?.hideLoader()
            switch result {
            case .success(let response):
                if let first = response.emergencyContact.emergencyContact.first {
                    self.presenter?.didSaveContactData(contact: first)
                }
                break
            case .failure(let error):
                switch error {
                case .invalidResponse(_, let error):
                    EditEmergencyContactEvents.shared.sendEvent(.screenError(idRequest: error?.requestID ?? ""))
                default:
                    break
                }
                self.presenter?.didFailSave()
            }
        }
    }
}
