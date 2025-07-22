//
//  ProfilePhotoViews.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 28/11/23.
//

import Foundation
import UIKit
import ZeusSessionInfo
import ZeusUtils

class ProfilePhotoViews{
    
    var saveButton: ZUGenericButton = {
        let button = ZUGenericButton(udnSkin: .init(color: SessionInfo.shared.company?.primaryUIColor,
                                                    logo: nil,
                                                    miniLogo: nil), type: .inactive)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Guardar", for: .normal)
        button.titleLabel?.font = .header6
        return button
    }()
    
    lazy var viewImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = false
        view.layer.borderColor = SessionInfo.shared.company?.primaryUIColor.cgColor
        view.layer.borderWidth = 3
        view.isUserInteractionEnabled = true       
        return view
    }()
    
    var acronymLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I"
        label.font = UIFont(name: "Poppins-Semibold", size: 48)
        label.textColor = SessionInfo.shared.company?.primaryUIColor
        label.textAlignment = .center
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = SessionInfo.shared.company?.primaryUIColor.withAlphaComponent(0.15)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var cameraImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 8
        view.tintColor = SessionInfo.shared.company?.primaryUIColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var cameraImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = SessionInfo.shared.company?.primaryUIColor
        return imageView
    }()
    
}
