//
//  NewHomeWaveView.swift
//  zeusAPP
//
//  Created by DSI Soporte Tecnico on 11/06/24.
//  Copyright © 2024 UPAX. All rights reserved.
//

import Foundation
import UIKit
import ZeusSessionInfo

class NewHomeWaveView: UIView {
    
    var color = SessionInfo.shared.company?.primaryUIColor ?? UIColor.yellow
    var xLine: CGFloat = 0.24
    var xCurveTo: CGFloat = 0.4
    var xControlPoint: CGFloat = 0.3
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        getValueForItems()
        createWaveShape()
    }
    
    public func reload(framer: CGRect) {
        self.frame = frame
    }

    public func createWaveShape() {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        layoutIfNeeded()
    
        let layer = CAShapeLayer()

        let width = self.frame.size.width
        let height = self.frame.size.height
        
        guard width > 0 && height > 0 else { return }
        
        let path = UIBezierPath()
        
        path.move(to: .zero)
        path.addQuadCurve(to: CGPoint(x: 23.75, y: 16),
                          controlPoint:
                            CGPoint(
                                x: 21.45,
                                y: 3.95
                            )
        )
        path.addLine(to: CGPoint(x: width * xLine, y: height * 0.8))
        
        path.addQuadCurve(to: CGPoint(x: width * xCurveTo, y: height),
                          controlPoint:
                            CGPoint(
                                x: (width * xControlPoint),
                                y: (height)
                            )
        )
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.close()
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: path.bounds.origin.x, y: path.bounds.origin.y, width: path.bounds.width, height: path.bounds.height)
        gradient.colors = [color.cgColor, color.cgColor]
        
        layer.path = path.cgPath
        layer.fillColor = color.cgColor
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask
        
        self.layer.addSublayer(layer)
        self.layer.addSublayer(gradient)
    }
    
    func getValueForIndividualItem() {
        xLine = 0.3
        xCurveTo = 0.46
        xControlPoint = 0.3
      
    }
    func getValueForItems() {
        xLine = 0.24
        xCurveTo = 0.4
        xControlPoint = 0.3
    }
}
