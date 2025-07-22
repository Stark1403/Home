//
//  DetailedMenuCell.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import UIKit
import ZeusUtils

class DetailedMenuCell: UIView {
    var content: [UIView]?
   
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(style: .bodyTextM(variant: .semiBold))
        label.text = "Item"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureConstraints()
    }
   
    func configure() {}
    
    func set(udnColor: UIColor) {
        titleLabel.textColor = udnColor
        iconView.tintColor = udnColor
    }
    
    private func configureConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        configure()
        
        titleLabel.textColor = .menuOptionsTitles
        iconView.tintColor = .menuOptionsIcons
        
        addSubview(contentStack)
        addSubview(iconView)
        
        contentStack.addArrangedSubview(titleLabel)
        
        if let content = content {
            for content in content {
                contentStack.addArrangedSubview(content)
            }
        }
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 18.0),
            iconView.widthAnchor.constraint(equalToConstant: 18.0),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            bottomAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: -10.0),
            
            contentStack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16.0),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
