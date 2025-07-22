//
//  ProfilePhotoViewController+PHPickerViewController.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 28/11/23.
//

import Foundation
import UIKit
import PhotosUI
import MobileCoreServices

extension ProfilePhotoViewController: PHPickerViewControllerDelegate {
    func pickPhoto(limit : Int , delegate : PHPickerViewControllerDelegate) {
        do {
            var config = PHPickerConfiguration()
            config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            config.selectionLimit = limit
            config.filter = .any(of: [.images , .livePhotos])
            config.preferredAssetRepresentationMode = .current
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = delegate
            picker.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(picker, animated: true)
        }
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard results.first != nil else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        picker.dismiss(animated: true) {
            let prov = results.first!.itemProvider
            
            prov.loadObject(ofClass: UIImage.self) { im, err in
                if let image = im as? UIImage {
                    self.setImage(image)
                    DispatchQueue.main.async {
                        self.views.saveButton.type = .normal
                    }
                }
            }
        }
    }
}

extension ProfilePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else { return }

        self.setImage(image)
        DispatchQueue.main.async {
            self.views.saveButton.type = .normal
        }
    }
}

