//
//  ZeusBlogPresenter.swift
//  ZeusAppExternos
//
//  Created Alejandro Rivera on 26/09/23.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by UPAX Zeus
//

import UIKit
import ZeusUtils
import ZeusCoreDesignSystem
class ZeusBlogPresenter {
    weak private var view: ZeusBlogViewProtocol?
    var interactor: ZeusBlogInteractorInputProtocol?
    private let router: ZeusBlogWireframeProtocol

    init(interface: ZeusBlogViewProtocol, interactor: ZeusBlogInteractorInputProtocol?, router: ZeusBlogWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
}

extension ZeusBlogPresenter: ZeusBlogPresenterProtocol {
    
    func getURL() {
        interactor?.getURL()
    }
}

extension ZeusBlogPresenter: ZeusBlogInteractorOutputProtocol {
    
    func setURL(_ url: URL?) {
        view?.setURL(url)
    }
    
    func setError(errorType: ZDSResultType) {
        view?.setErrorScreen(errorType: errorType)
    }
}
