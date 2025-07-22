//
//  ChangeProfileView.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//


import UIKit

final class ChangeProfileView: DetailMenuCell {
    
    override func configure() {
        titleLabel.text = "Cambiar Perfil"
        iconView.image = UIImage(named: "people")
    }
}
