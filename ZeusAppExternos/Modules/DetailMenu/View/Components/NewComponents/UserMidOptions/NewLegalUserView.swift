//
//  NewLegalUserView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 02/05/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo

class NewLegalUserViewTwo: ItemView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        leadingIconImageView.image = UIImage(materialIcon: .historyEdu)?.withTintColor(.dark600 ?? .black, renderingMode: .alwaysTemplate)
        titleTextLbl.text = "Legales"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class CutomSmallSeparatorView : UIView {
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
