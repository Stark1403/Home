//
//  GuestHomeProtocols.swift
//  ZeusAppExternos
//
//  Created by Rafael on 17/08/23.
//

import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewGuestHomeProtocol: AnyObject {
    var presenter: ViewToPresenterGuestHomeProtocol? { get set}
    
    func didFetchMenu(data: GuestMenuResponse)
    func hideViewDSLoader()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterGuestHomeProtocol: AnyObject {
    var view: PresenterToViewGuestHomeProtocol? { get set }
    var interactor: PresenterToInteractorGuestHomeProtocol? { get set }
    var router: PresenterToRouterGuestHomeProtocol? { get set }
    
    func fetchMenu()
    func openAddPhoto(_ image: UIImage?, delegate: BadgeIDViewDelegate?)
    func openDetailView(withInfo info: GuestModuleInfo)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorGuestHomeProtocol: AnyObject {
    var presenter: InteractorToPresenterGuestHomeProtocol? { get set }
    
    func fetchMenu()
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterGuestHomeProtocol: AnyObject {
    func didFetchMenu(data: GuestMenuResponse)
    func hideDSLoader()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterGuestHomeProtocol {
    func openAddPhoto(_ image: UIImage?, delegate: BadgeIDViewDelegate?)
    func openDetailView(withInfo info: GuestModuleInfo)
}
