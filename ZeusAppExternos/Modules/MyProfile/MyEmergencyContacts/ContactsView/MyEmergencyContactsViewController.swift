//
//  MyEmergencyContactsViewController.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 24/09/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
import SwiftUI
import UPAXNetworking
import ZeusKeyManager

#warning("Organizar código para que cumpla con los estándares de calidad - (VIPER)")
class MyEmergencyContactsViewController: ZDSUDNViewController {

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F5F5F7")
        return view
    }()
    
    lazy var addContactsBtn: ZDSButton = {
        var btn = ZDSButton()
        btn.style = .primary
        btn.setTitle("Agregar contacto", for: .normal)
        btn.icon = Image(materialIcon: .add, fill: false)
        btn.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .purple
        
        return btn
    }()
    
    lazy var addContactsBtnView: UIView = {
        let btn = addContactsBtn.asUIKitView()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var emptyContactsView: EmptyContactsView = {
        let view = EmptyContactsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var segmentedController: ZDSSegmentedController = {
        let sc = ZDSSegmentedController()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.numberOfSegments = 2
//        sc.segmentsTitle = "Familiares, Unidad medica"
        sc.segmentsTitle = "Familiares,UMF/Pólizas"
        sc.currentIndexTitleColor = SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor ?? .purple
        sc.otherIndexTitleColor = UIColor(hexString: "#393647")
        sc.currentIndexBackgroundColor = SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor ?? .purple
        sc.didTapSegment = onSegmentedValueChanged
        return sc
    }()
    
    lazy var contactsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        tv.selectionFollowsFocus = false
        tv.allowsSelection = false
        tv.register(MyContactCell.self, forCellReuseIdentifier: MyContactCell.identifier)
        tv.register(UMFCell.self, forCellReuseIdentifier: UMFCell.identifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    var currentUserSelected: SendMyContactsResponse?
    var UMF: [UMFdata] = []
    
    var myContactsList: [SendMyContactsResponse] = []
    private let networking = ZeusV2NetworkManager.shared.networking
    override func viewDidLoad() {
        view.backgroundColor = .white
        headerColor = SessionInfo.shared.company?.primaryUIColor
        navigationBarColor = .white
        style = .statusAndNavBarStyle(.medium)
        backString = "Mi cuenta"
        titleString = "Contactos de emergencia"
        super.viewDidLoad()
        EmergencyViewEvents.shared.sendEvent(.screenView)
        setupConstraints()
        
        getContacts()
        
        addContactsBtn.onClick = {
            EmergencyContactsEvents.shared.sendEvent(.addContact)
            let vc = AddMyContactsRouter.createModule()
            vc.savedContactCallBack = self.onSavedContactCallBack
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    var tabBarIndex = 0
    
    override func viewWillDisappear(_ animated: Bool) {
        style = .statusAndNavBarStyle(.small)
        navigationController?.navigationBar.prefersLargeTitles = false
        titleString = ""
        super.viewWillDisappear(animated)
        ZDSToastManager.shared.hideAllToast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func backAction() {
        EmergencyViewEvents.shared.sendEvent(.back)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints(){
        view.addSubview(containerView)
        containerView.addSubview(segmentedController)
        containerView.addSubview(contactsTableView)
        containerView.addSubview(emptyContactsView)
        containerView.addSubview(addContactsBtnView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            segmentedController.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            segmentedController.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            segmentedController.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            addContactsBtnView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            addContactsBtnView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            addContactsBtnView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addContactsBtnView.heightAnchor.constraint(equalToConstant: 40),
            
            emptyContactsView.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 30),
            emptyContactsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emptyContactsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            emptyContactsView.bottomAnchor.constraint(equalTo: addContactsBtnView.topAnchor, constant: 0),
            
            contactsTableView.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 16),
            contactsTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contactsTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            contactsTableView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func validateButton(){
        emptyContactsView.isHidden = !(self.myContactsList.count <= 0)
        
        if self.myContactsList.count >= 3 {
            //ZDSToastManager.shared.show(message: "Recuerda que solo puedes añadir un máximo de 3 contactos de emergencia.", style: .information, duration: 5)
            showToast(message: "Recuerda que solo puedes añadir un máximo de 3 contactos de emergencia.", type: .information)
            addContactsBtn.disabled = true
        } else {
            addContactsBtn.disabled = false
        }
    }
    
    lazy var onSavedContactCallBack: (_ contact: SendMyContactsResponse) -> Void = { [weak self] (contact) in
        guard let self = self else { return }
        saveNewContact(contact: contact)
    }
    
    private func saveNewContact(contact: SendMyContactsResponse){
        if self.myContactsList.count < 3 {
            self.myContactsList.append(contact)
            let _ = self.myContactsList.sorted(by: >)
        }
       
        self.contactsTableView.reloadData()
        showToast(message: "Los contactos de emergencia se actualizaron con éxito.", type: .success,action: {
            self.validateButton()
        })
    }
    
    
    
    lazy var onUpdatedContactCallBack: (_ contact: SendMyContactsResponse) -> Void = { [weak self] (contact) in
        guard let self = self else { return }
        if let index = myContactsList.firstIndex(where: { $0.id == contact.id }) {
            myContactsList[index] = contact
            let _ = self.myContactsList.sorted(by: >)
        }
        
        self.contactsTableView.reloadData()
        showToast(message: "Los contactos de emergencia se actualizaron con éxito.", type: .success,action: {
            self.validateButton()
        })
    }
    
    lazy var onShowMenuTapped: (_ currentUser: SendMyContactsResponse) -> Void = { [weak self] (currentUser) in
        guard let self = self else { return }
        currentUserSelected = currentUser
        showOptionsMenu()
    }
    
    lazy var onShowMenuTappedUMF: (_ currentUser: UMFdata) -> Void = { [weak self] (currentUser) in
        guard let self = self else { return }
        showOptionsMenuUMF()
    }
    
    @objc private func showOptionsMenu(){
        let myProfileOptionsView = MyContactsOptionsView()
        myProfileOptionsView.goToOptionSelected = onGoToOptionSelected
        myProfileOptionsView.openModule()
    }
    
    @objc private func showOptionsMenuUMF(){
        guard let umf = UMF.first else {
            return
        }
        EmergencyUMFPolizaEvents.shared.sendEvent(.opcionUMF)
        let myProfileOptionsView = UMFUpdateView(UMFdata: umf, delegate: self)
        myProfileOptionsView.openModule()
    }
    
    #warning("Renombrar enumerador a uno acorde a la acción que realiza")
    lazy var onGoToOptionSelected: (_ optionSelected: MyContacsOptions) -> Void = { [weak self] (optionSelected) in
        guard let self = self else { return }
        switch optionSelected {
        case .takePhoto:
            guard let contact = self.currentUserSelected else {return}
            let vc = AddMyContactsRouter.createModule()
            vc.isEditingContact = true
            vc.updatedContactCallBack = self.onUpdatedContactCallBack
            vc.editingContact = currentUserSelected
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .takeGallery:
            EmergencyContactsEvents.shared.sendEvent(.deleteModalView)
            var alert = ZDSAlert()
            alert.primaryColor = headerColor ?? .purple
            alert.title = "¿Está seguro de eliminar este contacto?"
            alert.message = ""
            alert.primaryTitle = "Sí, eliminar"
            alert.secondaryTitle = "Cancelar"
            alert.style = .alert
            
            let view = alert.asUIKitViewController()
            view.modalPresentationStyle = .overCurrentContext
            view.modalTransitionStyle = .crossDissolve
            view.view.backgroundColor = .backgroundTransparency
            
            alert.onSecundaryAction = {
                EmergencyContactsEvents.shared.sendEvent(.deleteModalCancel)
                self.showOptionsMenu()
                view.dismiss(animated: true)
            }
            
            alert.onPrimaryAction = {
                EmergencyContactsEvents.shared.sendEvent(.deleteModalConfirm)
                guard let contact = self.currentUserSelected else {return}
                self.deleteContact(contact: contact)
                view.dismiss(animated: true)
            }
            self.present(view, animated: true) {}
            break
        case .deletePhoto:
            
           break
        }
    }
    
    private func deleteContact(contact: SendMyContactsResponse){
        guard let zeusId = SessionInfo.shared.user?.zeusId else {
            return }
        showDSLoader()
        let url = TalentoZeusConfiguration.baseURL.absoluteString + "/v2/colaborador/{zeusID}/contactos-emergencia"
        let pathParams = MyContactsListPathParams(zeusID: zeusId)
        let params = DeleteContactParams(contactID: "\(contact.id)" )
        self.networking.call(url: url,
                             method: .delete,params: params,
                             pathParams: pathParams) { (_ result: Swift.Result<DeleteContactResponse, NetError>) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.hideDSLoader()
            })
            switch result {
            case .success(_):
                
                self.myContactsList.removeAll(where: { $0.id == self.currentUserSelected?.id } )
                self.validateButton()
                self.contactsTableView.reloadData()
                
                ZDSSnackBarManager.shared.show(
                    message: "Se eliminó el contacto de \(self.currentUserSelected?.name ?? "") \(self.currentUserSelected?.surnames ?? "") ",
                    actionText: "Deshacer",
                    color: .zeusPrimaryColor,
                    duration: 3
                ) {
                    print("Action clicked")
                    guard let currentContact = self.currentUserSelected else {
                        self.failAlert()
                        return}
                    self.sendSaveContactData(contactData: currentContact)
                }
                
                break
            case .failure(let error):
                switch error {
                case .invalidResponse(_, let error):
                    EmergencyContactsEvents.shared.sendEvent(.screenError(idRequest: error?.requestID ?? ""))
                default:
                    break
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                    self?.failAlert()
                })
                
                break
            }
        }
    }
    
    func sendSaveContactData(contactData: SendMyContactsResponse) {
        guard let zeusId = SessionInfo.shared.user?.zeusId else {
            return }
        showDSLoader()
        let url = TalentoZeusConfiguration.baseURL.absoluteString + "/v2/colaborador/datos/emergencia"
        let pathParams = SendMyContactsRequestPath(idColaborador: zeusId,  emergencyContact: [EmergencyContactPost(id: 0, name: contactData.name ?? "", surnames: contactData.surnames ?? "", relationship: contactData.relationship?.id ?? 0, phone: contactData.phone ?? "", status: 1)])
        
        self.networking.call(url: url,
                             method: .post,
                             body: pathParams) { (_ result: Swift.Result<SendMyContactsResponseData, NetError>) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.hideDSLoader()
            })
            switch result {
            case .success(let response):
                self.saveNewContact(contact: response.emergencyContact)
                break
            case .failure(let error):
                switch error {
                case .invalidResponse(_, let error):
                    EmergencyContactsEvents.shared.sendEvent(.screenError(idRequest: error?.requestID ?? ""))
                default:
                    break
                }
                self.failAlert()
                break
            }
        }
    }
   
    func getContacts(){
        guard let zeusId = SessionInfo.shared.user?.zeusId else {
            return }
        showDSLoader()
        let url = TalentoZeusConfiguration.baseURL.absoluteString + "/v2/colaborador/{zeusID}/contactos-emergencia"
        let pathParams = MyContactsListPathParams(zeusID: zeusId)
        
        self.networking.call(url: url,
                             method: .get,
                             pathParams: pathParams) { (_ result: Swift.Result<EmergencyContact, NetError>) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.hideDSLoader()
            })
            switch result {
            case .success(let response):
                self.myContactsList = response.emergencyInformation.getSortedData()
                self.UMF = response.emergencyInformation.getUMFdata()
                self.validateButton()
                self.contactsTableView.reloadData()
                break
            case .failure(let error):
                switch error {
                case .invalidResponse(_, let error):
                    EmergencyContactsEvents.shared.sendEvent(.screenError(idRequest: error?.requestID ?? ""))
                default:
                    break
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                    self?.failAlert()
                })
                break
            }
        }
    }
    
    func updateData(data: PersonalInformationRequest) {
        guard let zeusId = SessionInfo.shared.user?.zeusId else {
            return }
        let url = TalentoZeusConfiguration.baseCollaboratorURL.absoluteString + "/colaborador/data/\(zeusId)"
        self.networking.call(url: url, method: .put, body: data) { (_ result: Swift.Result<PersonalInformationResponse, NetError>) in
            switch result {
            case .success(let result):
                print(result)
                self.segmentedController.segmentTapped(tag: 0)
                
                self.showToast(message: "Actualización número UMF correcta", type: .success,action: {
                    self.getContacts()
                })
                break
            case .failure(let error):
                switch error {
                case .invalidResponse(_, let error):
                    EmergencyUMFPolizaEvents.shared.sendEvent(.saveError(idRequest: error?.requestID ?? ""))
                default:
                    break
                }
                self.hideDSLoader()
                self.failAlert()
                break
            }
        }
    }
    
    func showToast(message: String, type: ZeusCoreDesignSystem.ZDSToastStyle,action:(()->Void)? = nil) {
       // ZDSToastManager.shared.show(message: message, style: type, duration: 2)
        ZDSToastManager.shared.show(message: message,style: type,action: action,duration: 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5, execute: {
            action?()
        })
    }
    
    private func failAlert(){
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
            view.dismiss(animated: true)
        }
        
        self.present(view, animated: true) {}
    }

    private lazy var onSegmentedValueChanged: (_ indexValue: Int) -> Void = { [weak self] (indexValue) in
                
        guard let self = self else { return }
        self.tabBarIndex = indexValue
        contactsTableView.reloadData()
        switch indexValue {
        case 0:
            EmergencyViewEvents.shared.sendEvent(.tapContacts)
            emptyContactsView.isHidden = !(self.myContactsList.count <= 0)
            addContactsBtnView.isHidden = false
        case 1:
            EmergencyViewEvents.shared.sendEvent(.tapUMF)
            emptyContactsView.isHidden = true
            addContactsBtnView.isHidden = true
        default:
            break
        }
    }
    
}


