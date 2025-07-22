//
//  HomeViewCollectionViewCell.swift
//  ZeusAppExternos
//
//  Created by Alexander Betanzos Lopez on 31/03/23.
//

import UIKit

class HomeViewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "homeViewCollectionViewCell"

    lazy var titleModuleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(style: .bodyTextS())
        label.textColor = .homeCellTitle
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultBusinessLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var badgeView: BadgeUILabel = {
        let badge = BadgeUILabel()
        badge.translatesAutoresizingMaskIntoConstraints = false
        return badge
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleModuleLabel)
        contentView.addSubview(badgeView)
    }
    
    // MARK: Update Constraint

    private func setupLayouts() {
      NSLayoutConstraint.activate([
        iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
        iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor, multiplier: 1/1),
        
        titleModuleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
        titleModuleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        titleModuleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 0),
        titleModuleLabel.heightAnchor.constraint(equalToConstant: 36),

        badgeView.widthAnchor.constraint(equalToConstant: 14),
        badgeView.heightAnchor.constraint(equalToConstant: 14),
        badgeView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: -15),
        badgeView.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: 0)
      ])
    }

    func configureCell(data: PermissionMenuModel, badge: Int){
        
        badgeView.setBadge(value: badge)
        
        if let image = UIImage(named: "home-\(data.idPermission)"){
            iconImageView.image = image
        }else{
            iconImageView.image = UIImage(named: "ZeusBox")
        }
        titleModuleLabel.text = data.name
    }
}
