//
//  AddMyContacsViewController.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 27/09/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
import SwiftUI
import ZeusCoreInterceptor
class AddMyContacsViewController: ZDSUDNViewController, ZDSDropdownViewDelegate {
    func dropdown(_ view: ZeusCoreDesignSystem.ZDSDropdownView, didSelect item: ZeusCoreDesignSystem.ZDSDropdownViewCell.Model) {
        contactSiblingTF.selectedItem = item
        self.willEnableButton()
    }
    
    func dropdownPresentedVC() -> UIViewController {
        self
    }

    lazy var contactNameTF: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "Nombre"
        tf.maxWidth = 50
        tf.allowedCharacters = CharacterSet.letters.union(.whitespaces)
        tf.showCharCounter = false
        return tf
    }()
    
    lazy var contactNameView: UIView = {
        let tf = contactNameTF.asUIKitView()
        tf.isHidden = false
        return tf
    }()
    
    lazy var contactSurnameTF: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "Apellido"
        tf.maxWidth = 50
        tf.allowedCharacters = CharacterSet.letters.union(.whitespaces)
        tf.showCharCounter = false
        return tf
    }()
    
    lazy var contactSurnameView: UIView = {
        let tf = contactSurnameTF.asUIKitView()
        tf.isHidden = false
        return tf
    }()
    
    lazy var contactSiblingTF: ZDSDropdownView = {
        let dd = ZDSDropdownView()
        dd.hint = "Parentesco"
        dd.anchor = .bottom
        dd.delegate = self
        dd.data = [
            .init(id: "1", text: "Padre"),
            .init(id: "2", text: "Madre"),
            .init(id: "3", text: "Hermano/a"),
            .init(id: "4", text: "Cónyuge/Pareja"),
            .init(id: "5", text: "Tío/a"),
            .init(id: "6", text: "Primo/a"),
            .init(id: "7", text: "Cuñado/a"),
            .init(id: "8", text: "Otro"),
        ]
        return dd
    }()
    
    lazy var contactPhoneTF: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "No. Teléfono"
        tf.keyboardType = .numberPad
        tf.maxWidth = 10
        tf.showCharCounter = false
        return tf
    }()
    
    lazy var contactPhoneView: UIView = {
        return contactPhoneTF.asUIKitView()
    }()
    
    lazy var contactPhoneContainerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        let indicatorView = NumberIndicatorView()
        indicatorView.setupConstraints(shouldShrinkView: true)
        [indicatorView, contactPhoneView].forEach{ sv.addArrangedSubview($0) }
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.widthAnchor.constraint(equalToConstant: 80),
        ])
        return sv
    }()
    
    lazy var contactInputsSV: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 15
        [contactNameView, contactSurnameView, contactSiblingTF, contactPhoneContainerView].forEach {sv.addArrangedSubview($0)}
        return sv
    }()
    
    lazy var addContactsBtn: ZDSButton = {
        var btn = ZDSButton()
        btn.style = .primary
        btn.setTitle("Agregar contacto", for: .normal)
        btn.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .purple
        btn.disabled = true
        return btn
    }()
    
    lazy var addContactsBtnView: UIView = {
        let btn = addContactsBtn.asUIKitView()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var contactData: SendMyContactsRequestPath?
    var presenter: MyContactsPresenterProtocol?
    var savedContactCallBack: ((_ contact: SendMyContactsResponse) -> Void)? = nil
    var updatedContactCallBack: ((_ contact: SendMyContactsResponse) -> Void)? = nil
    
    var isEditingContact: Bool = false
    var editingContact: SendMyContactsResponse?
    override func viewDidLoad() {
        headerColor = SessionInfo.shared.company?.primaryUIColor
        style = .statusAndNavBarStyle(.small)
        view.backgroundColor = .white
        if isEditingContact {
            titleString = "Editar contacto"
            EditEmergencyContactEvents.shared.sendEvent(.view)
        } else {
            titleString = "Agregar contacto"
            AddEmergencyContactEvents.shared.sendEvent(.view)
        }
        super.viewDidLoad()
        setupContraints()
        setupListeners()
        self.hideKeyboardWhenTappedAround()
        if isEditingContact {
            setupEditingContact()
            addContactsBtn.onClick = {
                EditEmergencyContactEvents.shared.sendEvent(.actionButton)
                guard let zeusId = SessionInfo.shared.user?.zeusId else {
                    return }
                
                self.contactData = SendMyContactsRequestPath(idColaborador: zeusId, emergencyContact: [EmergencyContactPost(id: self.editingContact?.id ?? 0, name: self.contactNameTF.text, surnames: self.contactSurnameTF.text, relationship: Int(self.contactSiblingTF.selectedItem?.id ?? "") ?? 0, phone: self.contactPhoneTF.text, status: 1)])
                
                guard let contactData = self.contactData else {return}
                if self.isValidPhoneNumber(self.contactPhoneTF.text) {
                    self.contactPhoneTF.helpText = ""
                    self.presenter?.updateContact(contactData: contactData)
                } else {
                    self.contactPhoneTF.state = .error
                    self.contactPhoneTF.helpText = "Ingresa un No. Teléfono válido"
                }
            }
        } else {
            addContactsBtn.onClick = {
                AddEmergencyContactEvents.shared.sendEvent(.actionButton)
                guard let zeusId = SessionInfo.shared.user?.zeusId else {
                    return }
                
                self.contactData = SendMyContactsRequestPath(idColaborador: zeusId, emergencyContact: [EmergencyContactPost(id: 0, name: self.contactNameTF.text, surnames: self.contactSurnameTF.text, relationship: Int(self.contactSiblingTF.selectedItem?.id ?? "") ?? 0, phone: self.contactPhoneTF.text, status: 1)])
                

                guard let contactData = self.contactData else {return}
                
                if self.isValidPhoneNumber(self.contactPhoneTF.text) {
                    self.contactPhoneTF.helpText = ""
                    self.presenter?.saveContactData(contactData: contactData)
                } else {
                    self.contactPhoneTF.state = .error
                    self.contactPhoneTF.helpText = "Ingresa un No. Teléfono válido"
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isEditingContact {
            addContactsBtn.disabled = true
        }
    }
 
    private func setupEditingContact(){
        contactNameTF.text = editingContact?.name ?? ""
        contactPhoneTF.text = editingContact?.phone ?? ""
        contactSurnameTF.text = editingContact?.surnames ?? ""
        contactSiblingTF.setupItem(ZDSDropdownViewCell.Model(id: "\(editingContact?.relationship?.id ?? 0)", text: editingContact?.relationship?.description ?? ""))
        contactSiblingTF.state = .selected
        addContactsBtn.title = "Editar contacto"
        addContactsBtn.disabled = true
    }
    
    private func setupListeners(){
        contactNameTF.onChanged = { [weak self] text in
            guard let self = self else {return}
                if self.isEditingContact {
                    if self.validateChangesMade() {
                        self.willEnableButton()
                    } else {
                        self.addContactsBtn.disabled = true
                    }
                } else {
                    self.willEnableButton()
                }
            
        }
        
        contactPhoneTF.onChanged = { [weak self] text in
            guard let self = self else {return}
            if isValidPhoneNumber(text) {
                if self.isEditingContact {
                    if self.validateChangesMade() {
                        self.willEnableButton()
                    } else {
                        self.addContactsBtn.disabled = true
                    }
                } else {
                    self.willEnableButton()
                }
                contactPhoneTF.state = .none
                contactPhoneTF.helpText = nil
            }else{
                contactPhoneTF.state = .error
                contactPhoneTF.helpText = "Ingresa un No. Teléfono válido"
            }
        }
        
        contactSurnameTF.onChanged = { [weak self] text in
            guard let self = self else {return}
            if self.isEditingContact {
                if self.validateChangesMade() {
                    self.willEnableButton()
                } else {
                    self.addContactsBtn.disabled = true
                }
            } else {
                self.willEnableButton()
            }
        }
    }
    
    private func validateChangesMade() -> Bool {
        if editingContact?.name == self.contactNameTF.text, editingContact?.surnames == self.contactSurnameTF.text, editingContact?.relationship?.id == Int(self.contactSiblingTF.selectedItem?.id ?? "") ?? 0, self.editingContact?.phone == self.contactPhoneTF.text {
            
            return false
        }
        
        return true
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // Define a regular expression pattern for a valid phone number
        let phoneRegex = "^(\\+\\d{1,3})?\\s?\\d{3}[\\s.-]?\\d{3}[\\s.-]?\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    private func setupContraints(){
        view.addSubview(contactInputsSV)
        view.addSubview(addContactsBtnView)
        
        NSLayoutConstraint.activate([
            contactInputsSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            contactInputsSV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contactInputsSV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addContactsBtnView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addContactsBtnView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addContactsBtnView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addContactsBtnView.heightAnchor.constraint(equalToConstant: 40),
        ])
        
    }
    
    private func willEnableButton(){
        if contactNameTF.text != "", contactSurnameTF.text != "", contactSiblingTF.selectedItem?.text != nil ,contactPhoneTF.text != ""{
            addContactsBtn.disabled = false
        } else {
            addContactsBtn.disabled = true
        }
    }
    
    private func showExitAlert(){
        var alert = ZDSAlert()
        alert.primaryColor = headerColor ?? .purple
        alert.title = "¿Está seguro de salir?"
        alert.message = "Al realizar esta acción se perderá todo su \nprogreso."
        alert.primaryTitle = "Sí, salir"
        alert.secondaryTitle = "Cancelar"
        alert.style = .alert
//        alert.buttonsDistribution = .vertical
        
        let view = alert.asUIKitViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.modalTransitionStyle = .crossDissolve
        view.view.backgroundColor = .backgroundTransparency
        
        alert.onPrimaryAction = {
            self.exitView()
            view.dismiss(animated: true)
        }
        alert.onSecundaryAction = {
            view.dismiss(animated: true)
        }
        self.present(view, animated: true) {}
    }
    
    private func failAlert(){
        var alert = ZDSAlert()
        alert.primaryColor = headerColor ?? .purple
        alert.title = "¡Oops! Algo pasó"
        alert.message = "La acción no se pudo completar correctamente. Inténtalo de nuevo."
        alert.primaryTitle = "Aceptar"
        
        alert.style = .error
        alert.buttonsDistribution = .horizontal
        
        let view = alert.asUIKitViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.modalTransitionStyle = .crossDissolve
        view.view.backgroundColor = .backgroundTransparency
        
        alert.onPrimaryAction = {
            view.dismiss(animated: true)
        }
        
        self.present(view, animated: true) {}
    }
    
    private func exitView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        style = .statusAndNavBarStyle(.small)
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func backAction() {
        if self.isEditingContact {
            EditEmergencyContactEvents.shared.sendEvent(.back)
            if self.validateChangesMade() {
                self.showExitAlert()
            } else {
                exitView()
            }
        } else {
            AddEmergencyContactEvents.shared.sendEvent(.back)
            if contactNameTF.text != "" || contactSurnameTF.text != "" || contactSiblingTF.selectedItem?.text != nil || contactSiblingTF.hint != "Parentesco" || contactPhoneTF.text != ""{
                self.showExitAlert()
            } else {
                exitView()
            }
        }
    }
}


extension AddMyContacsViewController: MyContactsViewProtocol {
    func didSaveData(contact: SendMyContactsResponse) {
        if isEditingContact {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.updatedContactCallBack?(contact)
                self?.exitView()
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.savedContactCallBack?(contact)
                self?.exitView()
            })
        }
    }
    
    func didFailSave() {
        failAlert()
    }
    
    func showLoader() {
        showDSLoader()
    }
    
    func hideLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.hideDSLoader()
        })
    }
    
    
    
}
