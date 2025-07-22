//
//  BadgeUILabel.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 02/08/23.
//

import Foundation
import UIKit

class BadgeUILabel: UILabel {
    
    var badgeValue: Int {
        didSet {
            /*  MARK: this line will be add in the future.
            text = badgeValue >= 100 ? "99+" : badgeValue.description
            */
            text = ""
            self.isHidden = badgeValue == 0 ? true : false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.badgeValue = 0
        super.init(coder: aDecoder)
        initializeLabel()
    }
    
    override init(frame: CGRect) {
        self.badgeValue = 0
        super.init(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        initializeLabel()
    }
    
    func initializeLabel(){
        self.badgeValue = 0
        self.isHidden = badgeValue == 0 ? true : false
        self.text = badgeValue.description
        self.textAlignment = .center
        self.font = UIFont(style: .bodyTextXS())
        self.backgroundColor = UIColor.red
        self.textColor = UIColor.white
        self.makeItCircular()
    }
    
    func setColorBadge(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    func incrementBadge() {
        self.badgeValue += 1
    }
    
    func setBadge(value: Int) {
        self.badgeValue = value
    }
    
    func decrementBadge() {
        self.badgeValue -= 1
    }
    
    func clearBadge() {
        self.badgeValue = 0
    }
}

