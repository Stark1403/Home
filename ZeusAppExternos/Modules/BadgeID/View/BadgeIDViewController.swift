//
//  BadgeIDViewController.swift
//  ZeusAppExternos
//
//  Created by Rafael on 19/12/23.
//
import UIKit
import ZeusUtils
import ZeusSessionInfo
import ZeusCoreDesignSystem
protocol BadgeIDViewDelegate {
    func didUploadImage(_ image: UIImage?)
}

class BadgeIDViewController: UIViewController {
  
    lazy var SCREEN_WIDTH:Double = {
      return UIScreen.main.bounds.size.width
    }()
  
    lazy var SCREEN_HEIGHT:Double = {
      return UIScreen.main.bounds.size.height
    }()
  
    let BASE_SCREEN_HEIGHT:CGFloat = 852.0
  
    lazy var SCREEN_MAX_LENGTH:Double = {
      return max(SCREEN_WIDTH, SCREEN_HEIGHT)
    }()
  
    lazy var ASPECT_RATIO_RESPECT_OF_15 = {
      return SCREEN_MAX_LENGTH / BASE_SCREEN_HEIGHT
    }()
    
    let views: BadgeIDViews = BadgeIDViews()
    var udnSkin: UDNSkin {
        UDNSkin.global
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterBadgeIDProtocol?
    var delegate: BadgeIDViewDelegate?
    var isGuestMode: Bool = false
    var currentImage: UIImage?
    var selectedImage: UIImage?
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        super.loadView()
        // First load the view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Second Call the services
        setupView(views)
        setBusinessImage()
        setBadgeColors()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.views.blurEffectView {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func openModalSelectImage() {
        showImageOptionSelector()
    }
    
    func setImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.showDSLoader()
            if self.isGuestMode {
                self.didSetImage(image)
                self.delegate?.didUploadImage(image)
            } else {
                self.selectedImage = image
                self.presenter?.uploadImage(image)
            }
        }
    }
    
    func didSetImage(_ image: UIImage?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.hideDSLoader()
        })
        self.currentImage = image
        self.views.viewImageProfile.image = image
        self.views.viewImageProfile.isButtonViewHidden = true
    }
    
    func setBusinessImage(){
        if let photo = SessionInfo.shared.company?.photo, photo != ""{
            views.logoBusinessImageView.kf.setImage(with: URL(string:photo))
        }
    }
    
    func setBadgeColors(){
        views.waveOneImage.tintColor =  udnSkin.color
        views.waveTwoImage.tintColor =  udnSkin.color
        views.nameUserLabel.textColor = udnSkin.color
    }
}

extension BadgeIDViewController: PresenterToViewBadgeIDProtocol{
    func didUploadImageSuccess(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.didSetImage(image)
            self.delegate?.didUploadImage(image)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.hideDSLoader()
        })
    }
    
    func didUploadImageFailure(_ type: ZDSResultType) {
        showGenericError(type)
    }
    
    func showGenericError(_ type: ZDSResultType) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.hideDSLoader()
        })
        var view: ZDSResultAlertViewController?
        switch type {
        case .errorInternet:
            let delegateInternet = ErrorButtonHandler { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
                self.setImage(self.selectedImage)
            } secondaryButtonAction: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            } backButtonAction: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            
            view = ZDSResultAlertViewController(typeLottie: type,
                                                titulo: "¡Lo sentimos!",
                                                descripcion: "Tuvimos un problema de conexión, inténtalo más tarde",
                                                textoBoton: "Intentar nuevamente",
                                                textoSecundario: "Cancelar",
                                                color: udnSkin.color,
                                                isShowBackButton: true)
            view?.delegate = delegateInternet
            
        case .errorGeneric:
            let delegateServer = ErrorButtonHandler (firstButtonAction: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }, secondaryButtonAction: nil, backButtonAction: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            view = ZDSResultAlertViewController(typeLottie: type,
                                                titulo: "¡Estimado usuario!",
                                                descripcion: "No hemos encontrado información con los datos ingresados, te sugerimos verificar la información e intentarlo nuevamente.",
                                                textoBoton: "Entendido",
                                                color: udnSkin.color,
                                                isShowBackButton: true)
            view?.delegate = delegateServer
        default:
            return
        }
        guard let view = view else { return }
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true)
    }
}

