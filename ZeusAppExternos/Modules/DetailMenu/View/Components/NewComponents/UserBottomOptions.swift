//
//  UserBottomOptions.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 29/04/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
class UserBottomOptions: UIView {
    var udnColor: UIColor {
        if let color = SessionInfo.shared.company?.primaryUIColor {
            return color
        }
        return UIColor.zeusPrimaryColor ?? .purple
    }
    lazy var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var optionsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 20
        
        return sv
    }()
    
    lazy var versionStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .leading
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    
    lazy var companyLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "zeusLogoIc")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var versionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "v1.1.7"
        lbl.font = UIFont(style: .bodyTextS(variant: .regular, isItalic: false))
        lbl.textColor = UIColor(hexString: "#69657B")
        return lbl
    }()
    
    lazy var closeSession: UILabel = {
        let lbl = UILabel()
        let attString = NSMutableAttributedString(string: "Cerrar Sesión", attributes: [NSAttributedString.Key.font : UIFont(style: .bodyTextL(variant: .regular, isItalic: false)) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor : UIColor(hexString: "#00CFAB"), NSAttributedString.Key.underlineColor : UIColor(hexString: "#00CFAB")])
        lbl.attributedText = attString
        return lbl
    }()
    
    lazy var deleteAccount: UILabel = {
        let lbl = UILabel()
        lbl.text = "Eliminar cuenta"
        lbl.font = UIFont(style: .bodyTextL(variant: .regular, isItalic: false))
        return lbl
    }()
    
    var changePasswordCallBack: ((_ goToLegal: Bool) -> Void)? = nil
    var deleteAccountCallBack: ((_ goToLegal: Bool) -> Void)? = nil
    var closeSessionCallBack: ((_ goToLegal: Bool) -> Void)? = nil
    
    lazy var changePassword: UILabel = {
        let lbl = UILabel()
        lbl.text = "Cambiar contraseña"
        lbl.font = UIFont(style: .bodyTextL(variant: .regular, isItalic: false))
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
        setupGestureRecognizers()
    }
    
    private func setupViewLayout(){
        addSubview(viewContainer)
        viewContainer.addSubview(optionsContainerView)
        optionsContainerView.addSubview(stackView)
        viewContainer.addSubview(versionStackView)
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: topAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            
            versionStackView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
            versionStackView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            versionStackView.widthAnchor.constraint(equalToConstant: 90),

            versionStackView.heightAnchor.constraint(equalToConstant: 50),
            
            optionsContainerView.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            optionsContainerView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            optionsContainerView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            optionsContainerView.bottomAnchor.constraint(equalTo: versionStackView.topAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: optionsContainerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: optionsContainerView.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: optionsContainerView.centerYAnchor),
            
            companyLogoImageView.heightAnchor.constraint(equalToConstant: 22 )
        ])
        
    }
    
    func isGuestUser(isGuest: Bool){
        [companyLogoImageView, versionLabel].forEach{ versionStackView.addArrangedSubview($0) }
        
        if isGuest {
            [closeSession].forEach{ stackView.addArrangedSubview($0) }
        } else {
            [changePassword, deleteAccount, closeSession].forEach{ stackView.addArrangedSubview($0) }
        }
    }
    
    func setLabelVersion(version: String){
        versionLabel.text = version
    }
    
    func setupGestureRecognizers(){
        changePassword.isUserInteractionEnabled = true
        deleteAccount.isUserInteractionEnabled = true
        closeSession.isUserInteractionEnabled = true
        
        let changePasswordTap = UITapGestureRecognizer(target: self, action: #selector(didTapChangePassword))
        let deleteAccountTap = UITapGestureRecognizer(target: self, action: #selector(didTapDeleteAccount))
        let closeSessionTap = UITapGestureRecognizer(target: self, action: #selector(didTapCloseSession))
        
        changePassword.addGestureRecognizer(changePasswordTap)
        deleteAccount.addGestureRecognizer(deleteAccountTap)
        closeSession.addGestureRecognizer(closeSessionTap)
    }
    
    @objc func didTapChangePassword(){
        changePasswordCallBack?(true)
    }
    
    @objc func didTapDeleteAccount(){
        deleteAccountCallBack?(true)
    }
    
    @objc func didTapCloseSession(){
        closeSessionCallBack?(true)
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        configureConstraints()
    }
    
    func set(udnColor: UIColor?) {
//        image.tintColor = udnColor
    }

}
