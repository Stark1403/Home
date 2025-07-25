//
//  AddGuestPhotoRouter.swift
//  ZeusAppExternos
//
//  Created Alejandro Rivera on 21/08/23.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by UPAX Zeus
//

import UIKit

class AddGuestPhotoRouter: AddGuestPhotoWireframeProtocol {
    weak var viewController: UIViewController?

    static func createModule(_ previousImage: UIImage?, delegate: AddGuestPhotoViewControllerDelegate?) -> UIViewController {
        let view = AddGuestPhotoViewController()
        let interactor = AddGuestPhotoInteractor()
        let router = AddGuestPhotoRouter()
        let presenter = AddGuestPhotoPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        view.previousImage = previousImage
        
        interactor.presenter = presenter
        router.viewController = view
        
        view.delegate = delegate
        view.hidesBottomBarWhenPushed = true
        return view
    }
}
