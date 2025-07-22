//
//  HomeViewControllerViews.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 29/11/23.
//

import Foundation
import UIKit
import ZeusSessionInfo
import ZeusAttendanceControl
import ZeusCoreDesignSystem
class HomeViewControllerViews: UIView {
    
    // MARK: Child views
    
    lazy var logoBusinessImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultBusinessLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 43.5
        view.layer.borderWidth = 3
        view.layer.borderColor = SessionInfo.shared.company?.primaryUIColor.cgColor
        view.isUserInteractionEnabled = true
        return view
    }()

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 36
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let acronymLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(style: .headline2())
        label.textColor = SessionInfo.shared.company?.primaryUIColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileBackgroudView: UIView = {
        let view = UIView()
        view.backgroundColor = SessionInfo.shared.company?.primaryUIColor
        view.layer.opacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 46
        return view
    }()
    
    lazy var cameraImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
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
        let image = UIImage(named: "ic_clipboard-list")
        imageView.image = image
        imageView.tintColor = SessionInfo.shared.company?.primaryUIColor
        return imageView
    }()
    
    lazy var nameUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = .dynamicFontStyle(style: .Bold, relativeSize: 22.0)
        label.textColor = .homeNameUser
        if let firstName = SessionInfo.shared.user?.name.components(separatedBy: " ")[0]{
            label.text = "¡Hola \(firstName)!"
        }else{
            label.text = "¡Hola \(SessionInfo.shared.user?.name ?? "")!"
        }
        return label
    }()
    
    lazy var sideMenuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "hamb"), for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "search"), for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = UIColor.white
        button.isHidden = true
        return button
    }()
    
    //MARK: - ATTENDANCES VIEWS
    lazy var registerEntranceLabel = AttendanceOpenClass.shared.registerAttendanceLabel
    
    lazy var circularAssistanceButton = AttendanceOpenClass.shared.registerAttendanceButton
    
    func reload(){
        if let firstName = SessionInfo.shared.user?.name.components(separatedBy: " ")[0]{
            nameUserLabel.text = "¡Hola \(firstName)!"
        }else{
            nameUserLabel.text = "¡Hola \(SessionInfo.shared.user?.name ?? "")!"
        }
    }
}
