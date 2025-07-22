//
//  LabelWithChevron.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import UIKit
import ZeusUtils
import ZeusSessionInfo
import ZeusCoreDesignSystem
final class LabelWithChevron: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(style: .bodyTextM())
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = .menuOptionsTitles
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(materialIcon: .chevronRight)?.withTintColor(SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor ?? .gray, renderingMode: .alwaysTemplate)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureConstraints()
    }
    
    func set(udnColor: UIColor?) {
        image.tintColor = udnColor
    }
    
    private func configureConstraints() {
        addSubview(label)
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 20.0),
            image.widthAnchor.constraint(equalToConstant: 20.0),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
            
            label.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 0.7),
            bottomAnchor.constraint(equalToSystemSpacingBelow: label.lastBaselineAnchor, multiplier: 0.7),
            
            label.trailingAnchor.constraint(equalTo: image.leadingAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
