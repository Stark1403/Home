//
//  GuestModuleDetailView.swift
//  ZeusAppExternos
//
//  Created by Alejandro Rivera on 22/08/23.
//

import UIKit
import ZeusUtils

class GuestModuleDetailView: UIView {
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 135),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        ])
        return imageView
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(style: .bodyTextL())
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    var loginButton: ZUGenericButton = {
        let button = ZUGenericButton(udnSkin: UDNSkin.global, type: .phantom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Iniciar sesión", for: .normal)
        button.titleLabel?.font = UIFont(style: .bodyTextL(variant: .semiBold, isItalic: false))
        return button
    }()
    
    var doneButton: ZUGenericButton = {
        let button = ZUGenericButton(udnSkin: UDNSkin.global, type: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Aceptar", for: .normal)
        button.titleLabel?.font = UIFont(style: .bodyTextL(variant: .semiBold, isItalic: false))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(iconImageView)
        scroll.addSubview(descriptionLabel)
        
        addSubview(scroll)
        addSubview(loginButton)
        addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 10),
            iconImageView.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            descriptionLabel.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            
            loginButton.topAnchor.constraint(equalTo: scroll.bottomAnchor, constant: 47),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            doneButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
