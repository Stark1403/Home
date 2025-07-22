//
//  GuestHomeMenuViewController.swift
//  ZeusAppExternos
//
//  Created by Rafael on 22/08/23.
//
import UIKit
import ZeusCoreInterceptor
import ZeusTermsConditions
import ZeusCoreDesignSystem
import ZeusUtils
class GuestHomeMenuViewController: SubmenuViewController {
    
    let views: GuestHomeMenuViews = GuestHomeMenuViews()
    
    // MARK: - Properties
    var presenter: ViewToPresenterGuestHomeMenuProtocol?
    
    var permissions = [NavigatorKeys: PermissionMenuModel]()
    var menuPermissions: [PermissionMenuModel] = []
    
//    var typeAlert: InternetAlertType?
    var permissionAlert: PermissionMenuModel?
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout(views: views)
        setMenu(permissions: menuPermissions)
    }
    
    func setMenu(permissions: [PermissionMenuModel]?){
        guard let list = permissions else{
            return
        }
        
        for permission in list {
            if let navigatorKeys = NavigatorKeys(rawValue: String(permission.idPermission)) {
                self.permissions.updateValue(permission, forKey: navigatorKeys)
                let list = permission.childs
                for subPermission in list {
                    if let menu = NavigatorKeys(rawValue: String(subPermission.idPermission)){
                        self.permissions.updateValue(subPermission, forKey: menu)
                    }
                }
            }
        }
        
        configureLegalInfo()
        configureSignOut()
    }
    
    func configureSignOut() {
        let view = SignOutView()
        view.set(udnColor: .zeusPrimaryColor)
        let signOutRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSignOut))
        view.addGestureRecognizer(signOutRecognizer)
        view.configure()
        views.detailedMenuView.addToContentStack(subview: view)
    }
    
    @objc private func onSignOut() {
        UIAlertView.showYesNoAlert(title: "Cerrar Sesión", message: "¿Estás seguro de cerrar sesión?", viewController: self, yesCompletion: {
            SessionManager.logout()
        })
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
        
        view.set(udnColor: .zeusPrimaryColor)
        view.configure()
        self.views.detailedMenuView.addToContentStack(subview: view)
    }
    
    
    @objc private func showPrivacyAgreement() {
        guard let permission = permissions[.privacy] else { return }
        showModuleAndShowWifiAlert { [weak self] in
            self?.openModule(permission: String(permission.idPermission))
        }
    }

    @objc private func showTermsAndConditions() {
        guard let permission = permissions[.termConditions] else { return }
        showModuleAndShowWifiAlert { [weak self] in
            self?.openModule(permission: String(permission.idPermission))
        }
    }
    
    private func showModuleAndShowWifiAlert(callback: @escaping () -> Void) {
        UIAlertView.showRequireWifiAlert(viewController: self) { accept in
            guard accept else {
                callback()
                return
            }
            callback()
        }
    }
    
}


extension GuestHomeMenuViewController: ZCInterceptorDelegate {
    
    func openModule(permission: String) {
        let module = ZCIExternalZeusKeys(rawValue: permission)
        
        switch module {
            case .privacy:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.webView,
                                       navigateDelegate: self,
                                       withInfo: ["url": LegalUrls.shared?.privacyUrl ?? "",
                                                  "title": Legal.privacyAnnounment.rawValue])
                break
            case .termConditions:
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.webView,
                                           navigateDelegate: self,
                                           withInfo: ["url": LegalUrls.shared?.termsCondicionsUrl ?? "",
                                                      "title": Legal.termsConditions.rawValue])
                break
            default:
                
                break
        }
    }
    
    func didFailToEnterFlow(error: NSError) {
        
    }
}

extension GuestHomeMenuViewController: PresenterToViewGuestHomeMenuProtocol{
    // TODO: Implement View Output Methods
    
}

