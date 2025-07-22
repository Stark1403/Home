//
//  SettingsView.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import UIKit
import ZeusUtils
import ZeusSessionInfo

final class SettingsView: DetailMenuCell {
    
    lazy var options: UILabel = {
        let label = UILabel()
        label.text = "Datos móviles"
        label.font = UIFont(style: .bodyTextS())
        label.textColor = .menuOptionsTitles
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mobileData: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var mobileDataHeadline: UILabel = {
        let label = UILabel()
        label.text = "Datos móviles"
        label.font = UIFont(style: .bodyTextM())
        label.textColor = .menuOptionsTitles
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mobileDataDescription: UILabel = {
        let label = UILabel()
        label.text = "Subir imágenes, audios, videos y archivos con datos móviles"
        label.font = UIFont(style: .bodyTextS())
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .menuOptionsTitles
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mobileDataToggle: UISwitch = {
        let view = UISwitch()
        view.onTintColor = SessionInfo.shared.company?.primaryUIColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var labelChangePass: LabelWithChevron = {
        let label = LabelWithChevron()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deleteAccountLabel: LabelWithChevron = {
        let label = LabelWithChevron()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func set(udnColor: UIColor?) {
        labelChangePass.set(udnColor: udnColor)
        deleteAccountLabel.set(udnColor: udnColor)
    }
    
    func configure(canDeleteAccount: Bool) {
        titleLabel.text = "Configuración"
        iconView.image = UIImage(named: "gear")
        configureConstraints()
        contentStack.spacing = 6.0
        contentStack.addArrangedSubview(mobileData)
        labelChangePass.label.text = "Cambio de contraseña"
        contentStack.addArrangedSubview(labelChangePass)

        if canDeleteAccount{
            deleteAccountLabel.label.text = "Eliminar cuenta"
            contentStack.addArrangedSubview(deleteAccountLabel)
        }
        let status = UserDefaultsManager.getBool(key: .mobileDataactivated)
        switchSetOn(setOn: status)
    }
    
    @objc
    private func switchValueDidChange(_ sender: UISwitch) {
        if (sender.isOn == false){
            UserDefaultsManager.setBool(key: .mobileDataactivated, value: false)
        }
    }
    
    func switchSetOn(setOn: Bool) {
        self.mobileDataToggle.setOn(setOn, animated: true)
    }
    
    func configureConstraints() {
        mobileData.addSubview(mobileDataHeadline)
        mobileData.addSubview(mobileDataDescription)
        mobileData.addSubview(mobileDataToggle)
        
        NSLayoutConstraint.activate([
            mobileDataToggle.trailingAnchor.constraint(equalTo: mobileData.trailingAnchor),
            mobileDataToggle.heightAnchor.constraint(equalToConstant: 26.0),
            mobileDataToggle.widthAnchor.constraint(equalToConstant: 60.0),
            mobileDataToggle.centerYAnchor.constraint(equalTo: mobileDataHeadline.centerYAnchor),
            
            mobileDataHeadline.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: mobileData.topAnchor, multiplier: 1.0),
            mobileDataHeadline.trailingAnchor.constraint(equalTo: mobileDataToggle.leadingAnchor),
            mobileDataHeadline.leadingAnchor.constraint(equalTo: mobileData.leadingAnchor),
            
            mobileDataDescription.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: mobileDataHeadline.lastBaselineAnchor, multiplier: 1.5),
            mobileDataDescription.trailingAnchor.constraint(equalTo: mobileDataToggle.leadingAnchor, constant: -30),
            mobileDataDescription.leadingAnchor.constraint(equalTo: mobileData.leadingAnchor),
            
            mobileData.bottomAnchor.constraint(equalToSystemSpacingBelow: mobileDataDescription.lastBaselineAnchor, multiplier: 1.0)
        ])
    }
}
