//
//  GuestHome+CollectionViewCell.swift
//  ZeusAppExternos
//
//  Created by Rafael on 18/08/23.
//

import Foundation
import UIKit
import ZeusCoreDesignSystem
class GuestHomeCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let labelText: UILabel = {
        let label = UILabel()
        label.font = UIFont(style: .bodyTextS())
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Texto donde quepa solo en dos renglones"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: GuestMenuList){
        
        if let image = UIImage(named: "guest.home.\(data.permissionID ?? 0)"){
            imageView.image = image
        }else{
            imageView.image = UIImage(named: "AppIcon")
        }
        labelText.text = data.name
    }
    
    private func setupView() {
        addSubview(imageView)
        addSubview(labelText)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            labelText.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            labelText.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            labelText.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
    
}
