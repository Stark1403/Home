//
//  VideoBannerCell.swift
//  zeusAPP
//
//  Created by Eric Sebastian Cruz Guzman on 27/06/24.
//  Copyright © 2024 UPAX. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoBannerCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: VideoBannerCell.self)
    
    private var playerContainerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    private let fullscreenButton: UIButton = {
           let button = UIButton(type: .system)
        let symbolName = "rectangle.and.arrow.up.right.and.arrow.down.left"
            if let symbolImage = UIImage(systemName: symbolName) {
                button.setImage(symbolImage, for: .normal)
            }
//           button.setTitle("Fullscreen", for: .normal)
        button.tintColor = .white
            button.setTitleColor(.white, for: .normal)
           button.addTarget(self, action: #selector(handleFullscreen), for: .touchUpInside)
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
    
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        contentView.layer.cornerRadius = .xSmallB
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewAsVideo(url: String){
        guard let videoURL = URL(string: url) else { return }
        
        player = AVPlayer(url: videoURL)
        playerViewController = AVPlayerViewController()
        
        
        guard let playerViewController = playerViewController else { return }
        
        playerViewController.player = player
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        playerViewController.showsPlaybackControls = true
        
        contentView.addSubview(playerContainerView)
            
            NSLayoutConstraint.activate([
                playerContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                playerContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                playerContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                playerContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        
        playerContainerView.addSubview(playerViewController.view)
        
        NSLayoutConstraint.activate([
               playerViewController.view.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor),
               playerViewController.view.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor),
               playerViewController.view.topAnchor.constraint(equalTo: playerContainerView.topAnchor),
               playerViewController.view.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor)
           ])
        
        contentView.addSubview(fullscreenButton)
            
            NSLayoutConstraint.activate([
                fullscreenButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                fullscreenButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        
        player?.play()
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            player?.pause()
            playerViewController?.view.removeFromSuperview()
            player = nil
            playerViewController = nil
        }
    
    @objc func handlePlayerViewTap() {
        guard let playerViewController = playerViewController else { return }
        
        if playerViewController.modalPresentationStyle == .fullScreen {
            playerViewController.dismiss(animated: true, completion: nil)
        } else {
            playerViewController.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.first?.rootViewController?.present(playerViewController, animated: true, completion: {
                playerViewController.player?.play()
            })
        }
    }
    
    @objc private func handleFullscreen() {
        guard let player = player else { return }
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.present(playerViewController, animated: true, completion: {
            player.play()
        })
    }
    
}
