//
//  BadgeIDProtocols.swift
//  ZeusAppExternos
//
//  Created by Rafael on 19/12/23.
//

import UIKit
import ZeusUtils
import ZeusCoreDesignSystem
// MARK: View Output (Presenter -> View)
protocol PresenterToViewBadgeIDProtocol: AnyObject {
    var presenter: ViewToPresenterBadgeIDProtocol? { get set }
    
    func didUploadImageSuccess(_ image: UIImage?)
    func didUploadImageFailure(_ type: ZDSResultType)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterBadgeIDProtocol: AnyObject {
    var view: PresenterToViewBadgeIDProtocol? { get set }
    var interactor: PresenterToInteractorBadgeIDProtocol? { get set }
    var router: PresenterToRouterBadgeIDProtocol? { get set }
    
    func uploadImage(_ image: UIImage?)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorBadgeIDProtocol: AnyObject {
    var presenter: InteractorToPresenterBadgeIDProtocol? { get set }
    
    func uploadImage(_ image: UIImage)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterBadgeIDProtocol: AnyObject {
    func didUploadImageSuccess(_ image: UIImage?)
    func didUploadImageFailure(_ type: ZDSResultType)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterBadgeIDProtocol {

}
