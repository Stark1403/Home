//
//  AddMyContactsPresenter.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 30/09/24.
//

import Foundation

class AddMyContactsPresenter {
    
    weak var view: MyContactsViewProtocol?
    var interactor: MyContactsInteractorInputProtocol?
    var router: MyContactsWireframeProtocol?

    init(interface: MyContactsViewProtocol, interactor: MyContactsInteractorInputProtocol?, router: MyContactsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
}

extension AddMyContactsPresenter: MyContactsPresenterProtocol {
    func updateContact(contactData: SendMyContactsRequestPath) {
        interactor?.sendUpdateContact(contactData: contactData)
    }
    
    func saveContactData(contactData: SendMyContactsRequestPath){
        interactor?.sendSaveContactData(contactData: contactData)
    }
}

extension AddMyContactsPresenter: MyContactsInteractorOutputProtocol {
    func didSaveContactData(contact: SendMyContactsResponse) {
        view?.didSaveData(contact: contact)
    }
    
    func didFailSave() {
        view?.didFailSave()
    }
    
    func showLoader() {
        view?.showLoader()
    }
    
    func hideLoader() {
        view?.hideLoader()
    }
}
