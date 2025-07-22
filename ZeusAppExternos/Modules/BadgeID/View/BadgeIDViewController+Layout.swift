//
//  BadgeIDViewController+Layout.swift
//  ZeusAppExternos
//
//  Created by Rafael on 19/12/23.
//
import UIKit

//Use this extension to set layout of view and subviews
extension BadgeIDViewController {
    
    func setupView(_ views: BadgeIDViews) {
        view.backgroundColor = .clear
        
        views.blurEffectView.frame = view.bounds
        let viewContainer = views.viewContainer
        let viewImageProfile = views.viewImageProfile
        let businessLogo = views.logoBusinessImageView
        let waveOne = views.waveOneImage
        let waveTwo = views.waveTwoImage
        let waveThree = views.waveThreeImage
        let nameUserLabel = views.nameUserLabel
        let jobPositionLabel = views.jobPositionLabel
        let idLabel = views.idLabel
        let lifeLabel = views.lifeLabel
//        nameUserLabel.font = .dynamicFontStyle(style: .Bold, relativeSize: 24 * ASPECT_RATIO_RESPECT_OF_15)
        nameUserLabel.font = UIFont(style: .headline3())
        
        view.addSubview(views.blurEffectView)
        view.addSubview(viewContainer)
        
        viewContainer.addSubview(businessLogo)
        viewContainer.addSubview(waveOne)
        viewContainer.addSubview(waveTwo)
        viewContainer.addSubview(waveThree)
        viewContainer.addSubview(viewImageProfile)
        viewContainer.addSubview(nameUserLabel)
        viewContainer.addSubview(jobPositionLabel)
        viewContainer.addSubview(idLabel)
        viewContainer.addSubview(lifeLabel)
        
        NSLayoutConstraint.activate([
            viewContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            viewContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            viewContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75)
        ])
        
        NSLayoutConstraint.activate([
            viewImageProfile.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
            viewImageProfile.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 95.0),
            
            businessLogo.heightAnchor.constraint(equalToConstant: 36.84),
            businessLogo.widthAnchor.constraint(equalToConstant: 136.1),
            businessLogo.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 21.49),
            businessLogo.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant:  24.56),
            
            waveOne.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            waveOne.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            waveOne.heightAnchor.constraint(equalToConstant: 174.25),
            waveOne.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 76),
            
            waveTwo.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            waveTwo.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            waveTwo.heightAnchor.constraint(equalToConstant: 137.59),
            waveTwo.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 132.79),
            
            waveThree.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            waveThree.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            waveThree.heightAnchor.constraint(equalToConstant:  85.53),
            waveThree.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 198.5),
            
            nameUserLabel.centerXAnchor.constraint(equalTo: viewImageProfile.centerXAnchor),
            nameUserLabel.topAnchor.constraint(equalTo: viewImageProfile.bottomAnchor, constant: 20 * ASPECT_RATIO_RESPECT_OF_15),
            nameUserLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            nameUserLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            
            jobPositionLabel.centerXAnchor.constraint(equalTo: viewImageProfile.centerXAnchor),
            jobPositionLabel.topAnchor.constraint(equalTo: nameUserLabel.bottomAnchor, constant: 13 * ASPECT_RATIO_RESPECT_OF_15),
            jobPositionLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            jobPositionLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            idLabel.centerXAnchor.constraint(equalTo: viewImageProfile.centerXAnchor),
            idLabel.topAnchor.constraint(equalTo: jobPositionLabel.bottomAnchor, constant: 5 * ASPECT_RATIO_RESPECT_OF_15),
            idLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            idLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            
            lifeLabel.centerXAnchor.constraint(equalTo: viewImageProfile.centerXAnchor),
            lifeLabel.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -20 * ASPECT_RATIO_RESPECT_OF_15),
            lifeLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            lifeLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor)
        ])
        
        
        let tapGestureOnView = UITapGestureRecognizer(target: self, action: #selector(openModalSelectImage))
        tapGestureOnView.delegate = self
        let tapGestureOnButton = UITapGestureRecognizer(target: self, action: #selector(openModalSelectImage))
        viewImageProfile.profileBackgroundView.addGestureRecognizer(tapGestureOnView)
        viewImageProfile.buttonView.addGestureRecognizer(tapGestureOnButton)
        viewImageProfile.image = currentImage
        viewImageProfile.isButtonViewHidden = (currentImage != nil)
        
        jobPositionLabel.isHidden = isGuestMode
        idLabel.isHidden = isGuestMode
        lifeLabel.isHidden = isGuestMode
        if isGuestMode {
            nameUserLabel.text = "Invitado"
        }
    }
    
}

extension BadgeIDViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view = views.viewImageProfile.profileBackgroundView
        let bezierPath = UIBezierPath(roundedRect: view.bounds,
                                      cornerRadius: view.layer.cornerRadius)
        let point = touch.location(in: view)
        return bezierPath.contains(point)
    }
}
