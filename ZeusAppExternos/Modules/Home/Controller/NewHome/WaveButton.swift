//
//  WaveButton.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 09/07/24.
//

import UIKit

class WaveButton: UIButton {
    private let animationDuration: CFTimeInterval = 3.0
    private let waveCount = 3

    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        setupButton(with: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Configura con una imagen por defecto si se usa el inicializador coder
        setupButton(with: UIImage())
    }
    
    private func setupButton(with image: UIImage) {
        self.backgroundColor = .blue
        self.layer.cornerRadius = self.bounds.height / 2
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        // Centrar la imagen dentro del botón
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.5),
            imageView.heightAnchor.constraint(equalToConstant: self.bounds.height * 0.5)
        ])
    }
    
    func startWaveAnimation() {
        for i in 0..<waveCount {
            let waveLayer = createWaveLayer()
            self.layer.addSublayer(waveLayer)
            waveLayer.add(createWaveAnimation(beginTime: CFTimeInterval(i) * (animationDuration / CFTimeInterval(waveCount))), forKey: "waveAnimation")
        }
    }
    
    private func createWaveLayer() -> CAShapeLayer {
        let waveLayer = CAShapeLayer()
        waveLayer.frame = self.bounds
        waveLayer.path = UIBezierPath(ovalIn: self.bounds).cgPath
        waveLayer.fillColor = self.backgroundColor?.cgColor
        waveLayer.opacity = 0.0
        return waveLayer
    }
    
    private func createWaveAnimation(beginTime: CFTimeInterval) -> CAAnimationGroup {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 2.0

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.5
        opacityAnimation.toValue = 0.0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = animationDuration
        animationGroup.beginTime = beginTime
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animationGroup.repeatCount = 1
        
        return animationGroup
    }
}
