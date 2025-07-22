//
//  GuestHomeViewController+Views.swift
//  ZeusAppExternos
//
//  Created by Rafael on 17/08/23.
//
import UIKit
import ZeusUtils
import ZeusCoreDesignSystem
//Use this class to create views inside of GuestHomeViewController
class GuestHomeViews {
    
    let imageCompanyLogo: UIImageView = {
        let image = UIImage(named: "defaultBusinessLogo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let topViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let imageProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let labelProfileName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .dynamicFontStyle(style: .Regular, relativeSize: 20.0)
        label.text = "¡Hola, Invitad@!"
        return label
    }()
    
    let buttonMenu: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "menu_lateral"), for: .normal)
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(GuestHomeCollectionViewCell.self, forCellWithReuseIdentifier: "GuestHomeCollectionViewCell")
        return cv
    }()
    
    let labelAcronym: UILabel = {
        let acronym = "I"
        let label = UILabel()
        label.font = UIFont(style: .headline2())
        label.textColor = .zeusPrimaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = acronym
        return label
    }()
    
    let profileBackgroudView: UIView = {
        let view = UIView()
        view.backgroundColor = .zeusPrimaryColor
        view.layer.opacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 36
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
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var cameraImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "ic_clipboard-list")
        imageView.image = image
        imageView.tintColor = .zeusPrimaryColor
        return imageView
    }()
}
