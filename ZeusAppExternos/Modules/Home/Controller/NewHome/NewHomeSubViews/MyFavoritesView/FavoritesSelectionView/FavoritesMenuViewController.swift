//
//  FavoritesMenuViewController.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 05/07/24.
//

import UIKit
import ZeusSessionInfo
import ZeusCoreDesignSystem
import ZeusUtils
class FavoritesMenuViewController: UIViewController {

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
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(style: .bodyTextL(variant: .bold, isItalic: false))
        lbl.text = "Personaliza tu Zeus"
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var subTitleLabel: UILabel = {
        let lbl = UILabel()
//        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(style: .bodyTextL(variant: .regular, isItalic: false))
        lbl.text = "Elige los 3 módulos \npara tu sección de favoritos"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var titlesStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillProportionally
        [titleLabel, subTitleLabel].forEach { sv.addArrangedSubview($0)}
        sv.backgroundColor = .clear
        return sv
    }()
    
    lazy var buttonsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
   
    
    lazy var buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fillEqually
        [cancelButton.asUIKitView(),saveButton.asUIKitView()].forEach { sv.addArrangedSubview($0)}
        return sv
    }()
    
    lazy var modulesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        [myFavoritesSelectedView, allModulesView].forEach {view.addSubview($0)}
        return view
    }()
    
    lazy var saveButton: ZDSButton = {
        var button = ZDSButton()
        button.style = .primary
        button.setTitle("Guardar", for: .normal)
        button.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .purple
        button.disabled = true
        return button
    }()
    
    lazy var cancelButton: ZDSButton = {
        var button = ZDSButton()
        button.style = .secondary
        button.setTitle("Cancelar", for: .normal)
        button.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .purple
        return button
    }()
    
    var menuFrameworks: [PermissionMenuModel] = []
    
    lazy var myFavoritesSelectedView: MyFavoritesSelectedView = {
        let view = MyFavoritesSelectedView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var allModulesView: AllModulesView = {
        let view = AllModulesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var decorativeNotchIv: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "decorativeNotch")
        return iv
    }()
    
    private var myWindow: UIWindow?
    
    var permissionsViewModel = [PermissionsViewModel]()
    var permissionsViewModelBackup = [PermissionsViewModel]()
    var permissionsFavorites = [PermissionsViewModel]()
    
    var selectedFavorites: ((_ permissionItem: [PermissionsViewModel]) -> Void)? = nil
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        
        for permission in menuFrameworks {
            self.permissionsViewModel.append(PermissionsViewModel(id: permission.idPermission, name: permission.name ?? "", isFavorite: false, position: 0))
        }
        
        self.permissionsViewModelBackup = permissionsViewModel
        self.permissionsFavorites = permissionsViewModel.favorites()
        self.allModulesView.favoritePermissions = self.permissionsFavorites
        self.allModulesView.permissionsViewModel = self.permissionsViewModel
        self.myFavoritesSelectedView.permissionsViewModel = self.permissionsFavorites
        
        self.myFavoritesSelectedView.selectFavorites = onSelectFavorites
        self.allModulesView.selectFavorites = onSelectFavorites
       
        setupActions()
        
        containerView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        containerView.addGestureRecognizer(panGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.containerView.frame.origin
        }
    }
    
    var selectFavorites: ((_ permissionItem: PermissionsViewModel, _ isRemovingItem: Bool) -> Void)? = nil
    
    lazy var onSelectFavorites: (_ permissionItem: PermissionsViewModel?, _ isRemovingItem: Bool) -> Void = { [weak self] (permissionItem, isRemovingItem) in
        guard let self = self else { return }
        
        guard let permissionItem = permissionItem else { return }
        
        if isRemovingItem {
            removeFavorite(permissionsViewModel: permissionItem)
        } else {
            addFavorite(permissionsViewModel: permissionItem, comeFromDrag: false)
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
//        searchBarView.resignFirstResponder()
        containerView.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                activateDismissAnimation()
            } else {
                let heightToDismiss = containerView.frame.height - (containerView.frame.height / 3)
                
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
    
    private func activateDismissAnimation(shouldOpenModulesMenu: Bool = false){
        
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
        UIView.animate(withDuration: 0.40) {
            self.containerView.transform = CGAffineTransform(translationX: 0.0, y: 50)
        }
    }
    func setupConstraints(){
        
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(shadowView)
        view.addSubview(containerView)
        
        containerView.addSubview(decorativeNotchIv)
        containerView.addSubview(titlesStackView)
        containerView.addSubview(buttonsContainerView)
        containerView.addSubview(buttonsStackView)
        
        containerView.addSubview(modulesContainerView)
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
            
            titlesStackView.topAnchor.constraint(equalTo: decorativeNotchIv.bottomAnchor, constant: 30),
            titlesStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            titlesStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            
            buttonsStackView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40),
            
            buttonsContainerView.topAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -10),
            buttonsContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            buttonsContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            buttonsContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            modulesContainerView.topAnchor.constraint(equalTo: titlesStackView.bottomAnchor),
            modulesContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            modulesContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            modulesContainerView.bottomAnchor.constraint(equalTo: buttonsContainerView.topAnchor),
            
            myFavoritesSelectedView.topAnchor.constraint(equalTo: modulesContainerView.topAnchor, constant: 20),
            myFavoritesSelectedView.leadingAnchor.constraint(equalTo: modulesContainerView.leadingAnchor),
            myFavoritesSelectedView.trailingAnchor.constraint(equalTo: modulesContainerView.trailingAnchor),
            myFavoritesSelectedView.heightAnchor.constraint(equalTo: modulesContainerView.widthAnchor, multiplier: 1/3),
            
            allModulesView.topAnchor.constraint(equalTo: myFavoritesSelectedView.bottomAnchor, constant: 30),
            allModulesView.leadingAnchor.constraint(equalTo: myFavoritesSelectedView.leadingAnchor),
            allModulesView.trailingAnchor.constraint(equalTo: myFavoritesSelectedView.trailingAnchor),
            allModulesView.bottomAnchor.constraint(equalTo: modulesContainerView.bottomAnchor),
        ])
    }
    
    func setupActions(){
        
        saveButton.onClick = { [weak self] in
            self?.saveChanges()
        }
        
        cancelButton.onClick = { [weak self] in
            self?.cancelChanges()
        }
        
    }
    
    func setFavorites(){
        allModulesView.permissionsViewModel = self.permissionsViewModel
        allModulesView.favoritePermissions = self.permissionsFavorites
        myFavoritesSelectedView.permissionsViewModel = self.permissionsFavorites
        
        if self.permissionsFavorites.count > 0 {
            self.saveButton.disabled = false
        } else {
            self.saveButton.disabled = true
        }
    }
    
    private func saveChanges(){
        let db: PermissionsDBProtocol = DBQuerys()
        db.inserFavorites(permissionsViewModel: permissionsFavorites)
        
        selectedFavorites?(self.permissionsFavorites)
        
        
        
        UIView.animate(withDuration: 0.5) {
            self.shadowView.alpha = 0.0
        }
        
        
        
        UIView.animate(
            withDuration: 0.4,
            animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            },
            completion: { _ in
                self.myWindow = nil
            }
        )
    }
    
    private func cancelChanges(){
        
        UIView.animate(withDuration: 0.5) {
            self.shadowView.alpha = 0.0
        }
        
        UIView.animate(
            withDuration: 0.4,
            animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            },
            completion: { _ in
                self.myWindow = nil
                self.restore()
            }
        )
    }
    
    func restore() {
        permissionsViewModel = permissionsViewModelBackup
        permissionsFavorites = permissionsViewModel.favorites()
        setFavorites()
    }

    func addFavorite(permissionsViewModel: PermissionsViewModel, comeFromDrag: Bool) {
        var newPermission = permissionsViewModel
        if let index = self.permissionsViewModel.firstIndex(where: {$0.id == permissionsViewModel.id}) {
            self.permissionsViewModel[index].isFavorite = true
        }
        
        newPermission.isFavorite = true
        
        if comeFromDrag {
            permissionsFavorites.append(newPermission)
            setFavorites()
            return
        }
        
        for index in 0...2 {
            if !permissionsFavorites.contains(where: { $0.position == index}) {
                newPermission.position = index
                permissionsFavorites.append(newPermission)
                break
            }
        }
        
        setFavorites()
    }
    
    func removeFavorite(permissionsViewModel: PermissionsViewModel) {
        if let index = self.permissionsViewModel.firstIndex(where: {$0.id == permissionsViewModel.id}) {
            self.permissionsViewModel[index].isFavorite = false
        }
        
        permissionsFavorites.removeAll { permission in
            permission.id == permissionsViewModel.id
        }
        setFavorites()
    }
}
