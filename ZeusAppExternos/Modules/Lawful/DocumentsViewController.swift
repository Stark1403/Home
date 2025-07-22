//
//  DocumentsViewController.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Perez on 5/16/23.
//

import UIKit
import ZeusCoreInterceptor
import ZeusSessionInfo
import ZeusTermsConditions
import ZeusCoreDesignSystem
import ZeusUtils

class DocumentsViewController: UIViewController, ZCInterceptorDelegate, UITextViewDelegate {
    func didFailToEnterFlow(error: NSError) {
        
    }
    var zeusId: String? = nil
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UITextView!
    @IBOutlet weak var cancelButton: ZDSButtonAlt!
    @IBOutlet weak var continueButton: ZDSButtonAlt!
    @IBOutlet weak var heightValue: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    var navController: UINavigationController?
    var updateLegal: LegalOptions?
    var parameters: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLegal = parameters["update"] as? LegalOptions ?? .both
        zeusId = parameters["zeusId"] as? String
       
        self.setupView()
        self.continueButton?.addTarget(self, action: #selector(self.continueAction), for: .touchUpInside)
        self.cancelButton?.addTarget(self, action: #selector(self.cancelActionButton), for: .touchUpInside)
        
        TermsAndPrivacyFirebaseManager.getLastTermsAndPrivacyDocument(completion: { _ in
            self.setupView()
            self.updateHeight()
        })
    }
    
    func setupView(){
        closeButton.setImage(UIImage(named: "close", in: ZeusUtilSDK.bundle, compatibleWith: nil), for: .normal)
        containerView.layer.cornerRadius = 12
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UDNSkin.global.color.cgColor
        cancelButton.setTitleColor(UDNSkin.global.color, for: .normal)
        cancelButton.layer.cornerRadius = 8
        continueButton.backgroundColor = UDNSkin.global.color
        continueButton.layer.cornerRadius = 8
        setupBody()
    }
    
    func updateHeight() {
        let bodyLabelHeight = bodyLabel.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        let headerHeight = headerTitleLabel.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        
        heightValue.constant = 120 + bodyLabelHeight + headerHeight
        containerView.layoutIfNeeded()
    }
    
    func setupBody() {
        bodyLabel.tintColor = UDNSkin.global.color
        bodyLabel.sizeToFit()
        bodyLabel.isScrollEnabled = false
        bodyLabel.delegate = self
        bodyLabel.isUserInteractionEnabled = true
        switch updateLegal ?? .both {
        case .both:
            let message = "Al continuar estás aceptando nuestro Aviso de privacidad y los Términos y condiciones"
            let attributedString = NSMutableAttributedString(string: message, attributes:
                                                                [.font: UIFont(style: .bodyTextM())!])
            let linkAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UDNSkin.global.color,
                NSAttributedString.Key.underlineColor: UIColor.white,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.font : UIFont(style: .bodyTextM(variant: .semiBold, isItalic: false))!
            ]
            let privacyRange = (attributedString.string as NSString).range(of: "Aviso de privacidad")
            attributedString.addAttribute(NSAttributedString.Key.link, value: LegalUrls.shared?.privacyUrl ?? "", range: privacyRange)
            let termsRange = (attributedString.string as NSString).range(of: "Términos y condiciones")
            attributedString.addAttribute(NSAttributedString.Key.link, value: LegalUrls.shared?.termsCondicionsUrl ?? "", range: termsRange)
            bodyLabel.linkTextAttributes = linkAttributes
            bodyLabel.attributedText = attributedString
            headerTitleLabel.text = "Aviso de privacidad y Términos y condiciones"
        case .updatePrivacy:
            let message = "Hemos modificado nuestro aviso de privacidad. Recuerda que debes aceptarlo para seguir usando el servicio. Puedes consultarlo dando clic en Aviso de privacidad.\n\nAl continuar estás aceptando las modificaciones."
            let attributedString = NSMutableAttributedString(string: message, attributes:
                        [.font: UIFont(style: .bodyTextM())!])
            let linkAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UDNSkin.global.color,
                NSAttributedString.Key.underlineColor: UIColor.white,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.font : UIFont(style: .bodyTextM(variant: .semiBold, isItalic: false))!
            ]
            let privacyRange = (attributedString.string as NSString).range(of: "Aviso de privacidad")
            attributedString.addAttribute(NSAttributedString.Key.link, value: LegalUrls.shared?.privacyUrl ?? "", range: privacyRange)
            bodyLabel.linkTextAttributes = linkAttributes
            bodyLabel.attributedText = attributedString
            headerTitleLabel.text = "Cambios en el Aviso de privacidad"
        case .updateTerms:
            let message = "Hemos modificado nuestros términos y condiciones. Recuerda que debes aceptarlos para continuar usando el servicio. Puedes consultarlos dando clic en Términos y condiciones.\n\nAl continuar estás aceptando las modificaciones."
            let attributedString = NSMutableAttributedString(string: message, attributes:
                        [.font: UIFont(style: .bodyTextM())!])
            let linkAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UDNSkin.global.color,
                NSAttributedString.Key.underlineColor: UIColor.white,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.font : UIFont(style: .bodyTextM(variant: .semiBold, isItalic: false))!
            ]
            let termsRange = (attributedString.string as NSString).range(of: "Términos y condiciones")
            attributedString.addAttribute(NSAttributedString.Key.link, value: LegalUrls.shared?.termsCondicionsUrl ?? "", range: termsRange)
            bodyLabel.linkTextAttributes = linkAttributes
            bodyLabel.attributedText = attributedString
            headerTitleLabel.text = "Cambios en los Términos y condiciones"
        case .updateBoth:
            let message = "Hemos modificado nuestro aviso de privacidad y los términos y condiciones. Recuerda que debes aceptarlos para continuar usando el servicio.\n\nAl continuar estás aceptando nuestro Aviso de privacidad y los Términos y condiciones."
            let attributedString = NSMutableAttributedString(string: message, attributes:
                        [.font: UIFont(style: .bodyTextM())!])
            let linkAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UDNSkin.global.color,
                NSAttributedString.Key.underlineColor: UIColor.white,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.font : UIFont(style: .bodyTextM(variant: .semiBold, isItalic: false))!
            ]
            let privacyRange = (attributedString.string as NSString).range(of: "Aviso de privacidad")
            attributedString.addAttribute(NSAttributedString.Key.link, value: LegalUrls.shared?.privacyUrl ?? "", range: privacyRange)
            let termsRange = (attributedString.string as NSString).range(of: "Términos y condiciones")
            attributedString.addAttribute(NSAttributedString.Key.link, value: LegalUrls.shared?.termsCondicionsUrl ?? "", range: termsRange)

            bodyLabel.linkTextAttributes = linkAttributes
            bodyLabel.attributedText = attributedString
            headerTitleLabel.text = "Cambios en el Aviso de privacidad y  los Términos y condiciones"
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let privacy = LegalUrls.shared?.privacyUrl, URL.absoluteString.contains(privacy) {
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.webView,
                                       navigateDelegate: self,
                                       withInfo: ["url": privacy, "title": Legal.privacyAnnounment.rawValue])
        } else if let terms = LegalUrls.shared?.termsCondicionsUrl, URL.absoluteString.contains(terms) {
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.webView,
                                       navigateDelegate: self,
                                       withInfo: ["url": terms, "title": Legal.termsConditions.rawValue])
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
    
    
    func accepted() {
        (self.navigationController as? ZCINavigationController)?.flowInfo = ["declinePrivacyTerms" : false]
        ZCInterceptor.shared.releaseLastFlow()
    }
    
    func removeSession() {
        (self.navigationController as? ZCINavigationController)?.flowInfo = ["declinePrivacyTerms": true]
        ZCInterceptor.shared.releaseLastFlow()
    }
    
    @IBAction func closeView(_ sender: Any) {
        cancelActionButton()
    }
    
    @objc func cancelActionButton() {
        switch updateLegal {
        case .both:
            removeSession()
        case .updatePrivacy:
            TermsAndPrivacyFirebaseManager(zeusId: self.zeusId).declinePrivacy(newPrivacyVersion: LegalUrls.shared?.privacyVersion) { [weak self] message in
                self?.removeSession()
            }
        case .updateTerms:
            TermsAndPrivacyFirebaseManager(zeusId: self.zeusId).declineTerms(newTermsVersion: LegalUrls.shared?.termsVersion) { [weak self] message in
                self?.removeSession()
            }
        case .updateBoth:
            TermsAndPrivacyFirebaseManager(zeusId: self.zeusId).declineTermsAndPrivacy(newPrivacyVersion: LegalUrls.shared?.privacyVersion, newTermsVersion: LegalUrls.shared?.termsVersion) { [weak self] message in
                self?.removeSession()
            }
        case .none: break
        }
    }
    
    @objc func continueAction() {
        switch updateLegal {
        case .both:
            TermsAndPrivacyFirebaseManager(zeusId: self.zeusId).acceptTermsAndPrivacy(newPrivacyVersion: LegalUrls.shared?.privacyVersion,
                                                                                              newTermsVersion: LegalUrls.shared?.termsVersion) { status in
                if status {
                    self.accepted()
                }
            }
        case .updatePrivacy:
            TermsAndPrivacyFirebaseManager(zeusId: self.zeusId).acceptPrivacy(newPrivacyVersion: LegalUrls.shared?.privacyVersion) { status in
                if status {
                    self.accepted()
                }
            }
        case .updateTerms:
            TermsAndPrivacyFirebaseManager(zeusId: self.zeusId).acceptTerms(newTermsVersion: LegalUrls.shared?.termsVersion) { status in
                if status {
                    self.accepted()
                }
            }
        case .updateBoth:
            TermsAndPrivacyFirebaseManager(zeusId: self.zeusId).acceptTermsAndPrivacy(newPrivacyVersion: LegalUrls.shared?.privacyVersion, newTermsVersion: LegalUrls.shared?.termsVersion) { status in
                if status {
                    self.accepted()
                }
            }
        case .none: break
        }
    }
    
}

public class AlertPrivacyTermsFlows {

    public static func registerActions() {
        ZCInterceptor.shared.registerFlow(withNavigatorItem: AlertPrivacyTermsItem.self)
    }
}

public class AlertPrivacyTermsItem: ZCInterceptorItem {
    
    public static var moduleName: String {
        return NavigatorKeys.alertPrivacyTerms.rawValue
    }

    public static func createModule(withInfo parameters: [String : Any]?) -> UIViewController {
        let vc = DocumentsViewController(nibName: "DocumentsViewController", bundle: Bundle(for: AlertPrivacyTermsItem.self))
        
        vc.parameters = parameters ?? [:]
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
}
