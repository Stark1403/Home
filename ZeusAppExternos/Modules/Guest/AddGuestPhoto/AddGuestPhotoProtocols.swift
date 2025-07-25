//
//  AddGuestPhotoProtocols.swift
//  ZeusAppExternos
//
//  Created Alejandro Rivera on 21/08/23.
//  Copyright © 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by UPAX Zeus
//

import Foundation

//MARK: Presenter -> Router
protocol AddGuestPhotoWireframeProtocol: AnyObject {
    
}

//MARK: View -> Presenter
protocol AddGuestPhotoPresenterProtocol: AnyObject {
    var interactor: AddGuestPhotoInteractorInputProtocol? { get set }
}

//MARK: Interactor -> Presenter
protocol AddGuestPhotoInteractorOutputProtocol: AnyObject {
    
}

//MARK: Presenter -> Interactor
protocol AddGuestPhotoInteractorInputProtocol: AnyObject {
    var presenter: AddGuestPhotoInteractorOutputProtocol?  { get set }
}

//MARK: Presenter -> View
protocol AddGuestPhotoViewProtocol: AnyObject {
    var presenter: AddGuestPhotoPresenterProtocol?  { get set }
}
