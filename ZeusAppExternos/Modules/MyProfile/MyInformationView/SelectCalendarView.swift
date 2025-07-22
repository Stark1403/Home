//
//  SelectCalendarView.swift
//  ZeusAppExternos
//
//  Created by Julio Cesar Michel Torres Licona on 16/01/25.
//

import UIKit
import ZeusCoreDesignSystem
import SwiftUI

public class SelectCalendarView: UIView {
    
    lazy var selectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor =  UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var selectTxt: ZDSTextField = {
        var text = ZDSTextField()
        text.title = "Fecha de Nacimiento"
        text.disabled = true
        text.state = .none
        return text
    }()
    
    lazy var selectTxtView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view = selectTxt.asUIKitView()
        return view
    }()

    lazy var imageRightSelect: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(materialIcon: .pencil, fill: false)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.tintColor = .black900
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
       
        self.addSubview(selectView)
        
        selectView.addSubview(self.selectTxtView)
        selectView.addSubview(self.imageRightSelect)
        
        NSLayoutConstraint.activate([
            selectView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            selectView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            selectView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            selectView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0),
            
            selectTxtView.leadingAnchor.constraint(equalTo: selectView.leadingAnchor, constant: 0),
            selectTxtView.trailingAnchor.constraint(equalTo: selectView.trailingAnchor, constant: 0),
            selectTxtView.topAnchor.constraint(equalTo: selectView.topAnchor, constant: 0),
            selectTxtView.bottomAnchor.constraint(equalTo: selectView.bottomAnchor, constant: 0),
            
            imageRightSelect.heightAnchor.constraint(equalToConstant: 24),
            imageRightSelect.widthAnchor.constraint(equalToConstant: 24),
            imageRightSelect.trailingAnchor.constraint(equalTo: selectView.trailingAnchor, constant: -8),
            imageRightSelect.centerYAnchor.constraint(equalTo: selectView.centerYAnchor, constant: 0),
        ])
        
    }
}
