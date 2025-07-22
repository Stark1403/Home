//
//  ErrorHandler.swift
//  ZeusAppExternos
//
//  Created by Alejandro Rivera on 26/09/23.
//

import Foundation
import ZeusUtils
import ZeusCoreDesignSystem
class ErrorButtonHandler: ZDSResultAlertViewControllerDelegate {
    private var firstButtonAction: (() -> Void)?
    private var secondaryButtonAction: (() -> Void)?
    private var backButton: (() -> Void)?
    
    init(firstButtonAction: (() -> Void)?, secondaryButtonAction: (() -> Void)?, backButtonAction: (() -> Void)?) {
        self.firstButtonAction = firstButtonAction
        self.secondaryButtonAction = secondaryButtonAction
        self.backButton = backButtonAction
    }
    
    func onSuccess() {
        firstButtonAction?()
    }
    
    func onSecondary() {
        secondaryButtonAction?()
    }
    
    func backButtonAction() {
        backButton?()
    }
}
