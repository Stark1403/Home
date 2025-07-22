//
//  BadgeIDPresenter.swift
//  ZeusAppExternos
//
//  Created by Rafael on 19/12/23.
//

import UIKit
import ZeusUtils
import ZeusCoreDesignSystem
class BadgeIDPresenter: ViewToPresenterBadgeIDProtocol {

    // MARK: Properties
    weak var view: PresenterToViewBadgeIDProtocol?
    var interactor: PresenterToInteractorBadgeIDProtocol?
    var router: PresenterToRouterBadgeIDProtocol?
}

extension BadgeIDPresenter: InteractorToPresenterBadgeIDProtocol {
    
    func uploadImage(_ image: UIImage?) {
        guard let image = image else { return }
        interactor?.uploadImage(image)
    }
    
    
    func didUploadImageSuccess(_ image: UIImage?) {
        view?.didUploadImageSuccess(image)
    }
    
    func didUploadImageFailure(_ type: ZDSResultType) {
        view?.didUploadImageFailure(type)
    }
}
