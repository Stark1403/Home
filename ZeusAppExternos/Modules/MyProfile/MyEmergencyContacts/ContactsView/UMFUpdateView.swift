//
//  UMPUpdateView.swift
//  ZeusAppExternos
//
//  Created by Satoritech 140 on 10/01/25.
//

import Foundation
import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
import SwiftUI

protocol UMFUpdateViewDelegate {
    func setUMF(num: String)
}

class UMFUpdateView: UIViewController {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = .black
        view.alpha = 0.0
        view.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(activateDismissAnimation))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var decorativeNotchIv: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "decorativeNotch")
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.font = UIFont(style: .bodyTextXL(variant: .bold, isItalic: false))
        lbl.text = "Editar número UMF"
        lbl.textColor = UIColor(hexString: "#393647")
        return lbl
    }()
    
    lazy var closeViewButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(materialIcon: .close), for: .normal)
        btn.tintColor = .black900
        btn.addTarget(self, action: #selector(activateDismissAnimation), for: .touchUpInside)
        return btn
    }()
    
    lazy var saveButton: ZDSButton = {
        var button = ZDSButton()
        button.style = .primary
        button.setTitle("Guardar cambios", for: .normal)
        button.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .purple
        button.disabled = true
        return button
    }()
    
    lazy var saveButtonView: UIView = {
        return saveButton.asUIKitView()
    }()
    
    lazy var umfTextField: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "Número de Unidad Médica Familiar"
        tf.keyboardType = .numberPad
        tf.text = UMFdata.titleInt
        return tf
    }()
    
    lazy var umfTextFieldView: UIView = {
        return umfTextField.asUIKitView()
    }()
    
    let delegate: UMFUpdateViewDelegate?
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    private var myWindow: UIWindow?
    
    var UMFdata: UMFdata
    
    init(UMFdata: UMFdata, delegate: UMFUpdateViewDelegate){
        self.UMFdata = UMFdata
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmergencyUMFPolizaEvents.shared.sendEvent(.screenEdit)
        setupConstraints()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.containerView.frame.origin
        }
    }
    
    private func setupGestures() {
        saveButton.onClick = {
            self.activateDismissAnimation()
            self.delegate?.setUMF(num: self.umfTextField.text)
        }
        
        umfTextField.onChanged = { [weak self] text in
            EmergencyUMFPolizaEvents.shared.sendEvent(.edit)
            self?.validateNumber()
        }
    }
    
    func validateNumber(){
        let number = umfTextField.text
        if number.count < 1 {
            saveButton.disabled = true
        }else{
            saveButton.disabled = false
        }
    }
    
    func openModule(){
        myWindow = UIWindow(frame: UIScreen.main.bounds)
        myWindow?.windowLevel = UIWindow.Level.alert
        myWindow?.backgroundColor = UIColor.clear
        myWindow?.rootViewController = self
        myWindow?.isHidden = false
        
        shadowView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.shadowView.alpha = 0.4
        }
        containerView.transform = CGAffineTransform(translationX: 0.0, y: UIScreen.main.bounds.height)
        var height: CGFloat = 0.0
        height = UIScreen.main.bounds.height - 229
        UIView.animate(withDuration: 0.40) {
            self.containerView.transform = CGAffineTransform(translationX: 0.0, y: height)
        }
    }
    
    private func setupConstraints(){
        containerView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        containerView.addGestureRecognizer(panGesture)
        
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(shadowView)
        view.addSubview(containerView)
        containerView.addSubview(decorativeNotchIv)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeViewButton)
        containerView.addSubview(umfTextFieldView)
        containerView.addSubview(saveButtonView)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: view.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - 50),
            
            decorativeNotchIv.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            decorativeNotchIv.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            decorativeNotchIv.heightAnchor.constraint(equalToConstant: 4),
            decorativeNotchIv.widthAnchor.constraint(equalToConstant: 64),
            
            closeViewButton.topAnchor.constraint(equalTo: decorativeNotchIv.bottomAnchor, constant: 16),
            closeViewButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeViewButton.heightAnchor.constraint(equalToConstant: 24),
            closeViewButton.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: decorativeNotchIv.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: closeViewButton.leadingAnchor, constant: -10),
            
            umfTextFieldView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            umfTextFieldView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            umfTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            umfTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            saveButtonView.topAnchor.constraint(equalTo: umfTextFieldView.bottomAnchor, constant: 22),
            saveButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
    
    @objc private func activateDismissAnimation(){
        EmergencyUMFPolizaEvents.shared.sendEvent(.closeEdit)
        UIView.animate(withDuration: 0.4) {
            self.shadowView.alpha = 0.0
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            },
            completion: { _ in
                self.myWindow = nil
            }
        )
    }
    
    @objc private func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
        
        containerView.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                activateDismissAnimation()
            } else {
                let heightToDismiss = UIScreen.main.bounds.height - 312
                guard translation.y <= heightToDismiss else {
                    activateDismissAnimation()
                    return
                }
                UIView.animate(withDuration: 0.3) {
                    self.containerView.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
