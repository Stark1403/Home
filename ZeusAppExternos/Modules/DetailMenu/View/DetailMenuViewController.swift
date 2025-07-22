//
//  DetailMenuViewController.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import UIKit
import ZeusCoreInterceptor
import ZeusExternosLogin
import Alamofire
import ZeusSessionInfo
import Foundation
enum InternetAlertType {
case Data, Wifi
}

extension Notification.Name {
    static let goToNewFLow = Notification.Name("goToNewFLow")
    static let openSideMenuBiometric = Notification.Name("openSideMenuBiometric")
}

protocol SwitchValueDelegate: AnyObject {
    func switchValueChanged(isOn: Bool)
}

final class DetailMenuViewController: SlideViewController {

    var presenter: DetailMenuPresenterProtocol?
    let detailedMenuView = DetailMenuView()
    var permissions = [ZCIExternalZeusKeys: PermissionMenuModel]()
    
    lazy var optionsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var legalOptionsContainerView: LegalOptionsView = {
        let view = LegalOptionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var settingsOptionsContainerView: SettingsOptionsView = {
        let view = SettingsOptionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()
    
    let userHeaderOptions = UserHeaderOptions()
    let userMidOptions = UserMidOptions()
    let userBottomOptions = UserBottomOptions()
    
    let shadowGray = UIView()
    var deletedAccount: Bool = false
    
    var udnColor: UIColor {
        if let color = SessionInfo.shared.company?.primaryUIColor {
            return color
        }
        return UIColor.zeusPrimaryColor ?? .purple
    }
    
    var isGuest : Bool = false
    weak var switchValueDelegate: SwitchValueDelegate?
    
    var showAlertCallBack: ((_ goToLegal: Bool) -> Void)? = nil
    var presentMyProfileCallBack: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shadowGray.alpha = 0
        updateHeader()
        setInitialValues()
        direction = .right
        userHeaderOptions.showMyProfileCallBack = onShowMyProfileTapped
        userMidOptions.goToSettingCallBack = onGoToOptionSettingsBtnTapped
        userMidOptions.goToLegalCallBack = onGoToLegalBtnTapped
        userMidOptions.switchValueChangedCallBack = onSwitchValueChanged
        
        legalOptionsContainerView.dismissViewCallBack = onGoToDismissLegalBtnTapped
        legalOptionsContainerView.goToOptionCallBack = onGoToOptionBtnTapped
        
        settingsOptionsContainerView.goToOptionCallBack = onGoToOptionSettingsBtnTapped
        settingsOptionsContainerView.dismissViewCallBack = onGoToDismissSettingsBtnTapped
        
        userBottomOptions.changePasswordCallBack = onChangePasswordTapped
        userBottomOptions.deleteAccountCallBack = onDeleteAccountTapped
        userBottomOptions.closeSessionCallBack = onCloseSessionTapped
        
        let value = UserDefaultsManager.getBool(key: .mobileDataactivated)
        userMidOptions.setSwitchStatus(isOn: value)
        self.isGuest = UserDefaultsManager.getBool(key: .isGuestUser)
        
        SideMenuCollector.send(category: .sideBar, subCategory: .sideBarDetail, event: .openView, action: .view, metadata: "")
    }
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var onChangePasswordTapped: (_ goToLegal: Bool) -> Void = { [weak self] (goToLegal) in
        guard let self = self else { return }
        SideMenuCollector.send(category: .sideBar, subCategory: .sideBarDetail, event: .tapChangePass, action: .click, metadata: "")
        
        showAlertCallBack?(true)
        switchValueDelegate?.switchValueChanged(isOn: true)
        
        if let sideMenuBackView = UIApplication.shared.sideMenuBackView{
            UIView.animate(withDuration: 0.40) {
                sideMenuBackView.alpha = 0
            } completion: { _ in
                sideMenuBackView.removeFromSuperview()
            }
        }
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            self?.performDismissActivities()
        }) { [weak self] _ in
            if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
                slideView.removeFromSuperview()
                NotificationCenter.default.post(name: .goToNewFLow, object: nil, userInfo: ["newFlow": ZCIExternalZeusKeys.passwordChange])
            }
        }
        
    }

    lazy var onDeleteAccountTapped: (_ goToLegal: Bool) -> Void = { [weak self] (goToLegal) in
        guard let self = self else { return }
        
        SideMenuCollector.send(category: .sideBar, subCategory: .sideBarDetail, event: .tapDeleteAccount, action: .click, metadata: "")
        
        if let sideMenuBackView = UIApplication.shared.sideMenuBackView{
            UIView.animate(withDuration: 0.40) {
                sideMenuBackView.alpha = 0
            } completion: { _ in
                sideMenuBackView.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            self?.performDismissActivities()
        }) { [weak self] _ in
            if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
                slideView.removeFromSuperview()
                NotificationCenter.default.post(name: .goToNewFLow, object: nil, userInfo: ["newFlow": ZCIExternalZeusKeys.deleteAccount])
            }
        }
       
    }
    
    lazy var onCloseSessionTapped: (_ goToLegal: Bool) -> Void = { [weak self] (goToLegal) in
        guard let self = self else { return }
        
        SideMenuCollector.send(category: .sideBar, subCategory: .sideBarDetail, event: .tapCloseSession, action: .click, metadata: "")
        
        if let slideView = UIApplication.shared.closeSessionAlert as? CloseSessionAlert {
            slideView.isHidden = false
        }
    }
    
    lazy var onActivateMobileDataTapped: (_ goToLegal: Bool) -> Void = { [weak self] (goToLegal) in
        guard let self = self else { return }
        
        if goToLegal {
            //Data usage
            SideMenuCollector.send(category: .sideBar, subCategory: .dataUsageAlert, event: .tapAccept, action: .click, metadata: "")
        } else {
            //Data usage
            SideMenuCollector.send(category: .sideBar, subCategory: .dataUsageAlert, event: .tapCancel, action: .click, metadata: "")
        }
        
        UserDefaultsManager.setBool(key: .mobileDataactivated, value: goToLegal)
        userMidOptions.setSwitchStatus(isOn: goToLegal)
    }
    
    lazy var onSwitchValueChanged: (_ isOn: Bool) -> Void = { [weak self] (isOn) in
        guard let self = self else { return }
        SideMenuCollector.send(category: .sideBar, subCategory: .sideBarDetail, event: .tapMibleData, action: .click, metadata: "")
        if isOn {
            //MARK: Show alert
            if let slideView = UIApplication.shared.mobileDataAlert as? MobileDataAlert {
                //Data usage
                SideMenuCollector.send(category: .sideBar, subCategory: .dataUsageAlert, event: .tapCancel, action: .click, metadata: "")
                
                slideView.isHidden = false
                slideView.activateMobileDataCallBack = onActivateMobileDataTapped
            }
        } else {
            UserDefaultsManager.setBool(key: .mobileDataactivated, value: false)
            let value = UserDefaultsManager.getBool(key: .mobileDataactivated)
            userMidOptions.setSwitchStatus(isOn: value)
        }
    }
    
    lazy var onGoToLegalBtnTapped: (_ goToLegal: Bool) -> Void = { [weak self] (goToLegal) in
        guard let self = self else { return }
        SideMenuCollector.send(category: .sideBar, subCategory: .sideBarDetail, event: .tapLegal, action: .click, metadata: "")
        legalOptionsContainerView.isHidden = false
    }
    
    lazy var onGoToOptionBtnTapped: (_ goToTerms: Bool) -> Void = { [weak self] (goToTerms) in
        guard let self = self else { return }
        legalOptionsContainerView.isHidden = false
        
        if let sideMenuBackView = UIApplication.shared.sideMenuBackView{
            UIView.animate(withDuration: 0.40) {
                sideMenuBackView.alpha = 0
            } completion: { _ in
                sideMenuBackView.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            self?.performDismissActivities()
        }) { [weak self] _ in
            if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
                slideView.removeFromSuperview()
                if goToTerms {
                    //Legal
                    SideMenuCollector.send(category: .legalSideBar, subCategory: .legalDetail, event: .tapTemsAndCond, action: .click, metadata: "")
                    self?.showTermsAndConditions()
                } else {
                    //Legal
                    SideMenuCollector.send(category: .legalSideBar, subCategory: .legalDetail, event: .tapPrivacy, action: .click, metadata: "")
                    self?.showPrivacyAgreement()
                }
            }
        }
        
    }
    
    func hideSideMenu() {
        dismissMenu()
    }
    
    lazy var onGoToOptionSettingsBtnTapped: () -> Void = { [weak self] () in
        guard let self = self else { return }
        SideBarEvents.shared.sendEvent(.configurationClick)
        settingsOptionsContainerView.isHidden = false
        SideBarConfigurationEvents.shared.sendEvent(.screen)
    }
    
    lazy var onShowMyProfileTapped: () -> Void = { [weak self] () in
        guard let self = self else { return }
        
        //MARK: - Navigating to profile
        dismissMenu()
        
        
        showMyProfile()
    }
    
    lazy var onGoToDismissLegalBtnTapped: (_ dismissView: Bool) -> Void = { [weak self] (dismissView) in
        guard let self = self else { return }
        legalOptionsContainerView.isHidden = dismissView
    }
    
    lazy var onGoToDismissSettingsBtnTapped: (_ dismissView: Bool) -> Void = { [weak self] (dismissView) in
        guard let self = self else { return }
        settingsOptionsContainerView.isHidden = dismissView
    }
    
    func updateHeader() {
        var fullName = ""
        let name = SessionInfo.shared.user?.name ?? ""
        let components = name.components(separatedBy: " ")
        if components.count >= 2 {
            fullName = "\(components[0])"
        }else{
            fullName = "\(SessionInfo.shared.user?.name ?? "")"
        }
        userHeaderOptions.setUserName(name: fullName)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let _ = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
        userBottomOptions.setLabelVersion(version: "Versión \(appVersion)")
    }
    
    private func setInitialValues() {
        presenter?.getInitialData()
    }
    
    func setIsGuest(isGuest: Bool) {
        userMidOptions.isGuestUser(isGuest: isGuest, permissions: self.permissions)
        userBottomOptions.isGuestUser(isGuest: isGuest)
        if isGuest {
            userHeaderOptions.setUserName(name: "Invitad@")
        }
    }
    
    func setMenu(permissions: [PermissionMenuModel]?){
        guard let list = permissions else{
            return
        }
        
        for permission in list {
            if let navigatorKey = ZCIExternalZeusKeys(rawValue: String(permission.idPermission)){
                self.permissions.updateValue(permission, forKey: navigatorKey)
                let list = permission.childs
                for subPermission in list {
                    if let menu = ZCIExternalZeusKeys(rawValue: String(subPermission.idPermission)){
                        self.permissions.updateValue(subPermission, forKey: menu)
                    }
                }
            }
        }
        configureLegalInfo()
        configureSignOut()
        configureNewConstraints()
        
        self.setIsGuest(isGuest: self.isGuest)
        self.settingsOptionsContainerView.permissions = self.permissions
    }
    // MARK: - Legal Info

    func configureLegalInfo() {
        guard let mainPermission = permissions[.legal] else { return }
        let view = LegalLinksView()
        view.permissions.updateValue(mainPermission, forKey: .legal)

        if let privacy = permissions[.privacy] {
            let privacyAgreementRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPrivacyAgreement))
            view.privacyAgreementLabel.addGestureRecognizer(privacyAgreementRecognizer)
            view.permissions.updateValue(privacy, forKey: .privacy)
        }
        
        if let terms = permissions[.termConditions] {
            let termsAndConditionsRecognizer = UITapGestureRecognizer(target: self, action: #selector(showTermsAndConditions))
            view.termsAndConditionsLabel.addGestureRecognizer(termsAndConditionsRecognizer)
            view.permissions.updateValue(terms, forKey: .termConditions)
        }
        
        view.set(udnColor: udnColor)
        view.configure()
    }
    
    @objc
    private func showPrivacyAgreement() {
        guard let permission = permissions[.privacy] else {
            return
        }
        self.openModule(permission: String(permission.idPermission))
    }

    @objc
    private func showTermsAndConditions() {
        guard let permission = permissions[.termConditions] else { return }
        self.openModule(permission: String(permission.idPermission))
    }
     
    // MARK: - Change pass
    @objc private func onChangePass() {
        ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.passwordChange, navigateDelegate: self)
    }
    
    // MARK: - Delete Account
    @objc
    private func onDeleteAccount() {
        ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.deleteAccount, navigateDelegate: self)
    }
    
    // MARK: - Sign Out
    func configureSignOut() {
        let view = SignOutView()
        view.set(udnColor: udnColor)
        view.configure()
    }
    
    @objc
    private func onMobileNetworkSwitched(_ sender: UISwitch) {
        guard sender.isOn else {
            return
        }
        
        let vc = UIStoryboard.overFullScreen(type: "Alert") as! AlertViewController
        vc.tittleAlert = "Advertencia"
        vc.messageAlert = "Al confirmar estará de acuerdo con la sincronización de archivos con datos, esta función podrá consumir los datos móviles ¿Desea continuar?"
        vc.cancelOutlined = true
        vc.titleButtonConfirm = "Aceptar"
        vc.titleButtonCancel = "Cancelar"
        vc.didTapAceptButton = {
            UserDefaultsManager.setBool(key: .mobileDataactivated, value: true)
        }
        
        vc.didTapCancelButton = {
            UserDefaultsManager.setBool(key: .mobileDataactivated, value: false)
        }
    }
    
    private func configureNewConstraints(){
        userHeaderOptions.translatesAutoresizingMaskIntoConstraints = false
        userMidOptions.translatesAutoresizingMaskIntoConstraints = false
        userBottomOptions.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(optionsContainerView)
        optionsContainerView.addSubview(userHeaderOptions)
        optionsContainerView.addSubview(userMidOptions)
        optionsContainerView.addSubview(userBottomOptions)
        contentView.addSubview(legalOptionsContainerView)
        contentView.addSubview(settingsOptionsContainerView)
        
        NSLayoutConstraint.activate([
        
            optionsContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            optionsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            optionsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            optionsContainerView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            legalOptionsContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            legalOptionsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            legalOptionsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            legalOptionsContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            settingsOptionsContainerView.topAnchor.constraint(equalTo: legalOptionsContainerView.topAnchor),
            settingsOptionsContainerView.leadingAnchor.constraint(equalTo: legalOptionsContainerView.leadingAnchor),
            settingsOptionsContainerView.trailingAnchor.constraint(equalTo: legalOptionsContainerView.trailingAnchor),
            settingsOptionsContainerView.bottomAnchor.constraint(equalTo: legalOptionsContainerView.bottomAnchor),
            
            userHeaderOptions.topAnchor.constraint(equalTo: optionsContainerView.topAnchor, constant: 50),
            userHeaderOptions.leadingAnchor.constraint(equalTo: optionsContainerView.leadingAnchor),
            userHeaderOptions.trailingAnchor.constraint(equalTo: optionsContainerView.trailingAnchor),
            
            userMidOptions.topAnchor.constraint(equalTo: userHeaderOptions.bottomAnchor, constant: 15),
            userMidOptions.leadingAnchor.constraint(equalTo: optionsContainerView.leadingAnchor),
            userMidOptions.trailingAnchor.constraint(equalTo: optionsContainerView.trailingAnchor),
            
            userBottomOptions.topAnchor.constraint(equalTo: userMidOptions.bottomAnchor),
            userBottomOptions.leadingAnchor.constraint(equalTo: optionsContainerView.leadingAnchor),
            userBottomOptions.trailingAnchor.constraint(equalTo: optionsContainerView.trailingAnchor),
            userBottomOptions.bottomAnchor.constraint(equalTo: optionsContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
    }
}

extension DetailMenuViewController: DetailMenuViewProtocol {

    func updateWith(syncedFiles: Int, totalFiles: Int) {
//        syncedFilesView.updateWith(syncedFiles: syncedFiles, totalFiles: totalFiles)
    }
        
    func dismissMenu() {
        dismissMenu(animated: true)
    }
    
    func setCellularSwitchTo(on: Bool) {
//        settingsView.mobileDataToggle.setOn(on, animated: true)
    }
    
    func setApp(version: String) {
//        detailedMenuView.versionLabel.text = version
        
    }
}

extension DetailMenuViewController {
   
    
    func willFinishFlow(withInfo info: [String : Any]?) {
        if let module = Legal(rawValue: info?["title"] as? String ?? "") {
            switch module {
            case .privacyAnnounment: OnboardingEvents.shared.sendEvent(.outputAp)
            case .termsConditions: OnboardingEvents.shared.sendEvent(.ouputTandC)
            }
        }
        
        if let info = info, let deleted = info["deletedAccount"] as? Bool {
            deletedAccount = deleted
        }
    }
    
    func didFinishFlow() {
        guard deletedAccount else { return }
        SessionManager.logout()
    }
}
