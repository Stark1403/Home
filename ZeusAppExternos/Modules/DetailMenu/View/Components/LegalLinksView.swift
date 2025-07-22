//
//  LegalLinksView.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import UIKit

final class LegalLinksView: DetailMenuCell {
    
    lazy var privacyAgreementLabel: LabelWithChevron = {
        let label = LabelWithChevron()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var termsAndConditionsLabel: LabelWithChevron = {
        let label = LabelWithChevron()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var internalRegulationsLabel: LabelWithChevron = {
        let label = LabelWithChevron()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func set(udnColor: UIColor?) {
        privacyAgreementLabel.set(udnColor: udnColor)
        termsAndConditionsLabel.set(udnColor: udnColor)
        internalRegulationsLabel.set(udnColor: udnColor)
    }
    
    override func configure() {
        guard let mainPermission = permissions[.legal] else { return }
        iconView.image = UIImage(named: "pencil")
        titleLabel.text = mainPermission.name
        
        if let termsPermission = permissions[.internalrRegulation] {
            internalRegulationsLabel.label.text = termsPermission.name
            contentStack.addArrangedSubview(internalRegulationsLabel)
        }
        
        if let privacyPermission = permissions[.privacy] {
            privacyAgreementLabel.label.text = privacyPermission.name
            contentStack.addArrangedSubview(privacyAgreementLabel)
        }
        
        if let termsPermission = permissions[.termConditions] {
            termsAndConditionsLabel.label.text = termsPermission.name
            contentStack.addArrangedSubview(termsAndConditionsLabel)
        }
    }
}
