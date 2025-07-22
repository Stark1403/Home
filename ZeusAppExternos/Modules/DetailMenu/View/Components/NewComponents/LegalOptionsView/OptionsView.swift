//
//  OptionsView.swift
//  ZeusAppExternos
//
//  Created by Karen Irene Arellano Barrientos on 02/07/24.
//

import Foundation
import ZeusCoreDesignSystem

class OptionsView: UIView {
    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backArrowIV: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "arrow-back")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(style: .headline3(isItalic: false))
        lbl.textColor = .dark600
        return lbl
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .dark600
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 30
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
        setupGestureRecognizers()
    }
    
    var dismissViewCallBack: ((_ dismissView: Bool) -> Void)? = nil
    
    func setupViewLayout() {
        
        addSubview(headerContainerView)
        headerContainerView.addSubview(backArrowIV)
        headerContainerView.addSubview(titleLabel)
        headerContainerView.addSubview(separatorView)
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: backArrowIV.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -20),
            
            backArrowIV.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            backArrowIV.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            backArrowIV.heightAnchor.constraint(equalToConstant: 25),
            backArrowIV.widthAnchor.constraint(equalToConstant: 25),
            
            separatorView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 70),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func setupGestureRecognizers() {
        let tapDismissView = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backArrowIV.addGestureRecognizer(tapDismissView)
    }
    
    @objc func dismissView(){
        SideBarConfigurationEvents.shared.sendEvent(.back)
        dismissViewCallBack?(true)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
