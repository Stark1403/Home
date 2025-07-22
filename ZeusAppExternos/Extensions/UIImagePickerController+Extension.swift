//
//  UIImagePickerController+Extension.swift
//  ZeusAppExternos
//
//  Created by Rafael on 19/12/23.
//

import Foundation
import PhotosUI
import MobileCoreServices

extension UIImagePickerController {
    static func setup(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .overCurrentContext
        return imagePicker
    }
}
