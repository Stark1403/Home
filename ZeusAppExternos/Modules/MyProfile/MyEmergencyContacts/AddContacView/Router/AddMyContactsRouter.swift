//
//  AddMyContactsRouter.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 30/09/24.
//

import UIKit


class AddMyContactsRouter: MyContactsWireframeProtocol {
    
    weak var viewController: AddMyContacsViewController?

    static func createModule() -> AddMyContacsViewController {
//        let view = LoginViewController(nibName: "LoginViewController", bundle: Bundle.init(for: LoginViewController.self))
        let view = AddMyContacsViewController()
        let interactor = AddMyContactsInteractor()
        let router = AddMyContactsRouter()
        let presenter = AddMyContactsPresenter(interface: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}

