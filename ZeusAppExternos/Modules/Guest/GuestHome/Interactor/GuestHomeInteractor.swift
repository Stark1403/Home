//
//  GuestHomeInteractor.swift
//  ZeusAppExternos
//
//  Created by Rafael on 17/08/23.
//

import UIKit
import UPAXNetworking
import ZeusKeyManager

class GuestHomeInteractor: PresenterToInteractorGuestHomeProtocol {
    
    // MARK: Properties
    weak var presenter: InteractorToPresenterGuestHomeProtocol?
    let networking = ZeusV2NetworkManager.shared.networking
    
    func fetchMenu() {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let zeusId = "asdf-\(uuid)-Invitados-adfs"
        let pathParams = GuestMenuPathParams(zeusID: zeusId)
        let url = "\(TalentoZeusConfiguration.baseURL.absoluteString)/v2/collaborators/menu/{zeusID}"
        
        networking.call(
            url: url,
            method: .get,
            pathParams: pathParams) { [weak self] (_ result: Swift.Result<GuestMenuResponse, NetError>) in
                switch result {
                case .success(let data):
                    self?.presenter?.didFetchMenu(data: data)
                    break
                case .failure(let error):
                    debugPrint(error)
                    self?.presenter?.hideDSLoader()
                    break
                }
        }
    }
}
