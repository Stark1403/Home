//
//  GuestHomeMenuViewController+Layout.swift
//  ZeusAppExternos
//
//  Created by Rafael on 22/08/23.
//
import UIKit
import ZeusCoreDesignSystem
//Use this extension to set layout of view and subviews
extension GuestHomeMenuViewController {
    
    func setupLayout(views: GuestHomeMenuViews) {
        updateHeader()
        
        let detailedMenuView = views.detailedMenuView
        let shadowGray = views.shadowGray
        
        detailedMenuView.configureConstraints()
        detailedMenuView.nameLabel.textColor = .zeusPrimaryColor
        detailedMenuView.backgroundColor = .white
        shadowGray.backgroundColor = .gray
        
        
        detailedMenuView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailedMenuView)
        detailedMenuView.addSubview(shadowGray)
        
        NSLayoutConstraint.activate([
            detailedMenuView.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailedMenuView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            detailedMenuView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailedMenuView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            shadowGray.trailingAnchor.constraint(equalTo: detailedMenuView.leadingAnchor, constant: 0),
            shadowGray.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shadowGray.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowGray.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            shadowGray.bottomAnchor.constraint(equalTo: detailedMenuView.bottomAnchor)
        ])
    }
    
    func updateHeader() {
        let fullName = "Invitad@"
        views.detailedMenuView.nameLabel.text = fullName
        views.detailedMenuView.nameLabel.adjustsFontSizeToFitWidth = true
    }
}
