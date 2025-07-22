//
//  MyFavoritesCell.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 20/06/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo

class MyFavoritesCell: UICollectionViewCell {
    static let identifier = "CoachPepeCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "newOptionsTint")
        return imageView
    }()
    
    let noItemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "newOptionsTint")
        imageView.image = UIImage(materialIcon: .add)?.withTintColor(.black, renderingMode: .alwaysTemplate)
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#393647")
        label.font = UIFont(style: .bodyTextS(variant: .regular, isItalic: false))
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var favoriteImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#21222C").withAlphaComponent(0.20)
        view.isHidden = true
        return view
    }()
    
    lazy var favoriteImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "favoriteOffIc")
        iv.tintColor = .white
        
        return iv
    }()
    
    lazy var shimmerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#EAE9EB")
        view.layer.cornerRadius = 10
        view.addShimmerEffect()
        return view
    }()
    
    lazy var badgeNew: ZDSBadge = {
        var badge = ZDSBadge()
        badge.title = "🔥 Nuevo"
        badge.style = .high
        return badge
    }()
    
    lazy var badgeView: UIView = {
        return badgeNew.asUIKitView()
    }()
    
    var isFavorite: Bool?
    var isLoading: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(noItemImageView)
        contentView.addSubview(favoriteImageContainer)
        favoriteImageContainer.addSubview(favoriteImageView)
        contentView.addSubview(shimmerView)
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            
            noItemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            noItemImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            noItemImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            noItemImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 0),
            
            favoriteImageContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            favoriteImageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            favoriteImageContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4),
            favoriteImageContainer.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4),
            
            favoriteImageView.topAnchor.constraint(equalTo: favoriteImageContainer.topAnchor, constant: 5),
            favoriteImageView.leadingAnchor.constraint(equalTo: favoriteImageContainer.leadingAnchor, constant: 5),
            favoriteImageView.trailingAnchor.constraint(equalTo: favoriteImageContainer.trailingAnchor, constant: -5),
            favoriteImageView.bottomAnchor.constraint(equalTo: favoriteImageContainer.bottomAnchor, constant: -5),
            
            shimmerView.topAnchor.constraint(equalTo: topAnchor),
            shimmerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        favoriteImageContainer.layer.cornerRadius = (self.frame.height / 4) / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addBadgePriority() {
        contentView.addSubview(badgeView)
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: topAnchor, constant: -4),
            badgeView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    
    func deleteBadgePriority() {
        badgeView.removeFromSuperview()
    }
    
    
    func configureCell(data: PermissionMenuModel, badge: Int, shouldShowFavorite: Bool = false, shouldShowPlus: Bool = true, shouldChangeBackground:  Bool = false){
        
        if isLoading ?? false {
            shimmerView.isHidden = false
        } else {
            UIView.animate(withDuration: 0.4) {
                self.shimmerView.isHidden = true
            }
        }
        
        if data.badgePriority == 3 {
            addBadgePriority()
        } else {
            deleteBadgePriority()
        }
        
        contentView.backgroundColor = UIColor(hexString: "#F5F5F7")
        contentView.clipsToBounds = false
       
        if shouldShowFavorite {
            favoriteImageContainer.isHidden = false
        }
        
        if data.idPermission != -1 {
            if let image = UIImage(named: "home-\(data.idPermission)"){
                noItemImageView.isHidden = true
                imageView.isHidden = false
                nameLabel.isHidden = false
                imageView.image = image.withTintColor(UIColor(hexString: "#393647"), renderingMode: .alwaysTemplate)
            }else{
                imageView.isHidden = true
                nameLabel.isHidden = true
                if shouldShowPlus {
                    
                    noItemImageView.isHidden = false
                } else {
                    noItemImageView.isHidden = true
                }
            }
            nameLabel.text = data.name
        } else {
            imageView.isHidden = true
            nameLabel.isHidden = true
            
            if shouldShowPlus {
                noItemImageView.isHidden = false
            } else {
                noItemImageView.isHidden = true
            }
            
            
        }
        
        if isFavorite ?? false {
            
            favoriteImageView.image = UIImage(named: "favoriteOnIc")
        } else {
            favoriteImageView.image = UIImage(named: "favoriteOffIc")
        }
    }
}


class MyFavoritesDBLocal {
    public static let shared = MyFavoritesDBLocal()

    private let DATABASENAME = "MyFavoritesDB"
    internal let permissionsFavorites = SQLTable(name: MyFavoritesTables.permissionsFavorites, columns: permissionsFavoritesColumns)
   
    private var didInit: Bool = false
    
    private init() {
        guard didInit == false else { return }
        createDataBase()
    }
        
    public func createDataBase() {
        let db = SQLite(dbName: DATABASENAME)
        db.printPath()
        db.createTable(table: permissionsFavorites)
        didInit = true
    }
    
    internal static let permissionsFavoritesColumns: [SQLColumnType<PermissionsFavoritesColumnNames>] = [
        .int(columnName: .id),
        .text(columnName: .name),
        .bool(columnName: .favorite),
        .int(columnName: .position),
    ]
}

import UPAXSQLite

public enum MyFavoritesTables: String, ISQLTable {
    case permissionsFavorites
}

public enum PermissionsFavoritesColumnNames: String, ISQLColumn {
    case id
    case name
    case favorite
    case position
}
