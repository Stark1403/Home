//
//  UserMidOptions.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 29/04/24.
//

import UIKit
import ZeusUtils
import ZeusCoreInterceptor
class UserMidOptions: UIView {
    
    var permissions = [ZCIExternalZeusKeys: PermissionMenuModel]()
    
    lazy var userContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var syncContainerView: NewSyncUserView = {
        let view = NewSyncUserView()
        return view
    }()
    
    lazy var movileDataContainerView: NewMobileDataUserView = {
        let view = NewMobileDataUserView()
        return view
    }()
    
    lazy var legalContainerView: NewLegalUserViewTwo = {
        let view = NewLegalUserViewTwo()
        return view
    }()
    
    lazy var settingsView: SettingsUserView = {
        let view = SettingsUserView()
        return view
    }()
    
    var goToLegalCallBack: ((_ goToLegal: Bool) -> Void)? = nil
    var goToSettingCallBack: (() -> Void)? = nil
    var switchValueChangedCallBack: ((_ isOn: Bool) -> Void)? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
        setupUserInteraction()
        movileDataContainerView.switchValueChangedCallBack = onSwitchValueChanged
    }
    
    lazy var onSwitchValueChanged: (_ isOn: Bool) -> Void = { [weak self] (isOn) in
        guard let self = self else { return }
        switchValueChangedCallBack?(isOn)
    }
    
    func setupUserInteraction() {
        legalContainerView.isUserInteractionEnabled = true
        settingsView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToLegales))
        let tap_ = UITapGestureRecognizer(target: self, action: #selector(goToSettings))
        legalContainerView.addGestureRecognizer(tap)
        settingsView.addGestureRecognizer(tap_)
    }
    
    @objc func goToLegales() {
        print("Taped")
        goToLegalCallBack?(true)
    }
    
    @objc func goToSettings() {
        goToSettingCallBack?()
    }
    
    private func setupViewLayout(){
        addSubview(userContainerView)
        userContainerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            userContainerView.topAnchor.constraint(equalTo: topAnchor),
            userContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            userContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: userContainerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: userContainerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: userContainerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: userContainerView.bottomAnchor),
        ])
        
    }
    
    func isGuestUser(isGuest: Bool, permissions: [ZCIExternalZeusKeys: PermissionMenuModel]) {
        stackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        self.permissions = permissions
        
        let cutomSmallSeparatorView1 = CutomSmallSeparatorView()
        let cutomSmallSeparatorView2 = CutomSmallSeparatorView()
        let cutomSmallSeparatorView3 = CutomSmallSeparatorView()
        
        cutomSmallSeparatorView1.translatesAutoresizingMaskIntoConstraints = false
        cutomSmallSeparatorView2.translatesAutoresizingMaskIntoConstraints = false
        cutomSmallSeparatorView3.translatesAutoresizingMaskIntoConstraints = false
        if isGuest {
            [legalContainerView].forEach{ stackView.addArrangedSubview($0) }
        } else {
            //MARK: Waiting for permission
//            guard let permission = permissions[.sideMenuSettings] else {
//                [movileDataContainerView, 
//                 cutomSmallSeparatorView1,
//                 syncContainerView,
//                 cutomSmallSeparatorView2,
//                 legalContainerView].forEach { stackView.addArrangedSubview($0) }
//                return
//            }
            [movileDataContainerView, 
             cutomSmallSeparatorView1,
             syncContainerView,
             cutomSmallSeparatorView2,
             legalContainerView,
             settingsView].forEach{ stackView.addArrangedSubview($0) }
            
            NSLayoutConstraint.activate([
                cutomSmallSeparatorView1.heightAnchor.constraint(equalToConstant: 1),
                cutomSmallSeparatorView2.heightAnchor.constraint(equalToConstant: 1),
                cutomSmallSeparatorView3.heightAnchor.constraint(equalToConstant: 1)
            ])
        }
    }
    
    func setSwitchStatus(isOn: Bool){
        movileDataContainerView.mobileDataSwitch.state = isOn
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        configureConstraints()
    }
    
    func set(udnColor: UIColor?) {
//        image.tintColor = udnColor
    }
}
