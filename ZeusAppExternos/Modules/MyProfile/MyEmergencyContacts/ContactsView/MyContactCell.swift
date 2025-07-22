//
//  MyContactCell.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 02/10/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
import SwiftUI
class MyContactCell: UITableViewCell {
    
    static let identifier = "MyContactCell"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white000
        return view
    }()
    
    
    lazy var userProfileImageView: ZUAvatarImageView = {
        let iv = ZUAvatarImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        
        return iv
    }()
    
    lazy var contactNameLbl: UILabel  = {
        let lbl = UILabel()
        lbl.textColor = UIColor(hexString: "#393647")
        lbl.font = UIFont(style: .bodyTextM(variant: .bold, isItalic: false))
        lbl.numberOfLines = 1
        return lbl
    }()
    
    lazy var contactRelationshipLbl: UILabel  = {
        let lbl = UILabel()
        lbl.textColor = UIColor(hexString: "#69657B")
        lbl.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
        return lbl
    }()
    
    lazy var contactPhoneLbl: UILabel  = {
        let lbl = UILabel()
        lbl.textColor = UIColor(hexString: "#69657B")
        lbl.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
        return lbl
    }()
    
    lazy var contactInfoSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 5
        [contactNameLbl, contactRelationshipLbl, contactPhoneLbl].forEach {sv.addArrangedSubview($0)}
        return sv
    }()
    
    lazy var editContactBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(materialIcon: .moreVertical, fill: true)?.withRenderingMode(.alwaysTemplate).withTintColor(SessionInfo.shared.company?.primaryUIColor ?? .purple), for: .normal)
        btn.tintColor = SessionInfo.shared.company?.primaryUIColor ?? .purple
        btn.addTarget(self, action: #selector(didTapEditBtn), for: .touchUpInside)
        return btn
    }()
    
    var showMenuCallBack: ((_ currentUser: SendMyContactsResponse) -> Void)? = nil
    
    var myContact: SendMyContactsResponse? {
        didSet {
            
            print("CONTACT")
            let name = "\(myContact?.name ?? "") \(myContact?.surnames ?? "")"
            userProfileImageView.setupWithAvatarURL(source: UIImage(), imageUrl: "", userName: name,backGroundColor: SessionInfo.shared.company?.primaryUIColor ?? .purple) { hasImage in
                print(hasImage)
            }
            contactNameLbl.text = "\(myContact?.name ?? "") \(myContact?.surnames ?? "")"
            contactRelationshipLbl.text = myContact?.relationship?.description
            contactPhoneLbl.text = formatPhoneNumber(myContact?.phone ?? "")
            
            setupLayout()
            
            containerView.layer.cornerRadius = 15
            containerView.layer.masksToBounds = true
            containerView.clipsToBounds = true
            
        }
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        let cleanPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XX XXXX XXXX"
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    private func setupLayout(){
        contentView.backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(userProfileImageView)
        containerView.addSubview(contactInfoSV)
        containerView.addSubview(editContactBtn)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            userProfileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            userProfileImageView.centerYAnchor.constraint(equalTo: contactInfoSV.centerYAnchor),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 50),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 50),
            
            editContactBtn.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            editContactBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            editContactBtn.heightAnchor.constraint(equalToConstant: 24),
            editContactBtn.widthAnchor.constraint(equalToConstant: 24),
            
            contactInfoSV.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            contactInfoSV.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 10),
            contactInfoSV.trailingAnchor.constraint(equalTo: editContactBtn.leadingAnchor, constant: -10),
            contactInfoSV.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -13),
            
        ])
    }
    
    @objc private func didTapEditBtn() {
        guard let myContact = self.myContact else {return}
        showMenuCallBack?(myContact)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
