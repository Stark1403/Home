//
//  DetailMenuView.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import UIKit
import ZeusUtils
import ZeusCoreDesignSystem
final class DetailMenuView: UIView {
    
    // MARK: - Menu View
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(style: .headline3())
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(style: .bodyTextM())
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Constraints
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureConstraints()
    }
    
    func addToContentStack(subview: UIView) {
        stackView.addArrangedSubview(subview)
    }
    
    func configureConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(nameLabel)
        addSubview(scrollView)
        addSubview(versionLabel)
        
        scrollView.addSubview(stackView)
       
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 77.0),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.0),
            
            scrollView.topAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor, constant: 22),
            scrollView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 5.0),
            scrollView.bottomAnchor.constraint(equalTo: versionLabel.topAnchor, constant: -10.0),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40.0),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            versionLabel.lastBaselineAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -10.0),
            versionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            versionLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}

