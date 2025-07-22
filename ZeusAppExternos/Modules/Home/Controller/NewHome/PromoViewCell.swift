//
//  PromoViewCell.swift
//  zeusAPP
//
//  Created by DSI Soporte Tecnico on 10/06/24.
//  Copyright © 2024 UPAX. All rights reserved.
//

import Foundation
import UIKit
import ZeusCoreDesignSystem
import Lottie
import AVFoundation
import AVKit
import Kingfisher

class PromoViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: PromoViewCell.self)

    var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "promoTemp")
        return image
    }()
    
    let bannerContainerView: CustomSquareView = {
        let view = CustomSquareView(frame: CGRect(origin: CGPoint(x: 0, y: 8), size: CGSize(width: 130, height: 30)))
        view.backgroundColor = .red
        return view
    }()
    
    let bannerLabel: UILabel = {
        let label = UILabel()
        label.text = "¡Importante!"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    func setupBannerView() {
        self.addSubview(bannerContainerView)
        bannerContainerView.addSubview(bannerLabel)
        bannerContainerView.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bannerContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            bannerContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            bannerContainerView.widthAnchor.constraint(equalToConstant: 130),
            bannerContainerView.heightAnchor.constraint(equalToConstant: 30),
            
            bannerLabel.centerXAnchor.constraint(equalTo: bannerContainerView.centerXAnchor, constant: -4),
            bannerLabel.centerYAnchor.constraint(equalTo: bannerContainerView.centerYAnchor)
        ])
    }
    
    func addShimmer() {
        bannerContainerView.isHidden = true
    }
    
    func hideShimmer() {
        bannerContainerView.isHidden = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.layer.cornerRadius = .xSmallB
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        addViews()
        setupBannerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        contentView.addSubview(image)
        setupConstraints()
    }
    
    func setImage(url: String){
        image.kf.setImage(with: URL(string: url))
    }
    
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }  
}

extension LottieViewCell {
    func removeBannerActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

class LottieViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: LottieViewCell.self)

    
    
    lazy var LottieBannerView = LottieAnimationView()
    
   
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.layer.cornerRadius = .xSmallB
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        configureViewAsLottie()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    
    func configureViewAsLottie(){
        LottieBannerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(LottieBannerView)
        LottieBannerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            LottieBannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            LottieBannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            LottieBannerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            LottieBannerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: LottieBannerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: LottieBannerView.centerYAnchor)
        ])
        
        layoutIfNeeded()
        activityIndicator.startAnimating()
        setLottieFromUrl()
    }
    
    
    func setLottieFromUrl(){
       
        
        if let lottieURL = URL(string: "https://s3.amazonaws.com/prod.survey.files/indiceFelicidad/banner_felicidad_home.json") {
            URLSession.shared.dataTask(with: lottieURL) { [weak self] (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        let animation = try JSONDecoder().decode(LottieAnimation.self, from: data)
                        self?.removeBannerActivityIndicator()
                        self?.LottieBannerView.animation = animation
                        self?.LottieBannerView.loopMode = .loop
                        self?.LottieBannerView.play()
                    } catch {
                        print("Error al decodificar el archivo Lottie: \(error.localizedDescription)")
                    }
                }
            }.resume()
        }
    }
   
}


import UIKit
import AVKit

class CustomVideoPlayerView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return button
    }()
    
    private let fullscreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fullscreen", for: .normal)
        button.addTarget(self, action: #selector(handleFullscreen), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerLayer()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPlayerLayer() {
        playerLayer = AVPlayerLayer(player: player)
        guard let playerLayer = playerLayer else { return }
        layer.addSublayer(playerLayer)
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspect
    }
    
    private func setupUI() {
        addSubview(playPauseButton)
        addSubview(fullscreenButton)
        
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        fullscreenButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playPauseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            playPauseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            fullscreenButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            fullscreenButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func handlePlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        } else {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
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
    
    func configure(url: String) {
        guard let videoURL = URL(string: url) else { return }
        player = AVPlayer(url: videoURL)
        playerLayer?.player = player
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}
