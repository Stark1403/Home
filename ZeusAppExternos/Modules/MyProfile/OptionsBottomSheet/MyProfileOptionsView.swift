//
//  MyProfileOptionsView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 19/09/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
import ZeusUtils
enum MyProfileOptions {
    case takePhoto
    case takeGallery
    case deletePhoto
}

class MyProfileOptionsView: UIViewController {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = .black
        view.alpha = 0.0
        view.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(activateDismissAnimation))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var decorativeNotchIv: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "decorativeNotch")
        return iv
    }()
    
    lazy var takePhotoView: LabelWithImageProfile = {
        let view = LabelWithImageProfile()
        view.setupTitle(with: UIImage(materialIcon: .photoCamera, fill: false), title: "Tomar una foto", tint: .black900, isArrowHidden: true)
        view.isUserInteractionEnabled =  true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTakePhotoTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var takeGalleryView: LabelWithImageProfile = {
        let view = LabelWithImageProfile()
        view.setupTitle(with: UIImage(named: "personGalleryIc"), title: "Elegir de galeria", tint: .black900, isArrowHidden: true)
        view.isUserInteractionEnabled =  true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTakeGalleryTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var deletePhotoView: LabelWithImageProfile = {
        let view = LabelWithImageProfile()
        view.setupTitle(with: UIImage(materialIcon: .delete, fill: false), title: "Eliminar foto", tint: .black900, isArrowHidden: true)
        view.isUserInteractionEnabled =  true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onDeletePhotoTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var optionsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        if SessionInfo.shared.user?.photo == "" {
            [takePhotoView, takeGalleryView].forEach {sv.addArrangedSubview($0)}
        } else {
            [takePhotoView, takeGalleryView, deletePhotoView].forEach {sv.addArrangedSubview($0)}
        }
        return sv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.font = UIFont(style: .bodyTextXL(variant: .bold, isItalic: false))
        lbl.text = "¿Qué te gustaría hacer?"
        lbl.textColor = UIColor(hexString: "#393647")
        return lbl
    }()
    
    lazy var closeViewButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(materialIcon: .close), for: .normal)
        btn.tintColor = .black900
        btn.addTarget(self, action: #selector(activateDismissAnimation), for: .touchUpInside)
        return btn
    }()
        
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    private var myWindow: UIWindow?
    
    var goToOptionSelected: ((_ optionSelected: MyProfileOptions) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.containerView.frame.origin
        }
    }
    
    func openModule(){
        myWindow = UIWindow(frame: UIScreen.main.bounds)
        myWindow?.windowLevel = UIWindow.Level.alert
        myWindow?.backgroundColor = UIColor.clear
        myWindow?.rootViewController = self
        myWindow?.isHidden = false
        
        shadowView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.shadowView.alpha = 0.4
        }
        containerView.transform = CGAffineTransform(translationX: 0.0, y: UIScreen.main.bounds.height)
        
        var height: CGFloat = 0.0
        
        if SessionInfo.shared.user?.photo == "" {
            height = UIScreen.main.bounds.height - 172
        } else {
            height = UIScreen.main.bounds.height - 212
        }
        UIView.animate(withDuration: 0.40) {
            self.containerView.transform = CGAffineTransform(translationX: 0.0, y: height)
        }
    }
   
    private func setupConstraints(){
        containerView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        containerView.addGestureRecognizer(panGesture)
        
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(shadowView)
        view.addSubview(containerView)
        containerView.addSubview(decorativeNotchIv)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeViewButton)
        
        containerView.addSubview(optionsStackView)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: view.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - 50),
            
            decorativeNotchIv.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            decorativeNotchIv.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            decorativeNotchIv.heightAnchor.constraint(equalToConstant: 4),
            decorativeNotchIv.widthAnchor.constraint(equalToConstant: 64),
            
            closeViewButton.topAnchor.constraint(equalTo: decorativeNotchIv.bottomAnchor, constant: 16),
            closeViewButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeViewButton.heightAnchor.constraint(equalToConstant: 24),
            closeViewButton.widthAnchor.constraint(equalToConstant: 24),
                
            titleLabel.topAnchor.constraint(equalTo: decorativeNotchIv.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: closeViewButton.leadingAnchor, constant: -10),
            
            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            optionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            optionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            
        ])
    }
    
    @objc private func onTakePhotoTapped(){
        activateDismissAnimation()
        goToOptionSelected?(.takePhoto)
    }
    
    @objc private func onTakeGalleryTapped(){
        activateDismissAnimation()
        goToOptionSelected?(.takeGallery)
    }
    
    @objc private func onDeletePhotoTapped(){
        activateDismissAnimation()
        goToOptionSelected?(.deletePhoto)
    }
    
    @objc private func activateDismissAnimation(){
        UIView.animate(withDuration: 0.4) {
            self.shadowView.alpha = 0.0
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            },
            completion: { _ in
                self.myWindow = nil
            }
        )
    }
    
    @objc private func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
        
        containerView.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                activateDismissAnimation()
            } else {
//                let heightToDismiss = containerView.frame.height - (containerView.frame.height / 2)
                let heightToDismiss = UIScreen.main.bounds.height - 312
                guard translation.y <= heightToDismiss else {
                    activateDismissAnimation()
                    return
                }
                UIView.animate(withDuration: 0.3) {
                    self.containerView.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    
   
}


import Kingfisher

class ZUAvatarImageView: UIView {
    var acronymLabelFontSize: CGFloat?
   
    lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var avatarPlaceHolder: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var acronymLabel: UILabel = {
        let label = UILabel()
        label.textColor = SessionInfo.shared.company?.primaryUIColor
        label.isHidden = true
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    required init() {
        super.init(frame: .zero)
        configureWith()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        acronymLabelFontSize = (self.frame.width / 2) - 10
        acronymLabel.font = .dynamicFontStyle(style: .Bold, relativeSize: acronymLabelFontSize ?? 150)
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureWith() {
        backgroundColor = SessionInfo.shared.company?.primaryUIColor.extraLightColor
        
        addSubview(acronymLabel)
        addSubview(avatarImage)
        addSubview(avatarPlaceHolder)
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: topAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            avatarImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        avatarPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarPlaceHolder.topAnchor.constraint(equalTo: topAnchor),
            avatarPlaceHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarPlaceHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            avatarPlaceHolder.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        acronymLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            acronymLabel.topAnchor.constraint(equalTo: topAnchor),
            acronymLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            acronymLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            acronymLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func setupWithAvatarURL(source: UIImage, imageUrl: String, userName: String, backGroundColor : UIColor = SessionInfo.shared.company?.primaryUIColor.extraLightColor ?? .purple, isFromMain: Bool = false ,hasImage: @escaping ((Bool) -> ())) {
        backgroundColor = backGroundColor
        if isFromMain {
            self.acronymLabel.textColor = SessionInfo.shared.company?.primaryUIColor
        } else {
            self.acronymLabel.textColor = backGroundColor.isLight() ? UIColor.black : UIColor.white
        }
        
        
        avatarImage.image = nil
        avatarImage.isHidden = true
        avatarPlaceHolder.image = nil
        avatarPlaceHolder.isHidden = true
        self.acronymLabel.isHidden = true
        setAcronym(for: userName)
        
        if imageUrl != "" {
            self.avatarImage.image = source
            self.avatarImage.isHidden = false
            self.avatarPlaceHolder.isHidden = true
            self.acronymLabel.isHidden = true
            self.backgroundColor = .clear
            
        } else {
            self.avatarImage.isHidden = true
            self.avatarPlaceHolder.isHidden = false
            self.acronymLabel.isHidden = false
//            self.backgroundColor = .clear
        }
      
    }
    
    private func setAcronym(for chatName: String) {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: chatName) {
            formatter.style = .abbreviated
            let acronym = formatter.string(from: components)
            acronymLabel.text = acronym
            acronymLabel.isHidden = false
        }
    }
}

extension UIColor {
    var isDark: Bool {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        guard self.getRed(&red, green: &green, blue: &blue, alpha: nil) else {
            return false
        }
        
        let lum = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        return lum < 0.5
    }
}
