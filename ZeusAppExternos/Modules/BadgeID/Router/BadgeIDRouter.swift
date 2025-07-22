//
//  BadgeIDRouter.swift
//  ZeusAppExternos
//
//  Created by Rafael on 19/12/23.
//

import UIKit

class BadgeIDRouter {
    
    // MARK: Static methods
    static func createModule(_ delegate: BadgeIDViewDelegate? = nil,
                             _ currentImage: UIImage? = nil,
                             isGuestMode: Bool = false) -> UIViewController {
        
        let viewController = BadgeIDViewController()
        let interactor = BadgeIDInteractor()
        let router = BadgeIDRouter()
        let presenter = BadgeIDPresenter()
        
        viewController.presenter = presenter
        viewController.delegate = delegate
        viewController.isGuestMode = isGuestMode
        viewController.currentImage = currentImage
        
        presenter.router = router
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return viewController
    }
    
}

extension BadgeIDRouter: PresenterToRouterBadgeIDProtocol  {
}
