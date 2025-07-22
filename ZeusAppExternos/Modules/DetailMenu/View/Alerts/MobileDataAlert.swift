//
//  MobileDataAlert.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 02/05/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusUtils
import ZeusSessionInfo

class MobileDataAlert: UIView {
    
    var udnColor: UIColor {
        if let color = SessionInfo.shared.company?.primaryUIColor {
            return color
        }
        return UIColor.zeusPrimaryColor ?? .purple
    }
    
    lazy var backGroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.4)
        return view
    }()
    
    lazy var alertViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var labelTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Uso de datos móviles"
        lbl.font = UIFont(style: .headline4(isItalic: false))
        return lbl
    }()
    
    lazy var labelMessage: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "¿Estás de acuerdo en sincronizar archivos usando datos móviles?"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
        return lbl
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fillEqually
        [cancelBtn, confirmBtn].forEach{ sv.addArrangedSubview($0) }
        return sv
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont(style: .bodyTextM(variant: .semiBold, isItalic: false))
        btn.layer.cornerRadius = 40 / 2
        btn.setTitle("Aceptar", for: .normal)
        btn.backgroundColor = udnColor
        btn.addTarget(self, action: #selector(didTapAccept), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont(style: .bodyTextM(variant: .semiBold, isItalic: false))
        btn.layer.borderColor = udnColor.cgColor
        btn.layer.borderWidth = 2
        btn.backgroundColor = .white
        btn.setTitleColor(udnColor, for: .normal)
        btn.setTitle("Cancelar", for: .normal)
        btn.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        btn.layer.cornerRadius = 40 / 2
        return btn
    }()
    
    var activateMobileDataCallBack: ((_ goToLegal: Bool) -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(backGroundView)
        addSubview(alertViewContainer)
        alertViewContainer.addSubview(labelTitle)
        alertViewContainer.addSubview(labelMessage)
        alertViewContainer.addSubview(stackView)
        NSLayoutConstraint.activate([
            backGroundView.topAnchor.constraint(equalTo: topAnchor),
            backGroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            alertViewContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            alertViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            alertViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            labelTitle.topAnchor.constraint(equalTo: alertViewContainer.topAnchor, constant: 24),
            labelTitle.centerXAnchor.constraint(equalTo: alertViewContainer.centerXAnchor),
            
            labelMessage.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 15),
//            labelMessage.centerXAnchor.constraint(equalTo: alertViewContainer.centerXAnchor),
            labelMessage.leadingAnchor.constraint(equalTo: alertViewContainer.leadingAnchor, constant: 24),
            labelMessage.trailingAnchor.constraint(equalTo: alertViewContainer.trailingAnchor, constant: -24),
            
            cancelBtn.heightAnchor.constraint(equalToConstant: 40),
            
            confirmBtn.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: labelMessage.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: alertViewContainer.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: alertViewContainer.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: alertViewContainer.bottomAnchor, constant: -24),
            
        ])
    }
    
    @objc func didTapCancel(){
        if let slideView = UIApplication.shared.mobileDataAlert as? MobileDataAlert {
            slideView.isHidden = true
            slideView.removeFromSuperview()
        }
        activateMobileDataCallBack?(false)
    }
    
    @objc func didTapAccept(){
        if let slideView = UIApplication.shared.mobileDataAlert as? MobileDataAlert {
            slideView.isHidden = true
            slideView.removeFromSuperview()
        }
        activateMobileDataCallBack?(true)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
