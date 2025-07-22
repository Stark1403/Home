//
//  CloseSessionAlert.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 02/05/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusUtils
import ZeusSessionInfo
class CloseSessionAlert: UIView {
    
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
        lbl.text = "Advertencia"
        lbl.font = UIFont.MBodyBlackText
        return lbl
    }()
    
    lazy var labelMessage: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "¿Estás seguro que deseas cerrar sesión?"
        lbl.font = UIFont.MText
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
        btn.titleLabel?.font = .dynamicFontStyle(style: .SemiBold, relativeSize: 14)
        btn.layer.cornerRadius = 40 / 2
        btn.setTitle("Aceptar", for: .normal)
        btn.backgroundColor = udnColor
        btn.addTarget(self, action: #selector(didTapAccept), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .dynamicFontStyle(style: .SemiBold, relativeSize: 14)
        btn.layer.borderColor = udnColor.cgColor
        btn.layer.borderWidth = 2
        btn.backgroundColor = .white
        btn.setTitleColor(udnColor, for: .normal)
        btn.setTitle("Cancelar", for: .normal)
        btn.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        btn.layer.cornerRadius = 40 / 2
        return btn
    }()
    
    
    
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
            labelMessage.centerXAnchor.constraint(equalTo: alertViewContainer.centerXAnchor),
            
            cancelBtn.heightAnchor.constraint(equalToConstant: 40),
            
            confirmBtn.heightAnchor.constraint(equalToConstant: 40),
//            16 lados
//            24 up down
            stackView.topAnchor.constraint(equalTo: labelMessage.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: alertViewContainer.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: alertViewContainer.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: alertViewContainer.bottomAnchor, constant: -24),
            
        ])
    }
    
    @objc func didTapCancel(){
        if let slideView = UIApplication.shared.closeSessionAlert as? CloseSessionAlert {
            slideView.isHidden = true
            slideView.removeFromSuperview()
        }
    }
    
    @objc func didTapAccept(){
        if let slideView = UIApplication.shared.closeSessionAlert as? CloseSessionAlert {
            slideView.isHidden = true
            slideView.removeFromSuperview()
        }
        
        if let sideMenuBackView = UIApplication.shared.sideMenuBackView{
            UIView.animate(withDuration: 0.40) {
                sideMenuBackView.alpha = 0
            } completion: { _ in
                sideMenuBackView.removeFromSuperview()
            }
        }
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            let width = UIScreen.main.bounds.width
            let translation =  -width + 0
            self?.transform = CGAffineTransform(translationX: translation, y: 0.0)
        }) { [weak self] _ in
            if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
                slideView.removeFromSuperview()
                SessionManager.logout()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