extension MyEmergencyContactsViewController: UMFUpdateViewDelegate {
    func setUMF(num: String) {
        showDSLoader()
        EmergencyUMFPolizaEvents.shared.sendEvent(.save(edit: num))
        self.updateData(data: PersonalInformationRequest(unidadMedica: num))
    }
}

extension MyEmergencyContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabBarIndex == 1 {
            return UMF.count
        }
        return myContactsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tabBarIndex == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UMFCell.identifier, for: indexPath) as? UMFCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = .clear
            cell.showMenuCallBack = onShowMenuTappedUMF
            cell.myContact = UMF[indexPath.row]
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyContactCell.identifier, for: indexPath) as? MyContactCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.showMenuCallBack = onShowMenuTapped
        cell.myContact = myContactsList.sorted(by: <)[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tabBarIndex == 1 {
            return 99
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tabBarIndex == 1 {
            return 99
        }
        return UITableView.automaticDimension
    }
    
}

#warning("Renombrar enumerador a uno acorde a la acción que realiza")
enum MyContacsOptions {
    case takePhoto
    case takeGallery
    case deletePhoto
}

#warning("Crear un archivo separado para cumplir con los estándares y tener un código mas organizado")
class MyContactsOptionsView: UIViewController {
    
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
    
    lazy var takePhotoView: LabelWithImageProfile = {
        let view = LabelWithImageProfile()
        view.setupTitle(with: UIImage(materialIcon: .pencil, fill: false), title: "Editar contacto", tint: .black900, isArrowHidden: true)
        view.isUserInteractionEnabled =  true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTakePhotoTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var takeGalleryView: LabelWithImageProfile = {
        let view = LabelWithImageProfile()
        view.setupTitle(with: UIImage(materialIcon: .delete, fill: false), title: "Eliminar contacto", tint: .black900, isArrowHidden: true)
        view.isUserInteractionEnabled =  true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTakeGalleryTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var deletePhotoView: LabelWithImageProfile = {
        let view = LabelWithImageProfile()
        view.setupTitle(with: UIImage(materialIcon: .delete, fill: false), title: "Eliminar foto", tint: .black900, isArrowHidden: true)
        view.isUserInteractionEnabled =  true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onDeletePhotoTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var optionsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        
            [takePhotoView, takeGalleryView].forEach {sv.addArrangedSubview($0)}
        
        return sv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.font = UIFont(style: .bodyTextXL(variant: .bold, isItalic: false))
        lbl.text = "¿Qué te gustaría hacer?"
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
        
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    private var myWindow: UIWindow?
    
    #warning("Renombrar este método a uno acorde a la acción que realiza")
    var goToOptionSelected: ((_ optionSelected: MyContacsOptions) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmergencyContactsEvents.shared.sendEvent(.optionsModal)
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.containerView.frame.origin
        }
    }
    
    #warning("Evitar usar UIWindow si no es necesario, actualzar por el componente del Design System")
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
        
        
            height = UIScreen.main.bounds.height - 172
       
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
        
        containerView.addSubview(optionsStackView)
        
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
            
            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            optionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            optionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            
        ])
    }
    
    #warning("Renombrar este método a uno acorde a la acción que realiza")
    @objc private func onTakePhotoTapped() {
        EmergencyContactsEvents.shared.sendEvent(.editContact)
        activateDismissAnimation()
        goToOptionSelected?(.takePhoto)
    }
    
    #warning("Renombrar este método a uno acorde a la acción que realiza")
    @objc private func onTakeGalleryTapped(){
        EmergencyContactsEvents.shared.sendEvent(.deleteContact)
        activateDismissAnimation()
        goToOptionSelected?(.takeGallery)
    }
    
    @objc private func onDeletePhotoTapped(){
        activateDismissAnimation()
        goToOptionSelected?(.deletePhoto)
    }
    
    @objc private func activateDismissAnimation(){
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
//                let heightToDismiss = containerView.frame.height - (containerView.frame.height / 2)
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
