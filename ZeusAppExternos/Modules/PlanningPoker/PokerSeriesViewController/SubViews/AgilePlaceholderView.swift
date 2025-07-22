//
//  AgilePlaceholderView.swift
//  LocationEKT
//
//  Created by ARIEL DÍAZ on 9/12/19.
//  Copyright © 2019 Latbc. All rights reserved.
//

import UIKit
import ZeusCoreDesignSystem
class AgilePlaceholderView: UIView {
    
    @IBOutlet weak var imageBgView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnRetry: ZDSButtonAlt!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgViewColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnRetry.isHidden = true
        activityView.color = .gsColor
        lblDescription.text = ""
        btnRetry.makeViewWith(features: [.rounded, .bordered(.gsColor, 2)])
        imageView.isHidden = true
        
    }
    
    func set(with image: UIImage, color: UIColor, description: String) {
        bgViewColor.backgroundColor = color
        bgViewColor.makeViewWith(features: [.roundedView(.full, .clear)])
        imageView.isHidden = false
        imageView.image = image
        activityView?.stopAnimating()
        activityView.isHidden = true
        lblDescription.text = description
        lblDescription.font = UIFont(style: .bodyTextL(variant: .semiBold, isItalic: false))
        if #available(iOS 13.0, *) {
            lblDescription.textColor = .label
            
        } else {
            lblDescription.textColor = .gray
            
        }
        btnRetry.isHidden = true
        
    }
    
    func set(with image: UIImage, color: UIColor, description: String, retryAction: Bool) {
        bgViewColor.backgroundColor = color
        bgViewColor.makeViewWith(features: [.roundedView(.full, .clear)])
        imageView.isHidden = false
        imageView.image = image
        activityView?.stopAnimating()
        activityView.isHidden = true
        lblDescription.text = description
        lblDescription.font = UIFont(style: .bodyTextL(variant: .semiBold, isItalic: false))
        if #available(iOS 13.0, *) {
            lblDescription.textColor = .label
            
        } else {
            lblDescription.textColor = .gray
            
        }
        btnRetry.isHidden = !retryAction
        
    }
    
    func set(with image: UIImage, color: UIColor, description: NSAttributedString) {
        bgViewColor.backgroundColor = color
        bgViewColor.makeViewWith(features: [.roundedView(.full, .clear)])
        imageView.isHidden = false
        imageView.image = image
        activityView?.stopAnimating()
        activityView.isHidden = true
        lblDescription.attributedText = description
        lblDescription.font = UIFont(style: .bodyTextL(variant: .semiBold, isItalic: false))
        if #available(iOS 13.0, *) {
            lblDescription.textColor = .label
            
        } else {
            lblDescription.textColor = .gray
            
        }
        btnRetry.isHidden = true
        
    }
    
}

// MARK: Additional methods
extension AgilePlaceholderView {
    
    func setPlaceholder(with message: String?) {
        activityView.stopAnimating()
        guard let message = message else {
            removeFromSuperview()
            return
            
        }
        activityView?.alpha = 0
        btnRetry?.isHidden = false
        lblDescription?.text = message
        
    }
    
    func setPlaceHolder(with image: UIImage) {
        imageBgView.image = image
        activityView.isHidden = true
        lblDescription.isHidden = true
        btnRetry.isHidden = true
        imageView.isHidden = true
        bgViewColor.isHidden = true
        
    }
    
}
