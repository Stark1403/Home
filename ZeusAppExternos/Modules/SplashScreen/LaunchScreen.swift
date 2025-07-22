//
//  LaunchScreen.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 24/08/23.
//

import UIKit
import ZeusSessionInfo
import ZeusUtils
import ZeusCoreDesignSystem
import Lottie
class LaunchScreen: UIViewController {
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.5
        imageView.image = UIImage(named: "splash.background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash.plecaheader")
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var bottomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash.plecafooter")
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var ellipseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    lazy var splasEllipseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash.ellipse")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash.new")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var viewAnimation: LottieAnimationView = {
        var viewAnimation = LottieAnimationView()
        viewAnimation = .init(name: "frame2",bundle:
                                Bundle.init(for: LaunchScreen.self))
        viewAnimation.loopMode = .playOnce
        viewAnimation.animationSpeed = 0.5
        viewAnimation.contentMode = .scaleAspectFit
        viewAnimation.backgroundBehavior = .pauseAndRestore
        viewAnimation.translatesAutoresizingMaskIntoConstraints = false
        viewAnimation.backgroundColor = .clear
        viewAnimation.play()
        return viewAnimation
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addConstraint()
        setupBackground()
        view.backgroundColor = .zeusPrimaryColor
    }
    
    func addViews(){
        view.addSubview(backgroundImageView)
        view.addSubview(topImageView)
        view.addSubview(bottomImageView)
        view.addSubview(ellipseLabel)
        view.addSubview(logoImageView)
        view.addSubview(splasEllipseImageView)
        view.addSubview(viewAnimation)
    }
    
    func addConstraint(){
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundImageView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 0),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            topImageView.heightAnchor.constraint(equalToConstant: 157),
            topImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            bottomImageView.heightAnchor.constraint(equalToConstant: 143),
            bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

            ellipseLabel.heightAnchor.constraint(equalToConstant: 243),
            ellipseLabel.widthAnchor.constraint(equalToConstant: 243),
            ellipseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ellipseLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoImageView.heightAnchor.constraint(equalToConstant: 278),
            logoImageView.widthAnchor.constraint(equalToConstant: 278),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            splasEllipseImageView.heightAnchor.constraint(equalToConstant: 23),
            splasEllipseImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            splasEllipseImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            splasEllipseImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 19),
            
            viewAnimation.topAnchor.constraint(equalTo: view.topAnchor),
            viewAnimation.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewAnimation.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewAnimation.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    //MARK: - Private methods

    private func setupBackground() {
        view.backgroundColor = .zeusPrimaryColor
//        view.setGradientWith(
//            frame: view.frame,
//            startPoint: CGPoint(x: 0.0, y: 0.0),
//            endPoint: CGPoint(x: 1, y: 1),
//            colorArray: [
//                UIColor.ZESplashGradient1.cgColor,
//                UIColor.ZESplashGradient2.cgColor,
//                UIColor.ZESplashGradient3.cgColor
//            ],
//            type: .axial,
//            locations: [-0.2,0.30,0.60])
        
//        ellipseLabel.setGradientWith(
//            frame: CGRect(x: 0, y: 0, width: 243, height: 243),
//            startPoint: CGPoint(x: 0.5, y: 0.5),
//            endPoint: CGPoint(x: 1, y: 1),
//            colorArray: [
//                UIColor.ZESplashGradientElllipse1.cgColor,
//                UIColor.ZESplashGradientElllipse2.cgColor
//            ],
//            type: .radial,
//            locations: [0, 0.5],
//            cornerRadius: ellipseLabel.frame.height/2)
        
    }
}
