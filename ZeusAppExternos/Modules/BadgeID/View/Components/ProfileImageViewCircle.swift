//
//  ProfileImageViewCircle.swift
//  ZeusAppExternos
//
//  Created by Rafael on 20/12/23.
//

import Foundation
import UIKit
import ZeusUtils
import ZeusSessionInfo
import ZeusCoreDesignSystem
class ProfileImageCircleView: UIView {
  
  lazy var SCREEN_WIDTH:Double = {
    return UIScreen.main.bounds.size.width
  }()
  
  lazy var SCREEN_HEIGHT:Double = {
    return UIScreen.main.bounds.size.height
  }()
  
  let BASE_SCREEN_HEIGHT:CGFloat = 852.0
  
  lazy var SCREEN_MAX_LENGTH:Double = {
    return max(SCREEN_WIDTH, SCREEN_HEIGHT)
  }()
  
  lazy var ASPECT_RATIO_RESPECT_OF_15 = {
    return SCREEN_MAX_LENGTH / BASE_SCREEN_HEIGHT
  }()
    
    //MARK: - COMPONENTS
    lazy var profileCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 138 * ASPECT_RATIO_RESPECT_OF_15
        view.layer.borderColor = SessionInfo.shared.company?.primaryUIColor.cgColor ?? UIColor.zeusPrimaryColor?.cgColor
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    let profileBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = SessionInfo.shared.company?.primaryUIColor.withAlphaComponent(0.2) ?? UIColor.zeusPrimaryColor?.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        return imageView
    }()
    
    private let labelAcronym: UILabel = {
        let label = UILabel()
        label.textColor = SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor
        label.textAlignment = .center
        label.isHidden = false
        if let name = SessionInfo.shared.user?.name,
           let lastName = SessionInfo.shared.user?.lastName {
            label.text = "\(name) \(lastName)".getAcronym()
        } else {
            label.text = "I"
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelEmptyPhoto: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secundaryGray
        label.textAlignment = .center
        label.text = "Ingresa una foto para tu perfil"
        return label
    }()
    
    lazy var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 36*ASPECT_RATIO_RESPECT_OF_15
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 8
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "ZEA_ic_camera")
        imageView.image = image
        imageView.tintColor = SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var borderGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(hexString: "#C7C7C7").cgColor,
            UIColor.white.cgColor
        ]
        gradient.mask = borderGradientShape
        return gradient
    }()
    
    private lazy var borderGradientShape: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.lineWidth = 16
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }()
    
    //MARK: - PROPERTIES
    
    var image:UIImage? {
        didSet {
            setupImage(image)
        }
    }
    
    var isButtonViewHidden: Bool = false {
        didSet {
            setupButtonImageView(isHidden: isButtonViewHidden)
        }
    }
    
    var imageButton: UIImage? {
        didSet {
            setupButtonImage(imageButton)
        }
    }
    
    var borderStyle: BorderStyle = .udnColor {
        didSet {
            setupBorderStyle(borderStyle)
        }
    }
    
    //MARK: - LIFE CYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard borderStyle == .gradient else { return }
        borderGradient.frame =  CGRect(origin: CGPointZero, size: profileCircleView.frame.size)
        borderGradientShape.path = UIBezierPath(roundedRect: profileCircleView.bounds,
                                                cornerRadius: 138*ASPECT_RATIO_RESPECT_OF_15).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImage(_ image: UIImage?) {
        guard let image = image else {
            labelAcronym.isHidden = false
            labelEmptyPhoto.isHidden = false
            profileImageView.isHidden = true
            return
        }
        labelAcronym.isHidden = true
        labelEmptyPhoto.isHidden = true
        profileImageView.isHidden = false
        
        profileImageView.image = image
    }
    
    private func setupButtonImageView(isHidden: Bool) {
        buttonView.isHidden = isHidden
        buttonImageView.isHidden = isHidden
    }
    
    private func setupButtonImage(_ image: UIImage?) {
        buttonImageView.image = image
    }
    
    private func setupBorderStyle(_ style: BorderStyle) {
        borderGradient.removeFromSuperlayer()
        profileCircleView.layer.borderWidth = 0
        switch style {
        case .udnColor:
            profileCircleView.layer.borderWidth = 4
            break
        case .gradient:
            profileCircleView.layer.addSublayer(borderGradient)
            break
        case .none:
            break
        }
    }
}

