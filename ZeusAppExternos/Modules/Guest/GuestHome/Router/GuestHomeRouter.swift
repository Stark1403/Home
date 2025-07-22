//
//  GuestHomeRouter.swift
//  ZeusAppExternos
//
//  Created by Rafael on 17/08/23.
//

import UIKit

class GuestHomeRouter {
    weak var viewController: UIViewController?
    
    // MARK: Static methods
    static func createModule() -> UIViewController {
        
        let viewController = GuestHomeViewController()
        let interactor = GuestHomeInteractor()
        let router = GuestHomeRouter()
        let presenter = GuestHomePresenter()
        
        viewController.presenter = presenter
        
        presenter.router = router
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        router.viewController = viewController
        
        return viewController
    }
    
}

extension GuestHomeRouter: PresenterToRouterGuestHomeProtocol  {
    func openAddPhoto(_ image: UIImage?, delegate: BadgeIDViewDelegate?) {
        let vc = BadgeIDRouter.createModule(delegate, image, isGuestMode: true)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        viewController?.present(vc, animated: true)
    }
    
    func openDetailView(withInfo info: GuestModuleInfo) {
        let vc = GuestModuleDetailRouter.createModule(withInfo: info)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
