//
//  UserView.swift
//  ZeusAppExternos
//
//  Created by Karen Irene Arellano Barrientos on 02/07/24.
//

import Foundation
import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo

class ItemView: UIView {
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var leadingIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var titleTextLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(style: .bodyTextL(variant: .regular, isItalic: false))
        return lbl
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var genericStackView: UIStackView = {
        let iv = UIStackView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewLayout() {
        addSubview(containerView)
        containerView.addSubview(leadingIconImageView)
        containerView.addSubview(titleTextLbl)
        containerView.addSubview(genericStackView)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            titleTextLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleTextLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            titleTextLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            
            leadingIconImageView.centerYAnchor.constraint(equalTo: titleTextLbl.centerYAnchor),
            leadingIconImageView.heightAnchor.constraint(equalToConstant: 24),
            leadingIconImageView.widthAnchor.constraint(equalToConstant: 24),
            leadingIconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            titleTextLbl.leadingAnchor.constraint(equalTo: leadingIconImageView.trailingAnchor, constant: 10),
            
            genericStackView.centerYAnchor.constraint(equalTo: titleTextLbl.centerYAnchor),
            genericStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            genericStackView.widthAnchor.constraint(equalToConstant: 32),
            genericStackView.heightAnchor.constraint(equalToConstant: 32),
            
            separatorView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 15),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        let imageView = UIImageView()
        genericStackView.addArrangedSubview(imageView)
        imageView.image = UIImage(materialIcon: .chevronRight)?.withTintColor(.dark600 ?? .black, renderingMode: .alwaysTemplate)
        imageView.tintColor = SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor
    }
    
    func setView(title: String, isFromLegalOption: Bool = false, optionType: String = ""){
        titleTextLbl.text = title
        
        if isFromLegalOption {
            switch optionType {
            case "terms":
                leadingIconImageView.image = UIImage(named: "navVefiIc")
                leadingIconImageView.tintColor = .black900
                break
            case "priv":
                leadingIconImageView.image = UIImage(named: "navVefiIcTwo")
                leadingIconImageView.tintColor = .black900
                break
            default:
                break
            }
        }
    }
    
    func removeStackViews() {
        genericStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}



