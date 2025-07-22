//
//  CommunicatesView.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 16/05/24.
//

import UIKit

class CommunicateCell: UICollectionViewCell {
    // Elementos de la celda
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let enterLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    let bannerContainerView: CustomSquareView = {
        let view = CustomSquareView(frame: CGRect(origin: CGPoint(x: 8, y: 8), size: CGSize(width: 130, height: 30)))
        view.backgroundColor = .red
        return view
    }()
    
    let bannerLabel: UILabel = {
        let label = UILabel()
        label.text = "¡Importante!"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    private func setupViews() {
        // Configurar elementos y añadirlos a la celda
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(enterLabel)
        contentView.addSubview(bannerContainerView)
        bannerContainerView.addSubview(bannerLabel)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .right
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.isHidden = true
        enterLabel.translatesAutoresizingMaskIntoConstraints = false
        enterLabel.textAlignment = .right
        bannerContainerView.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints para los elementos
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 38),
            
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            enterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            enterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            
            bannerContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            bannerContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            bannerContainerView.widthAnchor.constraint(equalToConstant: 130),
            bannerContainerView.heightAnchor.constraint(equalToConstant: 30),
            
            bannerLabel.centerXAnchor.constraint(equalTo: bannerContainerView.centerXAnchor, constant: -4),
            bannerLabel.centerYAnchor.constraint(equalTo: bannerContainerView.centerYAnchor)
        ])
        
        backgroundImageView.layer.cornerRadius = 8.0
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }
    
    func configure(with backgroundImage: UIImage?, title: String, description: String) {
        self.layer.cornerRadius = 8.0
        backgroundImageView.image = backgroundImage
        //titleLabel.text = title
        //descriptionLabel.text = description
    }
}

class CustomSquareView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Define the shape of the custom square view
        let path = UIBezierPath()
        
        let offset: CGFloat = 20 // Amount to offset the right side
        
        // Start from top-left corner
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Top side
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        
        // Right side (offset)
        path.addLine(to: CGPoint(x: self.bounds.width - offset, y: self.bounds.height))
        
        // Bottom side
        path.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        
        // Close the path (left side)
        path.close()
        
        // Create a shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        
        // Apply the shape layer to the view
        self.layer.mask = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        // Optional: You can customize further drawing here if needed
    }
}
