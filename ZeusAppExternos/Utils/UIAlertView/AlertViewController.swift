//
//  AlertViewController.swift
//  ZeusAppExternos
//
//  Created by Javier Alejandro Hernández Peralta on 18/08/23.
//  Copyright © 2023 Gabriel Briseño. All rights reserved.

import UIKit
import ZeusSessionInfo
import ZeusCoreDesignSystem
class AlertViewController: UIViewController {
    
    /// The title of the alert.
    var tittleAlert: String?
    
    /// The message of the alert.
    var messageAlert: String?
    
    /// The title for the confirm button.
    var titleButtonConfirm: String? = "Sí"
    
    /// The title for the cancel button.
    var titleButtonCancel: String? = "No"
    
    /// The UDNSkin object for styling the alert.
    var udn = SessionInfo.shared.company?.primaryUIColor
    
    /// Indicates whether the cancel button is outlined.
    var cancelOutlined: Bool = false
    
    /// The optional image to display in the alert.
    var alertImage: UIImage? = nil
    
    
    typealias onReturnAcept = () ->()
    typealias onReturnCancel = () ->()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var labelTitle: UILabel! {
        didSet {
            labelTitle.text = tittleAlert
            labelTitle.font = UIFont(style: .bodyTextL(variant: .semiBold))
            labelTitle.numberOfLines = 2
        }
    }
    
    /// The label to display the alert message.
    @IBOutlet weak var labelMessage: UILabel! {
        didSet {
            labelMessage.text = messageAlert
            labelMessage.font = UIFont(style: .bodyTextM())
        }
    }
    
    
    /// The button for the confirm action.
    @IBOutlet weak var buttonConfirm: ZDSButtonAlt! {
        didSet {
            buttonConfirm.titleLabel?.font =  UIFont(style: .bodyTextL(variant: .semiBold))
            buttonConfirm.layer.cornerRadius = 8
            buttonConfirm.setTitle(titleButtonConfirm, for: .normal)
            buttonConfirm.backgroundColor = udn
        }
    }
    
    /// The button for the cancel action.
    @IBOutlet weak var buttonCancel: ZDSButtonAlt! {
        didSet {
            buttonCancel.titleLabel?.font =  UIFont(style: .bodyTextL(variant: .semiBold))
            buttonCancel.setTitle(titleButtonCancel, for: .normal)
            buttonCancel.layer.cornerRadius = 8
            if cancelOutlined {
                self.buttonCancel.layer.borderColor = udn?.cgColor
                self.buttonCancel.layer.borderWidth = 2
                self.buttonCancel.backgroundColor = .white
                self.buttonCancel.setTitleColor(udn, for: .normal)
            }
        }
    }
    
    @IBOutlet weak var alertImageView: UIImageView!
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.layer.cornerRadius = 15
        }
    }
    
    var didTapAceptButton : onReturnAcept?
    var didTapCancelButton : onReturnCancel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAlertImage()
    }
    
    /// Sets the alert image if provided.
    func setAlertImage() {
        if let image = alertImage {
            alertImageView.isHidden = false
            alertImageView.image = image
        } else {
            alertImageView.isHidden = true
        }
    }
    
    @IBAction func buttonAcept(_ sender: Any) {
        guard let closure = didTapAceptButton else {return}
        self.dismiss(animated: true) {
            closure()
        }
    }
    
    
    @IBAction func buttonCancel(_ sender: Any) {
        guard let closure = didTapCancelButton else {return}
        self.dismiss(animated: true) {
            closure()
        }
    }
}
