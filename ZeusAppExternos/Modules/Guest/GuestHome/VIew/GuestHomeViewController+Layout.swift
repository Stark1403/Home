//
//  GuestHomeViewController+Layout.swift
//  ZeusAppExternos
//
//  Created by Rafael on 17/08/23.
//
import UIKit
import ZeusCoreDesignSystem
//Use this extension to set layout of view and subviews
extension GuestHomeViewController {
    
    func setupLayout(views: GuestHomeViews) {
        view.backgroundColor = .white
        
        let companyLogo = views.imageCompanyLogo
        let topViewContainer = getTopViewContainer(views: views)
        let cv = views.collectionView
        
        view.addSubview(topViewContainer)
        view.addSubview(companyLogo)
        view.addSubview(cv)
        
        NSLayoutConstraint.activate([
            topViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            topViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            topViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            companyLogo.bottomAnchor.constraint(equalTo: topViewContainer.topAnchor, constant: -5),
            companyLogo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26),
            companyLogo.heightAnchor.constraint(equalToConstant: 20),
            companyLogo.widthAnchor.constraint(equalToConstant: 75)
        ])
        
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: topViewContainer.bottomAnchor, constant: 10),
            cv.leftAnchor.constraint(equalTo: view.leftAnchor),
            cv.rightAnchor.constraint(equalTo: view.rightAnchor),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        cv.delegate = self
        cv.dataSource = self
        
        setUserInfo(views: views)
    }
    
    private func getTopViewContainer(views: GuestHomeViews) -> UIView {
        let container = views.topViewContainer
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let image = views.imageProfile
        let label = views.labelProfileName
        let button = views.buttonMenu
        let buttonImageView = views.cameraImageView
        let buttonImage = views.cameraImage
        
        container.addSubview(image)
        container.addSubview(label)
        container.addSubview(button)
        container.addSubview(buttonImageView)
        container.addSubview(buttonImage)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            image.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 26),
            image.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            image.heightAnchor.constraint(equalToConstant: 86),
            image.widthAnchor.constraint(equalToConstant: 86)
        ])
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            button.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -26),
            button.heightAnchor.constraint(equalToConstant: 45),
            button.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            label.rightAnchor.constraint(equalTo: button.leftAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            buttonImageView.centerYAnchor.constraint(equalTo: image.bottomAnchor),
            buttonImageView.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: 26),
            buttonImageView.heightAnchor.constraint(equalToConstant: 26),
            
            buttonImage.centerXAnchor.constraint(equalTo: buttonImageView.centerXAnchor),
            buttonImage.centerYAnchor.constraint(equalTo: buttonImageView.centerYAnchor),
            buttonImage.widthAnchor.constraint(equalToConstant: 15),
            buttonImage.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        button.addTarget(self, action: #selector(openHamburguerMenu(_:)), for: .touchUpInside)
        button.isHidden = true
        return container
    }
    
    func setUserInfo(views: GuestHomeViews) {
        views.imageProfile.addSubview(views.profileBackgroudView)
        views.imageProfile.addSubview(views.labelAcronym)
        
        NSLayoutConstraint.activate([
            views.labelAcronym.centerXAnchor.constraint(equalTo: views.imageProfile.centerXAnchor, constant: 0),
            views.labelAcronym.centerYAnchor.constraint(equalTo: views.imageProfile.centerYAnchor, constant: 0),
            views.profileBackgroudView.centerXAnchor.constraint(equalTo: views.imageProfile.centerXAnchor, constant: 0),
            views.profileBackgroudView.centerYAnchor.constraint(equalTo: views.imageProfile.centerYAnchor, constant: 0),
            views.profileBackgroudView.widthAnchor.constraint(equalToConstant: 72),
            views.profileBackgroudView.heightAnchor.constraint(equalToConstant: 72)
        ])
        views.imageProfile.layer.cornerRadius = 86 / 2
        views.imageProfile.layer.borderWidth = 3
        views.imageProfile.layer.borderColor = UIColor.zeusPrimaryColor?.cgColor
        views.imageProfile.backgroundColor = .clear
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(goToProfilePicture))
        views.imageProfile.addGestureRecognizer(gesture)
        views.imageProfile.isUserInteractionEnabled = true
        views.cameraImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToProfilePicture)))
    }
}
