//
//  GuestHomeViewController.swift
//  ZeusAppExternos
//
//  Created by Rafael on 17/08/23.
//
import UIKit
import ZeusUtils
import ZeusSessionInfo
import ZeusCoreDesignSystem
var menuSlideGuest: [GuestMenuList] = []
class GuestHomeViewController: ZDSUDNViewController {
    private let views: GuestHomeViews = GuestHomeViews()
    
    // MARK: - Properties
    var presenter: ViewToPresenterGuestHomeProtocol?
    
    var menuFrameworks: [GuestMenuList] = []
    
    var imageProfile: UIImage?
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        super.loadView()
        setupLayout(views: views)
    }
    
    override func viewDidLoad() {
        headerColor = .zeusPrimaryColor
        super.viewDidLoad()
        UserDefaultsManager.setIsFirstUserLoad(for: SessionInfo.shared.user?.zeusId ?? "", value: false)
        if !UserDefaultsManager.getIsFirstUserLoad(for: SessionInfo.shared.user?.zeusId ?? "") {
            showDSLoader(style: .translucent, message: ZDSLoaderMessage(message: "¡Arrancamos!", font: .display1(isItalic: false)))
        } else {
            showDSLoader()
        }
        presenter?.fetchMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func showProfilePhotoAlert() {
        UIAlertController.showUDNDoubleWith(title: "Foto de perfil",
                                            message: "Para una mejor experiencia, actualiza tu foto de perfil",
                                            udn: .init(color: .zeusPrimaryColor, logo: nil, miniLogo: nil),
                                            firstActionTitle: "Más tarde",
                                            secondActionTitle: "Actualizar", secondActionHandler:  {
            self.dismiss(animated: true) {
                self.goToProfilePicture()                
            }
        })
    }
    
    @objc func goToProfilePicture() {
        presenter?.openAddPhoto(imageProfile, delegate: self)
    }
    
    @objc func openHamburguerMenu(_ sender: ZDSButtonAlt) {
        guard let tabBarViewController = self.tabBarController as? GuestHomeTabBar else {
            return
        }
        tabBarViewController.openHamburguerMenu(menuSlide: menuSlideGuest)
    }
}

extension GuestHomeViewController: BadgeIDViewDelegate{
    func didUploadImage(_ image: UIImage?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.hideDSLoader()
        })
        imageProfile = image
        views.imageProfile.image = image
        views.labelAcronym.isHidden = true
        views.profileBackgroudView.isHidden = true
    }
}

extension GuestHomeViewController: PresenterToViewGuestHomeProtocol{
    // TODO: Implement View Output Methods
    func hideViewDSLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.hideDSLoader()
        })
    }
    
    func didFetchMenu(data: GuestMenuResponse) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.hideViewDSLoader()
        })
        if self.menuFrameworks.isEmpty == true {
            self.showProfilePhotoAlert()
        }
        guard let menus = data.menus else { return }
        menuFrameworks = menus.first(where: {$0.typeMenu == 1})?.list ?? []
        menuFrameworks.insert(.init(name: "Blog Zeus",
                                   order: 0,
                                   childs: [],
                                   permissionID: 600,
                                   showChilds: nil,
                                   categoryColor: nil,
                                   description: ""), at: 0)
        menuFrameworks.append(.init(name: "Chat Zeus",
                                    order: 3,
                                    childs: [],
                                    permissionID: 500,
                                    showChilds: nil,
                                    categoryColor: nil,
                                    description: "En la era digital, en la que los canales sociales permiten interacciones a una velocidad desconocida anteriormente, la comunicación corporativa adquiere una importancia mucho más relevante. \n\nNuestro chat interno permite buscar a cualquier colaborador sin la necesidad de tener su contacto en la agenda del celular. Solo debes escribir el nombre o identificador de la persona que buscas y puedes empezar a chatear con ella. Zeus cuenta con versión web para administradores y versión móvil para empleados. \n\nSi deseas ingresar a esta funcionalidad inicia sesión"))
        menuFrameworks.insert(.init(name: "Planning Poker", order: 2,
                                    childs: [],
                                    permissionID: 114,
                                    showChilds: nil,
                                    categoryColor: nil,
                                    description: ""), at: 1)
        menuSlideGuest = menus.first(where: {$0.typeMenu == 4})?.list ?? []
        DispatchQueue.main.async {
            self.views.collectionView.reloadData()            
        }
    }
}
