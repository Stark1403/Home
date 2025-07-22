//
//  MyProfileViewController.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 17/09/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
import ZeusCoreInterceptor
import AVFoundation
import MobileCoreServices
import ZeusCoreInterceptor
import ZeusUtils


class MyProfileViewController: ZDSUDNViewController, UINavigationControllerDelegate{

    lazy var userImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var userProfileImageView: ZUAvatarImageView = {
        let iv = ZUAvatarImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        let name = "\(SessionInfo.shared.user?.name ?? "") \(SessionInfo.shared.user?.lastName ?? "")"
        
        if SessionInfo.shared.user?.photo == "" {
            iv.setupWithAvatarURL(source: UIImage(), imageUrl: SessionInfo.shared.user?.photo ?? "", userName: name, isFromMain: true) { hasImage in
            }
        } else {
            iv.setupWithAvatarURL(source: SessionInfo.shared.photoLocal ?? UIImage(), imageUrl: SessionInfo.shared.user?.photo ?? "", userName: name, isFromMain: true) { hasImage in
            }
        }
        return iv
    }()
    
    lazy var takePicImageViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = headerColor
        
        return view
    }()
    
    lazy var takePicImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = headerColor
        iv.image = UIImage(materialIcon: .photoCamera, fill: true)
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont(style: .bodyTextXL(variant: .bold, isItalic: false))
        lbl.text = "\(SessionInfo.shared.user?.name ?? "") \(SessionInfo.shared.user?.lastName ?? "") \(SessionInfo.shared.user?.secondLastName ?? "")"
        lbl.textColor = headerColor
        return lbl
    }()
    
    lazy var positionLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
        lbl.text = "\(SessionInfo.shared.user?.job ?? "")"
        lbl.textColor = UIColor(hexString: "#393647")
        return lbl
    }()
    
    lazy var companyLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
        lbl.text = "\(SessionInfo.shared.company?.name ?? "")"
        lbl.textColor = UIColor(hexString: "#393647")
        return lbl
    }()
    
    lazy var labelsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 5
        [nameLbl, positionLbl, companyLbl].forEach{ sv.addArrangedSubview($0) }
        return sv
    }()
    
    lazy var profileLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = UIFont(style: .bodyTextXL(variant: .bold, isItalic: false))
        lbl.text = "Mi perfil"
        lbl.textColor = UIColor(hexString: "#393647")
        return lbl
    }()
    
    lazy var myInformationView: LabelWithForwardArrow = {
        let view = LabelWithForwardArrow()
        view.isViewActive = true
        view.setupTitle(with: UIImage(named: "personIc") ?? UIImage(), title: "Mi información", tint: headerColor ?? .purple)
        view.onClickView = {
            self.navigateToViewController(vcSelected: .myInfo)
        }
        return view
    }()
    
    lazy var myPrivateDataView: LabelWithForwardArrow = {
        let view = LabelWithForwardArrow()
        view.isViewActive = true
        view.setupTitle(with: UIImage(named: "personShieldIc") ?? UIImage(), title: "Mis datos privados", tint: headerColor ?? .purple)
        view.onClickView = {
            self.navigateToViewController(vcSelected: .myPrivateData)
        }
        return view
    }()
    
    lazy var myContactsView: LabelWithForwardArrow = {
        let view = LabelWithForwardArrow()
        view.isViewActive = true
        view.setupTitle(with: UIImage(named: "personContacIc") ?? UIImage(), title: "Datos de emergencia", tint: headerColor ?? .purple)
        view.onClickView = {
            print("@@@@@@@@@")
            self.navigateToViewController(vcSelected: .myContacts)
        }
        return view
    }()
    
    lazy var employeeDataView: LabelWithForwardArrow = {
        let view = LabelWithForwardArrow()
        view.isViewActive = true
        view.setupTitle(with: UIImage(named: "work") ?? UIImage(), title: "Datos laborales", tint: headerColor ?? .purple)
        view.onClickView = {
            self.navigateToViewController(vcSelected: .employeeData)
        }
        return view
    }()
    lazy var digitalFileView: LabelWithForwardArrow = {
        let view = LabelWithForwardArrow()
        view.isViewActive = true
        view.setupTitle(with: UIImage(named: "personFileIc") ?? UIImage(), title: "Expediente digital", tint: headerColor ?? .purple)
        view.onClickView = {
            self.navigateToViewController(vcSelected: .digitalFile)
        }
        return view
    }()
    
    /*lazy var myWorkExperience: LabelWithForwardArrow = {
        let view = LabelWithForwardArrow()
        view.isViewActive = true
        view.setupTitle(with: UIImage(named: "work") ?? UIImage(), title: "Mi experiencia laboral", tint: headerColor ?? .purple)
        return view
    }()*/
    
    lazy var optionsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 15
        [profileLbl, myInformationView, myPrivateDataView, myContactsView, employeeDataView, digitalFileView].forEach { sv.addArrangedSubview($0) }
        return sv
    }()
    
    override func viewDidLoad() {
        headerColor = SessionInfo.shared.company?.primaryUIColor
        navigationBarColor = headerColor
        titleString = "Mi cuenta"
        view.backgroundColor = .white
        super.viewDidLoad()
        setupConstraints()
        let openCamera = UITapGestureRecognizer(target: self, action: #selector(showOptionsMenu))
        MyProfileEvents.shared.sendEvent(.screenView)
        takePicImageViewContainer.isUserInteractionEnabled = true
        userImageContainer.isUserInteractionEnabled = true
        takePicImageViewContainer.addGestureRecognizer(openCamera)
    }

    override func backAction(){
        MyProfileEvents.shared.sendEvent(.back)
        ZCInterceptor.shared.releaseLastFlow()
    }
    
    @objc private func showOptionsMenu(){
        MyProfileEvents.shared.sendEvent(.profilePhoto)
        let myProfileOptionsView = MyProfileOptionsView()
        myProfileOptionsView.goToOptionSelected = onGoToOptionSelected
        myProfileOptionsView.openModule()
    }
    
    lazy var onGoToOptionSelected: (_ optionSelected: MyProfileOptions) -> Void = { [weak self] (optionSelected) in
        guard let self = self else { return }
        switch optionSelected {
        case .takePhoto:
            self.openCamera(sourceType: .camera, requestType: .camera)
            break
        case .takeGallery:
            self.openCamera(sourceType: .photoLibrary, requestType: .gallery)
            break
        case .deletePhoto:
            
            var alert = ZDSAlert()
            alert.primaryColor = headerColor ?? .purple
            alert.title = "¿Esta seguro de eliminar la foto de perfil?"
            alert.message = ""
            alert.primaryTitle = "Sí, eliminar"
            alert.secondaryTitle = "Cancelar"
            alert.style = .alert
            alert.buttonsDistribution = .vertical
            
            let view = alert.asUIKitViewController()
            view.modalPresentationStyle = .overCurrentContext
            view.modalTransitionStyle = .crossDissolve
            view.view.backgroundColor = .backgroundTransparency
            
            alert.onSecundaryAction = {
                view.dismiss(animated: true)
            }
            
            alert.onPrimaryAction = {
              
                self.showDSLoader()
                ProfilePhotoManager.shared.sendPhoto(url: "", photo: UIImage()) { completed in
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                        self?.hideDSLoader()
                    })
                    if completed == false {
                            self.showErrorAlert()
                    } else {
                        let name = "\(SessionInfo.shared.user?.name ?? "") \(SessionInfo.shared.user?.lastName ?? "")"
                        self.userProfileImageView.setupWithAvatarURL(source: SessionInfo.shared.photoLocal ?? UIImage(), imageUrl: SessionInfo.shared.user?.photo ?? "", userName: name, isFromMain: true) { hasImage in
                            print(hasImage)
                        }
                    }
                    
                }
                view.dismiss(animated: true)
            }
            self.present(view, animated: true) {}
        }
    }
    
    
    private func openCamera(sourceType: UIImagePickerController.SourceType, requestType: ZUAuthorizationClassType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .overFullScreen

        ZUAuthorizationClass.askForAccessOrGotoSettingsFor(type: .camera, presenterForFail: self) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { //wait to end bottomsheet dismiss animation
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func showErrorAlert(){
        var alert = ZDSAlert()
        alert.primaryColor = headerColor ?? .purple
        alert.title = "¡Oops! Algo paso"
        alert.message = "La acción no se pudo completar \ncorrectamente. Inténtalo de nuevo."
        alert.primaryTitle = "Aceptar"
        alert.style = .error
        alert.buttonsDistribution = .vertical
        
        let view = alert.asUIKitViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.modalTransitionStyle = .crossDissolve
        view.view.backgroundColor = .backgroundTransparency
        
        alert.onPrimaryAction = {
            view.dismiss(animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.present(view, animated: true) {}
        })
    }
    
    private func setupConstraints(){
        view.addSubview(userImageContainer)
        userImageContainer.addSubview(userProfileImageView)
        view.addSubview(takePicImageViewContainer)
        takePicImageViewContainer.addSubview(takePicImageView)
        
        view.addSubview(labelsStackView)
        view.addSubview(optionsStackView)
        NSLayoutConstraint.activate([
            userImageContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            userImageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageContainer.widthAnchor.constraint(equalToConstant: 170),
            userImageContainer.heightAnchor.constraint(equalToConstant: 170),
            
            userProfileImageView.topAnchor.constraint(equalTo: userImageContainer.topAnchor),
            userProfileImageView.leadingAnchor.constraint(equalTo: userImageContainer.leadingAnchor),
            userProfileImageView.trailingAnchor.constraint(equalTo: userImageContainer.trailingAnchor),
            userProfileImageView.bottomAnchor.constraint(equalTo: userImageContainer.bottomAnchor),
            
            takePicImageViewContainer.bottomAnchor.constraint(equalTo: userImageContainer.bottomAnchor, constant: -8),
            takePicImageViewContainer.trailingAnchor.constraint(equalTo: userImageContainer.trailingAnchor, constant: -8),
            takePicImageViewContainer.heightAnchor.constraint(equalToConstant: 40),
            takePicImageViewContainer.widthAnchor.constraint(equalToConstant: 40),
            
            takePicImageView.topAnchor.constraint(equalTo: takePicImageViewContainer.topAnchor, constant: 10),
            takePicImageView.leadingAnchor.constraint(equalTo: takePicImageViewContainer.leadingAnchor, constant: 10),
            takePicImageView.trailingAnchor.constraint(equalTo: takePicImageViewContainer.trailingAnchor, constant: -10),
            takePicImageView.bottomAnchor.constraint(equalTo: takePicImageViewContainer.bottomAnchor, constant: -10),
            
            labelsStackView.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 16),
            labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            optionsStackView.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 30),
            optionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            optionsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
        takePicImageViewContainer.layer.cornerRadius = 40 / 2
        userProfileImageView.layer.cornerRadius = 170 / 2
        userProfileImageView.layer.borderWidth = 2
        userProfileImageView.layer.borderColor = headerColor?.cgColor
    }
    
    private func navigateToViewController(vcSelected: myProfileVCOptions){
        var vc : UIViewController?
        switch vcSelected {
        case .myInfo:
            MyProfileEvents.shared.sendEvent(.myInformation)
            vc = MyInformationViewRouter.createModule()
            break
        case .myContacts:
            MyProfileEvents.shared.sendEvent(.emergencyData)
            vc = MyEmergencyContactsViewController()
            break
        case .myPrivateData:
            MyProfileEvents.shared.sendEvent(.myPrivateData)
            vc = MyPrivateDataRouter.createModule()
            break
        case .employeeData:
            vc = EmploymentDataRouter.createModule()
            break
        case .digitalFile:
            MyProfileEvents.shared.sendEvent(.digitalFile)
            ZCInterceptor.shared.startFlow(forAction: ZCIExternalZeusKeys.documentManager, navigateDelegate: self, withInfo: [:])
            break
        }
        guard let vc = vc else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

private enum myProfileVCOptions {
    case myInfo
    case myContacts
    case myPrivateData
    case employeeData
    case digitalFile
}

extension MyProfileViewController: ZCInterceptorDelegate {
    func didFailToEnterFlow(error: NSError) {
        
    }
    
    func willFinishFlow(withInfo info: [String : Any]?) {
       
    }
    
    func didFinishFlow() {
        
        
    }
}

extension MyProfileViewController: UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        showDSLoader()
        
        if let editedImage = info[.editedImage] as? UIImage {
            ProfilePhotoManager.shared.uploadPhoto(photo: editedImage) { completion in
                if completion {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                        self?.hideDSLoader()
                        let name = "\(SessionInfo.shared.user?.name ?? "") \(SessionInfo.shared.user?.lastName ?? "")"
                        self?.userProfileImageView.setupWithAvatarURL(source: SessionInfo.shared.photoLocal ?? UIImage(), imageUrl: SessionInfo.shared.user?.photo ?? "", userName: name, isFromMain: true) { hasImage in
                            print(hasImage)
                        }
                    })
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                        self?.hideDSLoader()
                        self?.showErrorAlert()
                    })
                }
            }
        } else if let image = info[.originalImage] as? UIImage  {
            ProfilePhotoManager.shared.uploadPhoto(photo: image) { completion in
                
                if completion {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                        self?.hideDSLoader()
                        let name = "\(SessionInfo.shared.user?.name ?? "") \(SessionInfo.shared.user?.lastName ?? "")"
                        self?.userProfileImageView.setupWithAvatarURL(source: SessionInfo.shared.photoLocal ?? UIImage(), imageUrl: SessionInfo.shared.user?.photo ?? "", userName: name, isFromMain: true) { hasImage in
                            print(hasImage)
                        }
                    })
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                        self?.hideDSLoader()
                        self?.showErrorAlert()
                    })
                }
            }
        } else {
            PrintManager.print("Zeus: Not is image and video")
        }
    }
}