//MARK: - SETUP VIEW
extension ProfileImageCircleView {
    private func setupView() {
        labelAcronym.font = UIFont(style: .display1())
        labelEmptyPhoto.font = UIFont(style: .bodyTextS())
        
        
        addSubview(profileCircleView)
        insertSubview(profileBackgroundView, aboveSubview: profileCircleView)
        profileBackgroundView.addSubview(profileImageView)
        profileBackgroundView.addSubview(labelAcronym)
        profileBackgroundView.addSubview(labelEmptyPhoto)
        insertSubview(buttonView, aboveSubview: profileBackgroundView)
        buttonView.addSubview(buttonImageView)
        
        let contentSize: CGFloat = 264*ASPECT_RATIO_RESPECT_OF_15
        
        NSLayoutConstraint.activate([
            profileCircleView.widthAnchor.constraint(equalToConstant: 276*ASPECT_RATIO_RESPECT_OF_15),
            profileCircleView.heightAnchor.constraint(equalToConstant: 276*ASPECT_RATIO_RESPECT_OF_15),
            profileCircleView.leftAnchor.constraint(equalTo: leftAnchor),
            profileCircleView.rightAnchor.constraint(equalTo: rightAnchor),
            profileCircleView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            profileBackgroundView.centerYAnchor.constraint(equalTo: profileCircleView.centerYAnchor),
            profileBackgroundView.centerXAnchor.constraint(equalTo: profileCircleView.centerXAnchor),
            profileBackgroundView.heightAnchor.constraint(equalToConstant: contentSize),
            profileBackgroundView.widthAnchor.constraint(equalToConstant: contentSize)
        ])
        profileBackgroundView.layer.cornerRadius = contentSize / 2
        
        NSLayoutConstraint.activate([
            labelAcronym.leftAnchor.constraint(equalTo: profileBackgroundView.leftAnchor, constant: 20),
            labelAcronym.rightAnchor.constraint(equalTo: profileBackgroundView.rightAnchor, constant: -20),
            labelAcronym.centerYAnchor.constraint(equalTo: profileBackgroundView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelEmptyPhoto.leftAnchor.constraint(equalTo: labelAcronym.leftAnchor),
            labelEmptyPhoto.rightAnchor.constraint(equalTo: labelAcronym.rightAnchor),
            labelEmptyPhoto.topAnchor.constraint(equalTo: labelAcronym.bottomAnchor, constant: 5)
        ])
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: contentSize),
            profileImageView.widthAnchor.constraint(equalToConstant: contentSize),
            profileImageView.centerYAnchor.constraint(equalTo: profileBackgroundView.centerYAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: profileBackgroundView.centerXAnchor)
        ])
        profileImageView.layer.cornerRadius = contentSize / 2
        
        NSLayoutConstraint.activate([
            buttonView.centerYAnchor.constraint(equalTo: profileBackgroundView.bottomAnchor),
            buttonView.centerXAnchor.constraint(equalTo: profileBackgroundView.centerXAnchor),
            buttonView.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonView.widthAnchor.constraint(equalToConstant: 72*ASPECT_RATIO_RESPECT_OF_15),
            buttonView.heightAnchor.constraint(equalToConstant: 72*ASPECT_RATIO_RESPECT_OF_15)
        ])
        
        NSLayoutConstraint.activate([
            buttonImageView.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            buttonImageView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: 38*ASPECT_RATIO_RESPECT_OF_15),
            buttonImageView.heightAnchor.constraint(equalToConstant: 32*ASPECT_RATIO_RESPECT_OF_15)
        ])
        
        setupBorderStyle(borderStyle)
    }
}

extension ProfileImageCircleView {
    enum BorderStyle {
        case udnColor
        case gradient
        case none
    }
}
