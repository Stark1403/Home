//
//  BadgeIDView+ImagePicker.swift
//  ZeusAppExternos
//
//  Created by Rafael on 19/12/23.
//

import Foundation
import UIKit
import PhotosUI
import MobileCoreServices

extension BadgeIDViewController: PHPickerViewControllerDelegate {
    func pickPhoto(limit : Int , delegate : PHPickerViewControllerDelegate) {
        do {
            var config = PHPickerConfiguration()
            config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            config.selectionLimit = limit
            config.filter = .any(of: [.images])
            config.preferredAssetRepresentationMode = .current
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = delegate
            picker.modalPresentationStyle = .overCurrentContext
            self.present(picker, animated: true)
        }
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard results.first != nil else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        picker.dismiss(animated: true) {
            guard let prov = results.first?.itemProvider else { return }
            
            prov.loadObject(ofClass: UIImage.self) { im, err in
                if let image = im as? UIImage {
                    self.setImage(image)
                }
            }
        }
    }
}

extension BadgeIDViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else { return }

        self.setImage(image)
    }
}

