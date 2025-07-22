//
//  GuestHomeMenuRouter.swift
//  ZeusAppExternos
//
//  Created by Rafael on 22/08/23.
//

import UIKit
import ZeusUtils

class GuestHomeMenuRouter {
    
    // MARK: Static methods
    static func createModule(menuPermissions: [PermissionMenuModel]) -> SubmenuViewController {
        
        let viewController = GuestHomeMenuViewController()
        let interactor = GuestHomeMenuInteractor()
        let router = GuestHomeMenuRouter()
        let presenter = GuestHomeMenuPresenter()
        
        viewController.presenter = presenter
        
        presenter.router = router
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        viewController.menuPermissions = menuPermissions
        
        return viewController
    }
    
}

extension GuestHomeMenuRouter: PresenterToRouterGuestHomeMenuProtocol  {
}
