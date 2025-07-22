//
//  DetailMenuRouter.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import Foundation
import ZeusUtils
import UIKit

final class DetailMenuRouter: DetailMenuWireframeProtocol {
    
    weak var viewController: UIView?
    
    static func createModule(menuPermissions: [PermissionMenuModel], isGuest: Bool = false) -> DetailMenuViewController {
        let view = DetailMenuViewController()
        let interactor = DetailMenuInteractor()
        let router = DetailMenuRouter()
        let presenter = DetailMenuPresenter(interface: view, interactor: interactor, router: router)
        view.setMenu(permissions: menuPermissions)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
