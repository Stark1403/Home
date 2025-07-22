//
//  CircularButton.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 16/05/24.
//

import UIKit
import ZeusUtils

class CircularButton: UIButton {
    var hasWave = false
    var onClick: () -> Void = {}
    var iconImageView: UIImageView?

    init(frame: CGRect, iconName: String) {
        super.init(frame: frame)
        setupButton(iconName: iconName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton(iconName: "")
    }
    
    func setupButton(iconName: String) {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.clipsToBounds = true
    
        iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width * 0.5, height: self.bounds.size.width * 0.5))
        iconImageView?.contentMode = .scaleAspectFit
        iconImageView?.tintColor = UIColor.white
        
        if let iconImage = UIImage(named: iconName) {
            iconImageView?.image = iconImage
        } else {
            print("Icono no encontrado")
        }
        
        // Centrar el icono dentro del botón
        iconImageView?.translatesAutoresizingMaskIntoConstraints = false
        if let iconImageView = iconImageView {
            self.addSubview(iconImageView)
            NSLayoutConstraint.activate([
                iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: self.bounds.size.width * 0.5),
                iconImageView.heightAnchor.constraint(equalToConstant: self.bounds.size.width * 0.5)
            ])
        }
        
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    func setShimmer() {
        iconImageView?.isHidden = true
        self.isUserInteractionEnabled = false
    }
    
    func hideShimmer() {
        self.isUserInteractionEnabled = true
        iconImageView?.isHidden = false
    }
    
    @objc private func buttonClicked() {
        onClick()
        if hasWave {
            startWaveAnimation()
        }
    }
    
    func setImage(iconName: String) {
        if let iconImage = UIImage(named: iconName) {
            iconImageView?.image = iconImage
        } else {
            print("Icono no encontrado")
        }
    }
    
    func startWaveAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.7
        animation.toValue = 1.2
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        self.layer.add(animation, forKey: "pulsing")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.layer.removeAnimation(forKey: "pulsing")
        }
    }

}
