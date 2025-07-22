//
//  NewHeaderHomeView.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 16/05/24.
//
import UIKit
import ZeusSessionInfo

class RectangleHeaderHomeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        setupLayers()
    }
    
    private func setupLayers() {
        let rectangleLayer = CALayer()
        rectangleLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: screenFrame.height * 0.12)
        rectangleLayer.backgroundColor = SessionInfo.shared.company?.primaryUIColor.cgColor ?? UIColor.clear.cgColor
        layer.addSublayer(rectangleLayer)
        
    }
}
