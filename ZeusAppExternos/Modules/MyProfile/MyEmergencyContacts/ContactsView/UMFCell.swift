//
//  UMFCell.swift
//  ZeusAppExternos
//
//  Created by Satoritech 140 on 08/01/25.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
import SwiftUI

class UMFCell: UITableViewCell {
    
    static let identifier = "UMFCell"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white000
        return view
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userProfileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var dataLabel1: UILabel  = {
        let lbl = UILabel()
        lbl.textColor = UIColor(hexString: "#393647")
        lbl.font = UIFont(style: .bodyTextM(variant: .bold, isItalic: false))
        lbl.numberOfLines = 1
        return lbl
    }()
    
    lazy var dataLabel2: UILabel  = {
        let lbl = UILabel()
        lbl.textColor = UIColor(hexString: "#69657B")
        lbl.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
        return lbl
    }()
    
    lazy var contactInfoSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 3
        [dataLabel1, dataLabel2].forEach {sv.addArrangedSubview($0)}
        return sv
    }()
    
    lazy var editContactBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(materialIcon: .moreVertical, fill: true)?.withRenderingMode(.alwaysTemplate).withTintColor(SessionInfo.shared.company?.primaryUIColor ?? .purple), for: .normal)
        btn.tintColor = SessionInfo.shared.company?.primaryUIColor ?? .purple
        btn.addTarget(self, action: #selector(didTapEditBtn), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    var showMenuCallBack: ((_ currentUser: UMFdata) -> Void)? = nil
    var myContact: UMFdata? {
        didSet {
            dataLabel1.text = myContact?.data1
            dataLabel2.text = myContact?.data2
            userProfileImageView.image = UIImage(named: myContact?.image ?? "")
            
            if myContact?.id == 1{
                userProfileImageView.layer.cornerRadius = 25
                userProfileImageView.layer.masksToBounds = true
                userProfileImageView.clipsToBounds = true
                editContactBtn.isHidden = false
            }
            
            backView.backgroundColor = myContact?.color
            backView.layer.cornerRadius = 25
            backView.layer.masksToBounds = true
            backView.clipsToBounds = true
            setupLayout()
            
            containerView.layer.cornerRadius = 15
            containerView.layer.masksToBounds = true
            containerView.clipsToBounds = true
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    private func setupLayout(){
        contentView.backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(backView)
        containerView.addSubview(userProfileImageView)
        containerView.addSubview(contactInfoSV)
        containerView.addSubview(editContactBtn)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            backView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            backView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            backView.heightAnchor.constraint(equalToConstant: 50),
            backView.widthAnchor.constraint(equalToConstant: 50),
            
            editContactBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            editContactBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            editContactBtn.heightAnchor.constraint(equalToConstant: 24),
            editContactBtn.widthAnchor.constraint(equalToConstant: 24),
            
            contactInfoSV.leadingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 8),
            contactInfoSV.centerYAnchor.constraint(equalTo: backView.centerYAnchor)
        ])
        
        if myContact?.id == 1 {
            NSLayoutConstraint.activate([
                userProfileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                userProfileImageView.centerYAnchor.constraint(equalTo: contactInfoSV.centerYAnchor),
                userProfileImageView.heightAnchor.constraint(equalToConstant: 50),
                userProfileImageView.widthAnchor.constraint(equalToConstant: 50)
            ])
        } else {
            NSLayoutConstraint.activate([
                userProfileImageView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
                userProfileImageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
                userProfileImageView.heightAnchor.constraint(equalToConstant: 20),
                userProfileImageView.widthAnchor.constraint(equalToConstant: 20),
            ])
        }
    }
    
    @objc private func didTapEditBtn() {
        guard let myContact = self.myContact else {return}
        showMenuCallBack?(myContact)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
