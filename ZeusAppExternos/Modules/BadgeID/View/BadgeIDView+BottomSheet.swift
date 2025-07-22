//
//  BadgeIDView+BottomSheet.swift
//  ZeusAppExternos
//
//  Created by Rafael on 20/12/23.
//

import Foundation
import ZeusUtils
import UIKit


extension BadgeIDViewController: ZUGenericOptionsBottomSheetDelegate {
    
    @objc func showImageOptionSelector() {
        let viewOptions = ZUGenericOptionsBottomSheet()
        viewOptions.delegate = self
        viewOptions.setupWith(options: ImagePickerSelector.options,
                              bottomSheetTitle: "¿Qué acción te gustaría hacer?")
        
        let bottomSheet = ZUGenericBottomSheet(bottomSheetViewController: viewOptions)
        self.views.bottomSheet = bottomSheet
        present(bottomSheet, animated: false)
    }
    
    func zuGenericOptionSelectedIs(_ option: ZUGenericOptionItem) {
        self.views.bottomSheet?.hideBottomSheet()
        guard let option = option.id as? ImagePickerSelector.OptionID else {
            return
        }
        switch option {
        case .camera:
            ZUAuthorizationClass.askForAccessOrGotoSettingsFor(type: .camera, presenterForFail: self) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { //wait to end bottomsheet dismiss animation
                    let vc = UIImagePickerController.setup(delegate: self)
                    self.present(vc, animated: true, completion: nil)
                }
            }
            break
        case .gallery:
            ZUAuthorizationClass.askForAccessOrGotoSettingsFor(type: .gallery, presenterForFail: self) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { //wait to end bottomsheet dismiss animation
                    self.pickPhoto(limit: 1, delegate: self)
                }
            }
            break
        }
    }
}

