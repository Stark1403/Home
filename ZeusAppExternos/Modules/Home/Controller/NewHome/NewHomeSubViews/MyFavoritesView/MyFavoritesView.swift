//
//  MyFavoritesView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 19/06/24.
//

import Foundation
import UIKit
import ZeusCoreDesignSystem
import ZeusUtils
import ZeusSessionInfo

class MyFavoritesView: UIView {
    
    lazy var mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F5F5F7")
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var titleSectionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    lazy var collectionViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Mis favoritos"
        lbl.numberOfLines = 1
        lbl.font = UIFont(style: .bodyTextXL(variant: .semiBold, isItalic: false))
        lbl.textColor = UIColor(hexString: "#111019")
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var editItemsButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let iconForButton = UIImage(materialIcon: .editSquare)?.withTintColor(.dark600 ?? .black, renderingMode: .alwaysTemplate)
        btn.setImage(iconForButton, for: .normal)
        btn.tintColor = UIColor.black
        btn.addTarget(self, action: #selector(goToFavoritesMenu), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleSectionStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        [titleLabel, editItemsButton].forEach { sv.addArrangedSubview($0)}
        return sv
    }()
    
    var currentFavorites: [PermissionMenuModel] = [] 
    var goToFavoriteSelected: ((_ permissionItem: PermissionMenuModel) -> Void)? = nil
    var goToFavoriteMenu: ((_ shouldPresent: Bool) -> Void)? = nil
    let option1 = OptionStackView()
    let option2 = OptionStackView()
    let option3 = OptionStackView()
    
    lazy var favoriteSectionStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 10
        
        option1.configure(idPermission: 0, name: "")
        option2.configure(idPermission: 0, name: "")
        option3.configure(idPermission: 0, name: "")
        
