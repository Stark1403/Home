//
//  HomeViewController+Layout.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 29/11/23.
//

import Foundation
import UIKit
let screenFrame = UIScreen.main.bounds
var assistancePermission = true
var gafetePermission = true
var hasAnnouncements = false
var itemsInHeader = 0
extension HomeViewController{
   
    func setupLayouts(views: HomeViewControllerViews) {
        
        let rectangle = RectangleHeaderHomeView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: screenFrame.height * 0.12))
        waveView = NewHomeWaveView(frame: CGRect(x: (assistancePermission && gafetePermission) ? screenFrame.width * 0.6 : screenFrame.width * 0.8, y: screenFrame.height * 0.12, width: screenFrame.width * 0.5, height: screenFrame.height * 0.12))
        view.addSubview(rectangle)
        view.addSubview(waveView!)
       
        
        views.profileCircleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openProfileBadgeID)))
        
        views.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openProfileBadgeID)))
        
        views.cameraImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openProfileBadgeID)))
        
        views.sideMenuButton.addTarget(self, action: #selector(openHamburguerMenu), for: .touchUpInside)
      
        
        view.addSubview(views.logoBusinessImageView)
        view.addSubview(views.profileView)
        view.addSubview(views.cameraImageView)
        views.cameraImageView.addSubview(views.cameraImage)
        views.profileView.addSubview(views.profileCircleView)
        views.profileCircleView.addSubview(views.profileImageView)
        //views.profileView.addSubview(views.nameUserLabel)
        //views.profileView.addSubview(views.sideMenuButton)
        view.addSubview(menuCollectionView)
        if hasAnnouncements {
            swipeDownContainer.addSubview(announcementsView)
        }
        
        mostUsedAppsView.isAnnouncementsHidden = !hasAnnouncements
        
        if assistancePermission {
            view.addSubview(views.circularAssistanceButton)
        }
        if gafetePermission {
            view.addSubview(circularQRButton)
        }
        view.addSubview(views.nameUserLabel)
        view.addSubview(views.registerEntranceLabel)
        view.addSubview(views.sideMenuButton)
        view.addSubview(views.searchButton)
        view.addSubview(swipeDownContainer)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.tintColor = .black
//        view.addSubview(modulesSectionContainer)
        swipeDownContainer.addSubview(modulesSectionContainer)
        views.profileCircleView.isHidden = true
        views.profileView.isHidden = true
        views.cameraImageView.isHidden = true
        
        NSLayoutConstraint.activate([
            
            swipeDownContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: screenFrame.height * 0.24),
            swipeDownContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            swipeDownContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            swipeDownContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: screenFrame.height * 0.24),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            
            views.logoBusinessImageView.widthAnchor.constraint(equalToConstant: 90),
            views.logoBusinessImageView.heightAnchor.constraint(equalToConstant: 30),
            views.logoBusinessImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenFrame.height * 0.07),
            views.logoBusinessImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            views.profileView.heightAnchor.constraint(equalToConstant: 75
                                                     ),
            views.profileView.centerYAnchor.constraint(equalTo: views.logoBusinessImageView.centerYAnchor, constant: 0),
            views.profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            views.profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            views.profileCircleView.widthAnchor.constraint(equalToConstant: 87),
            views.profileCircleView.heightAnchor.constraint(equalToConstant: 87),
            views.profileCircleView.leadingAnchor.constraint(equalTo: views.profileView.leadingAnchor, constant: 17.5),
            views.profileCircleView.topAnchor.constraint(equalTo: views.profileView.topAnchor, constant: 6.5),
            
            views.profileImageView.heightAnchor.constraint(equalToConstant: 72),
            views.profileImageView.widthAnchor.constraint(equalToConstant: 72),
            views.profileImageView.centerYAnchor.constraint(equalTo: views.profileCircleView.centerYAnchor),
            views.profileImageView.centerXAnchor.constraint(equalTo: views.profileCircleView.centerXAnchor),
            
            views.cameraImageView.centerYAnchor.constraint(equalTo: views.profileCircleView.bottomAnchor),
            views.cameraImageView.centerXAnchor.constraint(equalTo: views.profileCircleView.centerXAnchor),
            views.cameraImageView.widthAnchor.constraint(equalToConstant: 26),
            views.cameraImageView.heightAnchor.constraint(equalToConstant: 26),
            
            views.cameraImage.centerXAnchor.constraint(equalTo: views.cameraImageView.centerXAnchor),
            views.cameraImage.centerYAnchor.constraint(equalTo: views.cameraImageView.centerYAnchor),
            views.cameraImage.widthAnchor.constraint(equalToConstant: 15),
            views.cameraImage.heightAnchor.constraint(equalToConstant: 15),
            
            views.nameUserLabel.heightAnchor.constraint(equalToConstant: 24),
            views.nameUserLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            views.nameUserLabel.topAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: (screenFrame.height * 0.06) - 18),
            
            views.registerEntranceLabel.heightAnchor.constraint(equalToConstant: 24),
            views.registerEntranceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            views.registerEntranceLabel.topAnchor.constraint(equalTo: rectangle.bottomAnchor, constant: (screenFrame.height * 0.06 + 4)),
            
            views.sideMenuButton.widthAnchor.constraint(equalToConstant: 30),
            views.sideMenuButton.heightAnchor.constraint(equalToConstant: 30),
            views.sideMenuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            views.sideMenuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: screenFrame.height * 0.07),
            
            views.searchButton.widthAnchor.constraint(equalToConstant: 30),
            views.searchButton.heightAnchor.constraint(equalToConstant: 30),
            views.searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62),
            views.searchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: screenFrame.height * 0.07),
            
            menuCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenFrame.height * 0.44),
            menuCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            menuCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -11),
            menuCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
    
            modulesSectionContainer.topAnchor.constraint(equalTo: hasAnnouncements ? announcementsView.bottomAnchor : view.topAnchor, constant: hasAnnouncements ? 10.0 : screenFrame.height * 0.25),
            modulesSectionContainer.leadingAnchor.constraint(equalTo: swipeDownContainer.leadingAnchor),
            modulesSectionContainer.trailingAnchor.constraint(equalTo: swipeDownContainer.trailingAnchor),
            modulesSectionContainer.bottomAnchor.constraint(equalTo: swipeDownContainer.bottomAnchor),
            
            myFavoritesView.topAnchor.constraint(equalTo: modulesSectionContainer.topAnchor),
            myFavoritesView.leadingAnchor.constraint(equalTo: modulesSectionContainer.leadingAnchor),
            myFavoritesView.trailingAnchor.constraint(equalTo: modulesSectionContainer.trailingAnchor),
            myFavoritesView.heightAnchor.constraint(equalTo: modulesSectionContainer.heightAnchor, multiplier: 1/3),
            
            mostUsedAppsView.topAnchor.constraint(equalTo: myFavoritesView.bottomAnchor),
            mostUsedAppsView.leadingAnchor.constraint(equalTo: modulesSectionContainer.leadingAnchor),
            mostUsedAppsView.trailingAnchor.constraint(equalTo: modulesSectionContainer.trailingAnchor),
            mostUsedAppsView.bottomAnchor.constraint(equalTo: modulesSectionContainer.bottomAnchor),
            
            
        ])
        
        if gafetePermission {
            NSLayoutConstraint.activate([
                circularQRButton.topAnchor.constraint(equalTo: view.topAnchor, constant: screenFrame.height * 0.15),
                circularQRButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                circularQRButton.heightAnchor.constraint(equalToConstant: screenFrame.height * 0.07),
                circularQRButton.widthAnchor.constraint(equalToConstant: screenFrame.height * 0.07),
            ])
        }
        
        if assistancePermission {
            NSLayoutConstraint.activate([
                views.circularAssistanceButton.topAnchor.constraint(equalTo: view.topAnchor, constant: screenFrame.height * 0.15),
                views.circularAssistanceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: gafetePermission ? -88 : -24),
                views.circularAssistanceButton.heightAnchor.constraint(equalToConstant: screenFrame.height * 0.07),
                views.circularAssistanceButton.widthAnchor.constraint(equalToConstant: screenFrame.height * 0.07),
            ])
        }
        
        
        
        if hasAnnouncements {
            NSLayoutConstraint.activate([
                announcementsView.topAnchor.constraint(equalTo: swipeDownContainer.topAnchor, constant: 4),
                announcementsView.leadingAnchor.constraint(equalTo: swipeDownContainer.leadingAnchor, constant: 16),
                announcementsView.trailingAnchor.constraint(equalTo: swipeDownContainer.trailingAnchor, constant: -16),
                announcementsView.heightAnchor.constraint(equalToConstant: screenFrame.height * 0.15),
            ])
        }
    
    }
    
}
