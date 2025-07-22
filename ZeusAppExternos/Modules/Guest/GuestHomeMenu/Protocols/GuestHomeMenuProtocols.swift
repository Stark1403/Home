//
//  GuestHomeMenuProtocols.swift
//  ZeusAppExternos
//
//  Created by Rafael on 22/08/23.
//

import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewGuestHomeMenuProtocol: AnyObject {
    var presenter: ViewToPresenterGuestHomeMenuProtocol? { get set}
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterGuestHomeMenuProtocol: AnyObject {
    var view: PresenterToViewGuestHomeMenuProtocol? { get set }
    var interactor: PresenterToInteractorGuestHomeMenuProtocol? { get set }
    var router: PresenterToRouterGuestHomeMenuProtocol? { get set }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorGuestHomeMenuProtocol: AnyObject {
    var presenter: InteractorToPresenterGuestHomeMenuProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterGuestHomeMenuProtocol: AnyObject {
    
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterGuestHomeMenuProtocol {

}
