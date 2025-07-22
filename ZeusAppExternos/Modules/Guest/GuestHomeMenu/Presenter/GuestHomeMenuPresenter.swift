//
//  GuestHomeMenuPresenter.swift
//  ZeusAppExternos
//
//  Created by Rafael on 22/08/23.
//

import UIKit

class GuestHomeMenuPresenter: ViewToPresenterGuestHomeMenuProtocol {

    // MARK: Properties
    weak var view: PresenterToViewGuestHomeMenuProtocol?
    var interactor: PresenterToInteractorGuestHomeMenuProtocol?
    var router: PresenterToRouterGuestHomeMenuProtocol?
}

extension GuestHomeMenuPresenter: InteractorToPresenterGuestHomeMenuProtocol {
}
