//
//  BadgeIDInteractor.swift
//  ZeusAppExternos
//
//  Created by Rafael on 19/12/23.
//

import UIKit
import ZeusUtils
import Alamofire

class BadgeIDInteractor: PresenterToInteractorBadgeIDProtocol {
    
    // MARK: Properties
    weak var presenter: InteractorToPresenterBadgeIDProtocol?
    
    func uploadImage(_ image: UIImage) {
        guard NetworkReachabilityManager()?.isReachable == true else {
            self.presenter?.didUploadImageFailure(.errorInternet)
            return
        }
        ProfilePhotoManager.shared.uploadPhoto(photo: image) { [weak self] success in
            guard success else {
                self?.presenter?.didUploadImageFailure(.errorGeneric)
                return
            }
            self?.presenter?.didUploadImageSuccess(image)
        }
    }
    
}
