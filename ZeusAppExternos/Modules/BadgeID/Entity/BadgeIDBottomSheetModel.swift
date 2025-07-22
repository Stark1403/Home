//
//  BadgeIDBottomSheetModel.swift
//  ZeusAppExternos
//
//  Created by Rafael on 19/12/23.
//

import Foundation
import UIKit
import ZeusUtils

struct ImagePickerSelector {
    static let options: [ZUGenericOptionItem] = [
        .init(title: "Tomar una foto",
              iconLeft: UIImage(named: "ZEA_ic_camera.outline"),
              iconRigth: nil,
              id: OptionID.camera),
        .init(title: "Elegir de la galería",
              iconLeft: UIImage(named: "ZEA_ic_gallery"),
              iconRigth: nil,
              id: OptionID.gallery)
    ]
    
    enum OptionID: Int {
        case camera = 0
        case gallery = 1
    }
}