class LabelWithForwardArrow: UIView {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F5F5F7")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .black900
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var optionTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(hexString: "#393647")
        lbl.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
        return lbl
    }()
    
    lazy var fordwardArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(materialIcon: .chevronRight)?.withTintColor(SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor ?? .gray, renderingMode: .alwaysTemplate)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var onClickView: (() -> Void)?
    var isViewActive: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    private func setupConstraints(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tap)
        self.addSubview(containerView)
        containerView.addSubview(lineView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(optionTitleLbl)
        containerView.addSubview(fordwardArrow)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            lineView.topAnchor.constraint(equalTo: containerView.topAnchor),
            lineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 50),
            lineView.widthAnchor.constraint(equalToConstant: 5),
            lineView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            
            optionTitleLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionTitleLbl.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            
            fordwardArrow.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            fordwardArrow.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            fordwardArrow.heightAnchor.constraint(equalToConstant: 24),
            fordwardArrow.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    @objc private func tappedView(){
        if isViewActive {
            onClickView?()
        }
    }
    
    func setupTitle(with image: UIImage?, title: String, tint: UIColor?, isArrowHidden: Bool = false){
        iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
        optionTitleLbl.text = title
        lineView.backgroundColor = tint
        fordwardArrow.isHidden = isArrowHidden
        lineView.isHidden = isArrowHidden
        containerView.backgroundColor = isArrowHidden ? UIColor.clear : UIColor(hexString: "#F5F5F7")
        
        if !isViewActive {
            containerView.backgroundColor = UIColor(hexString: "#F5F5F7")
            lineView.backgroundColor = UIColor(hexString: "#9F9CAB")
            optionTitleLbl.textColor = UIColor(hexString: "#9F9CAB")
            fordwardArrow.tintColor = UIColor(hexString: "#9F9CAB")
            iconImageView.tintColor = UIColor(hexString: "#9F9CAB")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class LabelWithImageProfile: UIView {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F5F5F7")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .black900
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var optionTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(hexString: "#393647")
        lbl.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
        return lbl
    }()
    
    lazy var fordwardArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(materialIcon: .chevronRight)?.withTintColor(SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor ?? .gray, renderingMode: .alwaysTemplate)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    private func setupConstraints(){
        self.addSubview(containerView)
        containerView.addSubview(lineView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(optionTitleLbl)
        containerView.addSubview(fordwardArrow)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            lineView.topAnchor.constraint(equalTo: containerView.topAnchor),
            lineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 40),
            lineView.widthAnchor.constraint(equalToConstant: 5),
            lineView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            
            optionTitleLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionTitleLbl.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            
            fordwardArrow.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            fordwardArrow.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            fordwardArrow.heightAnchor.constraint(equalToConstant: 24),
            fordwardArrow.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func setupTitle(with image: UIImage?, title: String, tint: UIColor?, isArrowHidden: Bool = false){
        iconImageView.image = image
        optionTitleLbl.text = title
        lineView.backgroundColor = tint
        fordwardArrow.isHidden = isArrowHidden
        lineView.isHidden = isArrowHidden
        containerView.backgroundColor = isArrowHidden ? UIColor.clear : UIColor(hexString: "#F5F5F7")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
