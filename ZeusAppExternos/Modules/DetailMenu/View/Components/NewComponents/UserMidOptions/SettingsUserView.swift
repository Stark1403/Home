//
//  SettingsUserView.swift
//  ZeusAppExternos
//
//  Created by Karen Irene Arellano Barrientos on 02/07/24.
//

import Foundation
import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo

class SettingsUserView: ItemView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleTextLbl.text = "Configuración"
        
        self.leadingIconImageView.image = UIImage(materialIcon: .settings)?.withTintColor(.dark600 ?? .black, renderingMode: .alwaysTemplate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



