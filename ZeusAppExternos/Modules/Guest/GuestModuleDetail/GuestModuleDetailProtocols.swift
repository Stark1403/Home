//
//  GuestModuleDetailProtocols.swift
//  ZeusAppExternos
//
//  Created Alejandro Rivera on 22/08/23.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by UPAX Zeus
//

import Foundation

//MARK: Presenter -> Router
protocol GuestModuleDetailWireframeProtocol: AnyObject {
    
}

//MARK: View -> Presenter
protocol GuestModuleDetailPresenterProtocol: AnyObject {
    var interactor: GuestModuleDetailInteractorInputProtocol? { get set }
}

//MARK: Interactor -> Presenter
protocol GuestModuleDetailInteractorOutputProtocol: AnyObject {
    
}

//MARK: Presenter -> Interactor
protocol GuestModuleDetailInteractorInputProtocol: AnyObject {
    var presenter: GuestModuleDetailInteractorOutputProtocol?  { get set }
}

//MARK: Presenter -> View
protocol GuestModuleDetailViewProtocol: AnyObject {
    var presenter: GuestModuleDetailPresenterProtocol?  { get set }
}
