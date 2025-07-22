//
//  AddContactProtocols.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 30/09/24.
//

import Foundation
import ZeusUtils
import ZeusCoreDesignSystem

//MARK: Presenter -> Router
protocol MyContactsWireframeProtocol: AnyObject {
}

//MARK: View -> Presenter
protocol MyContactsPresenterProtocol: AnyObject {
    var interactor: MyContactsInteractorInputProtocol? { get set }
    var view: MyContactsViewProtocol? { get set }
//    var router: LoginWireframeProtocol? { get set }
    
    func saveContactData(contactData: SendMyContactsRequestPath)
    func updateContact(contactData: SendMyContactsRequestPath)
}

//MARK: Interactor -> Presenter
protocol MyContactsInteractorOutputProtocol: AnyObject {
    func didSaveContactData(contact: SendMyContactsResponse)
    func didFailSave()
    func showLoader()
    func hideLoader()
}

//MARK: Presenter -> Interactor
protocol MyContactsInteractorInputProtocol: AnyObject {
    var presenter: MyContactsInteractorOutputProtocol?  { get set }
    
    func sendSaveContactData(contactData: SendMyContactsRequestPath)
    func sendUpdateContact(contactData: SendMyContactsRequestPath)
   
}

//MARK: Presenter -> View
protocol MyContactsViewProtocol: AnyObject {
    var presenter: MyContactsPresenterProtocol?  { get set }
    
    func showLoader()
    func hideLoader()
    func didSaveData(contact: SendMyContactsResponse)
    func didFailSave()
    
}


