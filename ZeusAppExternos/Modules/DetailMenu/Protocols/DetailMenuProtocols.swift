//
//  DetailMenuProtocols.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import Foundation
//import Zeus

//MARK: Wireframe -
protocol DetailMenuWireframeProtocol: AnyObject {
    
}
    
//MARK: Presenter -
protocol DetailMenuPresenterProtocol: AnyObject {
    func updateWith(syncedFiles: Int, totalFiles: Int)
    func getInitialData()
    func setCellularSwitchTo(on: Bool)
    func setApp(version: String)
    func updateUIWithSyncData()
}

//MARK: Interactor -
protocol DetailMenuInteractorProtocol: AnyObject/*, InformationSyncDelegate, ZeusSurveyInformationSyncDelegate*/ {
    var presenter: DetailMenuPresenterProtocol?  { get set }
    func getInitialData()
    func updateUIWithSyncData()
}

//MARK: View -
protocol DetailMenuViewProtocol: AnyObject {
    var presenter: DetailMenuPresenterProtocol?  { get set }
    func updateWith(syncedFiles: Int, totalFiles: Int)
    func dismissMenu()
    func setCellularSwitchTo(on: Bool)
    func setApp(version: String)
}
