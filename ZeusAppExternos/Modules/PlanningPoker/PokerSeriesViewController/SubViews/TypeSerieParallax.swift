//
//  TypeSerieParallax.swift
//  LocationEKT
//
//  Created by ARIEL DIAZ on 24/11/19.
//  Copyright © 2019 Latbc. All rights reserved.
//

import UIKit
import ZeusCoreDesignSystem
class TypeSerieParallax: UIView {
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var cstLeadingIndicator: NSLayoutConstraint!
    @IBOutlet var seriesButtons: [ZDSButtonAlt]!
    
    @IBAction func btnTypeSerie(_ sender: ZDSButtonAlt) {
        cstLeadingIndicator.constant = CGFloat(sender.tag)*frame.width/3
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, options: .curveLinear, animations: {
            self.layoutIfNeeded()
            
        })
    }
    
    func setInteractiveOffset(percentage: CGFloat) {
        cstLeadingIndicator.constant = percentage*superview!.frame.width
        if percentage <= 0.333 {
            indicatorView.backgroundColor = .orangePlanningPoker
            
        } else if percentage <= 0.666 {
            indicatorView.backgroundColor = .grayPlanningPoker
            
        } else {
            indicatorView.backgroundColor = .orangePlanningPoker2
            
        }
    }
    
}
