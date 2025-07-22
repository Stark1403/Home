//
//  DeactivateBiometricsAlert.swift
//  ZeusAppExternos
//
//  Created by Karen Irene Arellano Barrientos on 04/07/24.
//

import Foundation
import ZeusCoreDesignSystem
import ZeusSessionInfo

class DeactivateBiometricsAlertView: UIView {
    var cancelCallBack: (() -> Void)? = nil
    var aceptCallBack: (() -> Void)? = nil
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func get(on keyWindow: UIView, tag: Int) -> DeactivateBiometricsAlertView {
        var alert = ZDSAlert()
        alert.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .blue
        alert.title = "Desactivar datos biométricos"
        alert.message = "Si desactivas el acceso con datos biométricos solo podrás ingresar a la app con tu contraseña."
        alert.secondaryTitle = "Cancelar"
        alert.primaryTitle = "Desactivar"
        
        let view = alert.asUIKitView()
        
        let customView = DeactivateBiometricsAlertView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        customView.addSubview(view)
        
        // Desactivar biométricos
        alert.onPrimaryAction = {
            customView.aceptCallBack?()
        }
        
        // Acción de cancelar
        alert.onSecundaryAction = {
            customView.cancelCallBack?()
        }
        
        let frame = keyWindow.frame 
        customView.isHidden = true
        customView.frame = frame
        customView.tag = tag
        customView.layer.zPosition = 100_011
        keyWindow.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: keyWindow.topAnchor),
            customView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
            
            view.topAnchor.constraint(equalTo: customView.topAnchor),
            view.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: customView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: customView.bottomAnchor),
        ])
        
        return customView
    }
}

class ActivateBiometricsAlertView: UIView {
    var cancelCallBack: (() -> Void)? = nil
    var aceptCallBack: (() -> Void)? = nil
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func get(on keyWindow: UIView, tag: Int) -> ActivateBiometricsAlertView {
        var alert = ZDSAlert()
        alert.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .blue
        alert.title = "Biométricos no disponibles."
        alert.message = "¿Deseas ir a la configuración de tu dispositivo para activarlos ahora?"
        alert.secondaryTitle = "No"
        alert.primaryTitle = "Si"
        
        let view = alert.asUIKitView()
        
        let customView = ActivateBiometricsAlertView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        customView.addSubview(view)
        
        // Desactivar biométricos
        alert.onPrimaryAction = {
            customView.aceptCallBack?()
        }
        
        // Acción de cancelar
        alert.onSecundaryAction = {
            customView.cancelCallBack?()
        }
        
        let frame = keyWindow.frame
        customView.isHidden = true
        customView.frame = frame
        customView.tag = tag
        customView.layer.zPosition = 100_011
        keyWindow.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: keyWindow.topAnchor),
            customView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
            
            view.topAnchor.constraint(equalTo: customView.topAnchor),
            view.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: customView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: customView.bottomAnchor),
        ])
        
        return customView
    }
}

