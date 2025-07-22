//
//  ProfilePhotoViewController+Layouts.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 28/11/23.
//

import Foundation
import UIKit
import ZeusSessionInfo

extension ProfilePhotoViewController{
    func setupLayouts(views: ProfilePhotoViews) {
        
        view.backgroundColor = .white

        views.viewImageContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openChangePhotoModal)))
        views.profileImageView.image = self.previousImage
        views.cameraImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openChangePhotoModal)))
        views.saveButton.addTarget(self, action: #selector(saveChange), for: .touchUpInside)
        
        udnColor = SessionInfo.shared.company?.primaryUIColor
        titleString = "Foto de perfil"
        setupNavBarWith(showBack: true, rightActions: [])
        view.addSubview(views.viewImageContainer)
        views.viewImageContainer.addSubview(views.profileImageView)
        views.profileImageView.addSubview(views.acronymLabel)
        
        view.addSubview(views.cameraImageView)
        views.cameraImageView.addSubview(views.cameraImage)
        
        view.addSubview(views.saveButton)
        
        views.profileImageView.layer.cornerRadius = view.bounds.width / 4
        views.viewImageContainer.layer.cornerRadius = ((view.bounds.width / 2) + 30) / 2
        
        NSLayoutConstraint.activate([
            views.viewImageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            views.viewImageContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            views.viewImageContainer.widthAnchor.constraint(equalToConstant: (view.bounds.width / 2) + 30),
            views.viewImageContainer.heightAnchor.constraint(equalTo: views.viewImageContainer.widthAnchor, multiplier: 1),
            
            views.profileImageView.centerYAnchor.constraint(equalTo: views.viewImageContainer.centerYAnchor),
            views.profileImageView.centerXAnchor.constraint(equalTo: views.viewImageContainer.centerXAnchor),
            views.profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            views.profileImageView.heightAnchor.constraint(equalTo: views.profileImageView.widthAnchor, multiplier: 1),
            
            views.acronymLabel.centerXAnchor.constraint(equalTo: views.profileImageView.centerXAnchor),
            views.acronymLabel.centerYAnchor.constraint(equalTo: views.profileImageView.centerYAnchor),
            
            views.saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            views.saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            views.saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            views.saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            views.cameraImageView.topAnchor.constraint(equalTo: views.viewImageContainer.bottomAnchor, constant: -30),
            views.cameraImageView.centerXAnchor.constraint(equalTo: views.viewImageContainer.centerXAnchor),
            views.cameraImageView.widthAnchor.constraint(equalToConstant: 60),
            views.cameraImageView.heightAnchor.constraint(equalToConstant: 60),
            
            views.cameraImage.centerXAnchor.constraint(equalTo: views.cameraImageView.centerXAnchor),
            views.cameraImage.centerYAnchor.constraint(equalTo: views.cameraImageView.centerYAnchor),
            views.cameraImage.widthAnchor.constraint(equalToConstant: 30),
            views.cameraImage.heightAnchor.constraint(equalToConstant: 26),
        ])
    }
}
