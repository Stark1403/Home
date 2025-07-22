//
//  DetailSelectedViewController.swift
//  LocationEKT
//
//  Created by ARIEL DÍAZ on 12/23/19.
//  Copyright © 2019 Latbc. All rights reserved.
//

import UIKit
import ZeusUtils
import ZeusCoreDesignSystem
enum FlipviewSide {
    case front, rare
    
}

class DetailSelectedViewController: BaseViewController {

    @IBOutlet weak var flipContainerView: UIView!
    var rareView: UIView!
    var frontView: SeriesCellCollectionViewCell!
    var bgImageView: UIImageView!
    var buttonFlipviews: ZDSButtonAlt!
    var flipViewSide: FlipviewSide = .front
    var timeTransition: TimeInterval = 0.4
    var isFirstTime: Bool = true
    var typeSerie: TypeSerie!
    var serieItem: Int!
    var panGesture: UIPanGestureRecognizer!
    var canFlip: Bool = true
    var sideTransition: UIView.AnimationOptions!
    
    override func viewDidLoad() {
        self.udnColor = UDNSkin.global.color
        self.titleString = "Planning Poker"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonFlipviews = ZDSButtonAlt()
        panGesture = UIPanGestureRecognizer()
        rareView = UIView()
        frontView = UIView.fromNib()
        bgImageView = UIImageView()
        let imageBgImage = UIImage(named: "agile_grid_bg", in: .local, compatibleWith: nil)
        bgImageView.image = imageBgImage
        bgImageView.tintColor = .orangePlanningPoker
        rareView.addSubview(bgImageView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTime {
            isFirstTime = false
            setFlipViews()
            setData()
            
        }
    }
    
    override func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setFlipViews() {
        buttonFlipviews.frame = flipContainerView.bounds
        buttonFlipviews.addTarget(self, action: #selector(buttonFlipView(_:)), for: .touchUpInside)
        flipContainerView.addSubview(buttonFlipviews)
        
        rareView.frame = flipContainerView.bounds
        bgImageView.frame = rareView.bounds
        rareView.makeViewWith(features: [.rounded, .bordered(.orangePlanningPoker, 3)])
        flipContainerView.addSubview(rareView)
        
        frontView.frame = flipContainerView.bounds
        frontView.backgroundColor = frontView.containerView.backgroundColor
        frontView.makeViewWith(features: [.rounded, .bordered(.orangePlanningPoker, 3)])
        frontView.label.textColor = .orangePlanningPoker
        frontView.label.font = .systemFont(ofSize: 200)
        frontView.isHidden = true
        flipContainerView.addSubview(frontView)
        
        flipContainerView.addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(panGesture(_:)))
        flipContainerView.bringSubviewToFront(buttonFlipviews)
        
    }
    
    @objc func buttonFlipView(_ sender: ZDSButtonAlt) {
        switch flipViewSide {
        case .front: flipViewSide = .rare
        case .rare:  flipViewSide = .front
        }
        sideTransition = flipViewSide == .rare ? .transitionFlipFromLeft : .transitionFlipFromRight
        flipViews()
        
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: flipContainerView)
        guard canFlip else { return }
        canFlip = false
        switch flipViewSide {
        case .front: flipViewSide = .rare
        case .rare:  flipViewSide = .front
        }
        sideTransition = velocity.x > 0 ? .transitionFlipFromLeft : .transitionFlipFromRight
        flipViews()
        
    }
    
    func flipViews() {
        let transitionOptions: UIView.AnimationOptions = [sideTransition, .showHideTransitionViews]
        guard let firstViewToFlip = flipViewSide == .front ? frontView : rareView,
        let secondViewToFlip = flipViewSide == .rare ? frontView : rareView else { return }
        debugPrint(flipViewSide)
        UIView.transition(with: firstViewToFlip, duration: timeTransition, options: transitionOptions, animations: {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.timeTransition/2, execute: {
                firstViewToFlip.isHidden = true
                
            })
        })
        UIView.transition(with: secondViewToFlip, duration: timeTransition, options: transitionOptions, animations: {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.timeTransition/2, execute: {
                secondViewToFlip.isHidden = false
                
            })
        }, completion: { _ in
            self.canFlip = true
            
        })
    }
    
    func setData() {
        guard let serieItem = self.serieItem,
        let frontView = frontView else { return }
            var serie: [String]!
            var color: UIColor!
            switch typeSerie {
            case .standard:
                serie = standarSerie
                color = serieItem%2 == 0 ? .orangePlanningPoker : .orangePlanningPoker2
                
            case .fibonacci:
                serie = fibonacciSerie
                color = serieItem%2 == 0 ? .grayPlanningPoker : .orangePlanningPoker
                
            default:
                serie = naturalSerie
                color = serieItem%2 == 0 ? .orangePlanningPoker2 : .grayPlanningPoker2
                
            }
            frontView.makeViewWith(features: [.rounded, .bordered(color, 3)])
            if let image = imageDic[serie[serieItem]] {
                frontView.image.tintColor = color
                frontView.image.image = image
                frontView.label.isHidden = true
                
            } else {
                frontView.label.text = "\(serie[serieItem])"
                frontView.label.textColor = color
                
            }
    }

}
