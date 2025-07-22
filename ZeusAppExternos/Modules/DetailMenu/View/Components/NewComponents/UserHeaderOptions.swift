//
//  UserHeaderOptions.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 29/04/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusUtils
import ZeusSessionInfo
class UserHeaderOptions: UIView {
    
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Vanessa"
        lbl.font = UIFont(style: .headline3(isItalic: false))
        lbl.textColor = UIColor(hexString: "#69657B")
        return lbl
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#69657B")
        view.isHidden = false
        return view
    }()
    
    lazy var userCircularInformationView: UserCircularInformationView = {
        let ui = UserCircularInformationView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.isHidden = false
        return ui
    }()
    
    var showMyProfileCallBack: (() -> Void)? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
        setupCallBack()
    }
    
    private func setupCallBack(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapShowProfileCallBack))
        userCircularInformationView.isUserInteractionEnabled = true
        userCircularInformationView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapShowProfileCallBack(){
        showMyProfileCallBack?()
    }
    
    private func setupViewLayout(){
        addSubview(headerContainerView)
        headerContainerView.addSubview(userNameLbl)
        headerContainerView.addSubview(userCircularInformationView)
        headerContainerView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            headerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            userNameLbl.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 60),
            userNameLbl.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 0),
            userNameLbl.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            
            userCircularInformationView.topAnchor.constraint(equalTo: userNameLbl.bottomAnchor, constant: 10),
            userCircularInformationView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            userCircularInformationView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -16),
            userCircularInformationView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -10),
            
            separatorView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    func setUserName(name: String) {
        userNameLbl.text = "Hola, \(name)"
        userNameLbl.adjustsFontSizeToFitWidth = true
    }
    
    func set(udnColor: UIColor?) {
        //        image.tintColor = udnColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        configureConstraints()
    }
    
    
    
}

class UserCircularInformationView: UIView {
    
    lazy var mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var userProfileImageView: ZUAvatarImageView = {
        let iv = ZUAvatarImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 59 / 2
        let name = "\(SessionInfo.shared.user?.name ?? "") \(SessionInfo.shared.user?.lastName ?? "")"
        iv.setupWithAvatarURL(source: SessionInfo.shared.photoLocal ?? UIImage(), imageUrl: SessionInfo.shared.user?.photo ?? "", userName: name) { hasImage in
            print(hasImage)
        }
        
        return iv
    }()
    
    
    
    lazy var myAccountLabel: UILabel  = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Mi cuenta"
        lbl.textColor = UIColor(hexString: "#393647")
        lbl.font = UIFont(style: .bodyTextL(variant: .regular, isItalic: false))
        return lbl
    }()
    
    lazy var forwardImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(materialIcon: .chevronRight)?.withTintColor(.dark600 ?? .black, renderingMode: .alwaysTemplate)
        iv.tintColor = SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
    }
    
    func setupViewLayout(){
        addSubview(mainContainerView)
        
        mainContainerView.addSubview(userProfileImageView)
        mainContainerView.addSubview(myAccountLabel)
        mainContainerView.addSubview(forwardImageView)
        NSLayoutConstraint.activate([
            mainContainerView.topAnchor.constraint(equalTo: topAnchor),
            mainContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            userProfileImageView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            userProfileImageView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            userProfileImageView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 59),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 59),
            
            forwardImageView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -16),
            forwardImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            forwardImageView.widthAnchor.constraint(equalToConstant: 25),
            forwardImageView.heightAnchor.constraint(equalToConstant: 25),
            
            myAccountLabel.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor),
            myAccountLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 10),
            myAccountLabel.trailingAnchor.constraint(equalTo: forwardImageView.leadingAnchor, constant: -10),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

    