        let tapOne = UITapGestureRecognizer(target: self, action: #selector(didSelectFavoriteOne))
        option1.isUserInteractionEnabled = true
        option1.addGestureRecognizer(tapOne)
        
        let tapTwo = UITapGestureRecognizer(target: self, action: #selector(didSelectFavoriteTwo))
        option2.isUserInteractionEnabled = true
        option2.addGestureRecognizer(tapTwo)
        
        let tapThree = UITapGestureRecognizer(target: self, action: #selector(didSelectFavoriteThree))
        option3.isUserInteractionEnabled = true
        option3.addGestureRecognizer(tapThree)
        
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContraints()
    }
    
    private func setupContraints(){
        addSubview(mainContainerView)
        
        mainContainerView.addSubview(titleSectionContainer)
        mainContainerView.addSubview(collectionViewContainer)
        
        titleSectionContainer.addSubview(titleSectionStackView)
        
        collectionViewContainer.addSubview(favoriteSectionStackView)
        NSLayoutConstraint.activate([
            mainContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            mainContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            titleSectionContainer.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            titleSectionContainer.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor,constant: 20),
            titleSectionContainer.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -20),
            titleSectionContainer.heightAnchor.constraint(equalTo: mainContainerView.heightAnchor, multiplier: 1/3),
            
            collectionViewContainer.topAnchor.constraint(equalTo: titleSectionContainer.bottomAnchor),
            collectionViewContainer.leadingAnchor.constraint(equalTo: titleSectionContainer.leadingAnchor, constant: 0),
            collectionViewContainer.trailingAnchor.constraint(equalTo: titleSectionContainer.trailingAnchor, constant: 0),
            collectionViewContainer.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor),
            
            titleSectionStackView.topAnchor.constraint(equalTo: titleSectionContainer.topAnchor, constant: 0),
            titleSectionStackView.leadingAnchor.constraint(equalTo: titleSectionContainer.leadingAnchor),
            titleSectionStackView.trailingAnchor.constraint(equalTo: titleSectionContainer.trailingAnchor),
            titleSectionStackView.bottomAnchor.constraint(equalTo: titleSectionContainer.bottomAnchor, constant: -0),
            
            editItemsButton.widthAnchor.constraint(equalToConstant: 25),
            
            favoriteSectionStackView.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor),
            favoriteSectionStackView.leadingAnchor.constraint(equalTo: collectionViewContainer.leadingAnchor),
            favoriteSectionStackView.trailingAnchor.constraint(equalTo: collectionViewContainer.trailingAnchor),
            favoriteSectionStackView.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor, constant: -10),
        ])
    }
    
    func changeShimmerStatus(isLoading: Bool){
        if isLoading {
            titleSectionContainer.alpha = 0
        } else {
            UIView.animate(withDuration: 0.2) {
                self.titleSectionContainer.alpha = 1
            }
        }
        option1.updateShimmerStatus(isLoading: isLoading)
        option2.updateShimmerStatus(isLoading: isLoading)
        option3.updateShimmerStatus(isLoading: isLoading)
    }
    
    func configurBaseViews(){
        option1.favoriteId = -1
        option2.favoriteId = -1
        option3.favoriteId = -1
        option1.configure(idPermission: 0, name: "")
        option2.configure(idPermission: 0, name: "")
        option3.configure(idPermission: 0, name: "")
    }
    
    func setFavoriteOption(favorites: [PermissionMenuModel]){
        currentFavorites.removeAll()
        currentFavorites = favorites
        
        for (index, value) in currentFavorites.enumerated() {
            print(index)
            
            switch index {
            case 0:
                option1.favoriteId = index
                option1.configure(idPermission: value.idPermission, name: value.name ?? "")
            case 1:
                option2.favoriteId = index
                option2.configure(idPermission: value.idPermission, name: value.name ?? "")
            case 2:
                option3.favoriteId = index
                option3.configure(idPermission: value.idPermission, name: value.name ?? "")
            default:
                break
            }
        }
        
        [option1, option2, option3].forEach { favoriteSectionStackView.addArrangedSubview($0)}
        
        
        
    }
    
    @objc func goToFavoritesMenu(){
        goToFavoriteMenu?(true)
    }
    
    @objc func didSelectFavoriteOne(){
        if option1.favoriteId == -1 {
            goToFavoriteMenu?(true)
        } else {
            let index = IndexPath(row: option1.favoriteId ?? -1, section: 0)
            let currentFav = currentFavorites[index.row]
            goToFavoriteSelected?(currentFav)
        }
    }
    
    @objc func didSelectFavoriteTwo(){
        if option2.favoriteId == -1 {
            goToFavoriteMenu?(true)
        } else {
            let index = IndexPath(row: option2.favoriteId ?? -1, section: 0)
            let currentFav = currentFavorites[index.row]
            goToFavoriteSelected?(currentFav)
        }
    }
    
    @objc func didSelectFavoriteThree(){
        if option3.favoriteId == -1 {
            goToFavoriteMenu?(true)
        } else {
            let index = IndexPath(row: option3.favoriteId ?? -1, section: 0)
            let currentFav = currentFavorites[index.row]
            goToFavoriteSelected?(currentFav)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
}

class OptionStackView : UIView {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#EAE9EB")
        view.layer.cornerRadius = 10
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "qrIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(hexString: "#393647")
        return imageView
    }()
    
    let addItemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#393647")
        label.font = UIFont(style: .bodyTextS(variant: .regular, isItalic: false))
        
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var shimmerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#EAE9EB")
        view.layer.cornerRadius = 10
        view.addShimmerEffect()
        return view
    }()
    
    var favoriteId: Int? = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(addItemImageView)
        addSubview(shimmerView)
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            
            addItemImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            addItemImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            addItemImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            addItemImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            
            shimmerView.topAnchor.constraint(equalTo: topAnchor),
            shimmerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func updateShimmerStatus(isLoading: Bool){
        if isLoading {
            shimmerView.isHidden = false
        } else {
            UIView.animate(withDuration: 0.4) {
                self.shimmerView.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(idPermission: Int, name: String) {
        if name == "" {
            nameLabel.isHidden = true
            imageView.isHidden = true
            addItemImageView.isHidden = false
            addItemImageView.image = UIImage(materialIcon: .add)?.withTintColor(.black, renderingMode: .alwaysTemplate)
        } else {
            if let image = UIImage(named: "home-\(idPermission)"){
                imageView.image = image.withTintColor(UIColor(hexString: "#393647"), renderingMode: .alwaysTemplate)
            }
            addItemImageView.isHidden = true
            nameLabel.isHidden = false
            imageView.isHidden = false
            nameLabel.text = name
        }
    }
}
