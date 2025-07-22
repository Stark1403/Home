//
//  Alerts.swift
//  ZeusAppExternos
//
//  Created by Satori Tech 209 on 12/31/24.
//
import Foundation
import ZeusCoreDesignSystem
extension MyPrivateDataViewController {
    func goOutAlert(){
        MyPrivateDataEvents.shared.sendEvent(.screenAlert)
        var alert = ZDSAlert()
        
        alert.primaryColor = headerColor ?? .purple
        alert.title = "¿Está seguro de salir de edición?"
        alert.message = "Al realizar esta acción se perderá todo su progreso."
        alert.primaryTitle = "Sí, salir"
        alert.secondaryTitle = "Seguir editando"
        alert.style = .alert
        
        let view = alert.asUIKitViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.modalTransitionStyle = .crossDissolve
        view.view.backgroundColor = .backgroundTransparency
        alert.onPrimaryAction = {
            MyPrivateDataEvents.shared.sendEvent(.goOut)
            self.editAlert = false
            view.dismiss(animated: true)
            self.backAction()
        }
        alert.onSecundaryAction = {
            MyPrivateDataEvents.shared.sendEvent(.keepEditing)
            view.dismiss(animated: true)
        }
        
        self.present(view, animated: true) {}
    }
    
    
    func OopsAlert(){
        MyPrivateDataEvents.shared.sendEvent(.screenAlertError)
        var alert = ZDSAlert()
        alert.primaryColor = headerColor ?? .purple
        alert.title = "¡Oops! Algo pasó"
        alert.message = "La acción no se pudo completar correctamente. Inténtalo de nuevo."
        alert.primaryTitle = "Aceptar"
        alert.style = .error
        
        let view = alert.asUIKitViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.modalTransitionStyle = .crossDissolve
        view.view.backgroundColor = .backgroundTransparency
        alert.onPrimaryAction = {
            MyPrivateDataEvents.shared.sendEvent(.acceptError)
            view.dismiss(animated: true)
            self.backAction()
        }
        self.present(view, animated: true) {}
    }
}
