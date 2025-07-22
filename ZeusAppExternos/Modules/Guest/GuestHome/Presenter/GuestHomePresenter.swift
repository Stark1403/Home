//
//  GuestHomePresenter.swift
//  ZeusAppExternos
//
//  Created by Rafael on 17/08/23.
//

import UIKit

class GuestHomePresenter: ViewToPresenterGuestHomeProtocol {

    // MARK: Properties
    weak var view: PresenterToViewGuestHomeProtocol?
    var interactor: PresenterToInteractorGuestHomeProtocol?
    var router: PresenterToRouterGuestHomeProtocol?
    
    func fetchMenu() {
        interactor?.fetchMenu()
    }
    
    func openAddPhoto(_ image: UIImage?, delegate: BadgeIDViewDelegate?) {
        router?.openAddPhoto(image, delegate: delegate)
    }
    
    func openDetailView(withInfo info: GuestModuleInfo) {
        router?.openDetailView(withInfo: info)
    }
}

extension GuestHomePresenter: InteractorToPresenterGuestHomeProtocol {
    func didFetchMenu(data: GuestMenuResponse) {
        view?.didFetchMenu(data: data)
    }
    func hideDSLoader() {
        view?.hideViewDSLoader()
    }
}
