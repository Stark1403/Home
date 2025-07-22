//
//  SlideViewController.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 07/09/23.
//

import Foundation
import UIKit
import ZeusCoreInterceptor
class SlideViewController: UIView, ZCInterceptorDelegate {
    func didFailToEnterFlow(error: NSError) {
        
    }
    
    public var margin: CGFloat = 80.0
    public var contentView = UIView()
    public var direction = UIViewController.SlideDirection.right
    private let transparentView = UIView()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func dismissMenu(animated: Bool) {
        if animated {
            
            if let sideMenuBackView = UIApplication.shared.sideMenuBackView{
                UIView.animate(withDuration: 0.40) {
                    sideMenuBackView.alpha = 0
                } completion: { _ in
                    sideMenuBackView.removeFromSuperview()
                }
            }
            
            UIView.animate(withDuration: 0.30, animations: { [weak self] in
                self?.performDismissActivities()
            }) { [weak self] _ in
                if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
                    slideView.removeFromSuperview()
                }
            }
        } else {
            performDismissActivities()
            if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
                slideView.removeFromSuperview()
                slideView.shadowGray.alpha = 0
            }
            if let sideMenuBackView = UIApplication.shared.sideMenuBackView{
                sideMenuBackView.alpha = 0
                sideMenuBackView.removeFromSuperview()
            }
        }
    }
        
    func performDismissActivities() {
        let width = UIScreen.main.bounds.width        
        let translation = direction == .right ? width : -width + margin
        self.transform = CGAffineTransform(translationX: translation, y: 0.0)
    }
    
    @objc
    public func onReturnToParent() {
        dismissMenu(animated: true)
    }
    
    public func showMyProfile(){
        
        ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.myProfile, navigateDelegate: self)
    }
    
    var leadingMargin: CGFloat {
        direction == .right ? margin : 0.0
    }
    
    var trailingMargin: CGFloat {
        direction == .right ? 0.0 : margin * -1
    }
    
    private func configureConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        addSubview(transparentView)
        
        contentView.layer.cornerRadius = 50
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner]
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onReturnToParent))
        transparentView.addGestureRecognizer(tapGestureRecognizer)
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onReturnToParent))
        swipeGestureRecognizer.direction = direction == .right ? .right : .left
        addGestureRecognizer(swipeGestureRecognizer)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingMargin),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingMargin),
            
            transparentView.topAnchor.constraint(equalTo: self.topAnchor),
            transparentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        if direction == .right {
            NSLayoutConstraint.activate([
                transparentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                transparentView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor)
            ])
        } else {
             NSLayoutConstraint.activate([
                transparentView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor),
                transparentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }
}

