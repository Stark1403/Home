//
//  SignOutView.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import UIKit

final class SignOutView: DetailMenuCell {
    
    override func configure() {
        titleLabel.text = "Cerrar sesión"
        iconView.image = UIImage(named: "signout")
    }
}

