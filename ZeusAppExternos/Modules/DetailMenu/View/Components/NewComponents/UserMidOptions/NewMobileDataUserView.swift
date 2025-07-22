//
//  NewMobileDataUserView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 02/05/24.
//

import UIKit
import ZeusCoreDesignSystem
import SwiftUI

class NewMobileDataUserView: UIView {
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var syncImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(materialIcon: .signalCellularAlt)?.withTintColor(.dark600 ?? .black, renderingMode: .alwaysTemplate)
        iv.tintColor = .black
        return iv
    }()
    
    lazy var mobileDataLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Usar datos móviles"
        lbl.numberOfLines = 0
        lbl.font = UIFont(style: .bodyTextL(variant: .regular, isItalic: false))
        return lbl
    }()
    
     var mobileDataSwitch: ZDSSwitch = {
        var sw = ZDSSwitch()
        sw.state = false
        return sw
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    var switchValueChangedCallBack: ((_ isOn: Bool) -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
        mobileDataSwitch.onChange = { newValue in
            self.switchValueChangedCallBack?(newValue)
        }
    }
    
    private func setupViewLayout(){
        let switchView = mobileDataSwitch.asUIKitView()
        addSubview(containerView)
        containerView.addSubview(syncImageView)
        containerView.addSubview(switchView)
        containerView.addSubview(mobileDataLbl)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 40),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            switchView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            switchView.centerYAnchor.constraint(equalTo: mobileDataLbl.centerYAnchor, constant: 0),
            
            syncImageView.centerYAnchor.constraint(equalTo: mobileDataLbl.centerYAnchor),
            syncImageView.heightAnchor.constraint(equalToConstant: 20),
            syncImageView.widthAnchor.constraint(equalToConstant: 20),
            syncImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            mobileDataLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0),
            mobileDataLbl.leadingAnchor.constraint(equalTo: syncImageView.trailingAnchor, constant: 12),
            mobileDataLbl.trailingAnchor.constraint(equalTo: switchView.leadingAnchor, constant: -5),
        ])
    }
   
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
}

