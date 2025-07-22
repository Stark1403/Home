//
//  DetailMenuPresenter.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import UIKit

final class DetailMenuPresenter: DetailMenuPresenterProtocol {

    weak private var view: DetailMenuViewProtocol?
    var interactor: DetailMenuInteractorProtocol?
    private let router: DetailMenuWireframeProtocol

    init(interface: DetailMenuViewProtocol, interactor: DetailMenuInteractorProtocol?, router: DetailMenuWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func getInitialData() {
        interactor?.getInitialData()
    }
    
    func updateUIWithSyncData() {
        interactor?.updateUIWithSyncData()
    }
    
    func updateWith(syncedFiles: Int, totalFiles: Int) {
        view?.updateWith(syncedFiles: syncedFiles, totalFiles: totalFiles)
    }
    
    func setCellularSwitchTo(on: Bool) {
        view?.setCellularSwitchTo(on: on)
    }
    
    func setApp(version: String) {
        view?.setApp(version: version)
    }
}
