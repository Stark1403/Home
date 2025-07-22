//
//  SettingsOptionView.swift
//  ZeusAppExternos
//
//  Created by Karen Irene Arellano Barrientos on 02/07/24.
//

import Foundation
import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
import ZeusUtils
import SwiftUI
import ZeusCoreInterceptor
class SettingsOptionsView: OptionsView {
    var permissions = [ZCIExternalZeusKeys: PermissionMenuModel]() {
        didSet {
            //MARK: Waiting for permission
//            if let permission = permissions[.sideMenuBiometrics] {
//                stackView.addArrangedSubview(biometricView)
//            }
            stackView.addArrangedSubview(biometricView)
            stackView.addArrangedSubview(verifyPhoneNumberView)
        }
    }
    
    var goToOptionCallBack: (() -> Void)? = nil
    
    lazy var biometricView: ItemView = {
        let view = ItemView()
        view.titleTextLbl.text = "Activar biométricos"
        view.leadingIconImageView.image = UIImage(materialIcon: .fingerprint)
        view.leadingIconImageView.tintColor = .black900
        view.isUserInteractionEnabled = true
        view.removeStackViews()
        view.genericStackView.addArrangedSubview(switchToogle.asUIKitView())
        return view
    }()
    
    lazy var verifyPhoneNumberView: ItemView = {
        let view = ItemView()
        view.titleTextLbl.text = "Verificación de número"
        view.leadingIconImageView.image = UIImage(named: "phone_android", in: .local, compatibleWith: nil)
        view.leadingIconImageView.tintColor = .black900
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(verifyPhoneNumber)))
        return view
    }()

    var switchToogle: ZDSSwitch = {
        var toogle = ZDSSwitch()
        toogle.state = BiometricAuthManager.shared.isBiometricAuthOn() && BiometricAuthManager.shared.canUseBiometricAuthentication()
        return toogle
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
        titleLabel.text = "Configuración"
        switchToogle.onChange = { [weak self] isEnabled in
            SideBarConfigurationEvents.shared.sendEvent(.biometricsSwitch)
            if !BiometricAuthManager.shared.canUseBiometricAuthentication() && isEnabled {
                self?.switchToogle.state = false
                self?.showActivateBiometrics()
                return
            }
            
            // only falls here when you cancel biometrics deactivation.
            if BiometricAuthManager.shared.isBiometricAuthOn() == isEnabled {
                return
            }
           
            if isEnabled {
                self?.removeSideBar()
                NotificationCenter.default.post(name: .goToNewFLow,
                                                object: nil,
                                                userInfo: ["newFlow": NavigatorKeys.requestBiometric])
            } else {
                self?.showAlert()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func showAlert() {
        if let slideView = UIApplication.shared.biometricAlert as? DeactivateBiometricsAlertView {
            slideView.isHidden = false
            slideView.cancelCallBack = cancelCallBack
            slideView.aceptCallBack = aceptCallBack
        }
    }
    
    private func showActivateBiometrics() {
        if let slideView = UIApplication.shared.activateBiometricsAlert as? ActivateBiometricsAlertView {
            slideView.isHidden = false
            slideView.cancelCallBack = cancelCallBack
            slideView.aceptCallBack = aceptActivateCallBack
        }
    }
    
    @objc private func verifyPhoneNumber() {
        SideBarConfigurationEvents.shared.sendEvent(.verifyCollaborator)
        self.removeSideBar()
        NotificationCenter.default.post(name: .goToNewFLow,
                                        object: nil,
                                        userInfo: ["newFlow": ZeusCoreInterceptor.ZCIExternalZeusKeys.verifyPhoneNumber])
    }
    
    lazy var cancelCallBack: () -> Void = { [weak self] in
        guard let self = self else { return }
        
        if let slideView = UIApplication.shared.activateBiometricsAlert as? ActivateBiometricsAlertView {
            slideView.isHidden = true
            switchToogle.state = BiometricAuthManager.shared.isBiometricAuthOn()
        }
        
        if let slideView = UIApplication.shared.biometricAlert as? DeactivateBiometricsAlertView {
            slideView.isHidden = true
            switchToogle.state = BiometricAuthManager.shared.isBiometricAuthOn() && BiometricAuthManager.shared.canUseBiometricAuthentication()
        }
    }
    
    lazy var aceptActivateCallBack: () -> Void = { [weak self] in
        BiometricAuthManager.shared.setBiometricSwitchState(isOn: false)
        
        self?.removeSideBar()
        
        if let slideView = UIApplication.shared.biometricAlert {
            slideView.removeFromSuperview()
        }
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    lazy var aceptCallBack: () -> Void = { [weak self] in
        BiometricAuthManager.shared.setBiometricSwitchState(isOn: false)
        
        self?.removeSideBar()
        
        if let slideView = UIApplication.shared.biometricAlert {
            slideView.removeFromSuperview()
        }
        SessionManager.logout()
    }
    
    func removeSideBar() {
        if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
            slideView.removeFromSuperview()
        }
        if let sideMenuBackView = UIApplication.shared.sideMenuBackView {
            UIView.animate(withDuration: 0.10) {
                sideMenuBackView.alpha = 0
            } completion: { _ in
                sideMenuBackView.removeFromSuperview()
            }
        }
    }
    
    func showBiometricDisabledAlert() {
        if let slideView = UIApplication.shared.biometricDisabledAlert {
            slideView.isHidden = false
        }
    }
}
