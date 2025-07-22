//
//  AllModulesViewController.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 16/07/24.
//

import UIKit
import ZeusCoreDesignSystem
import IQKeyboardManagerSwift
import ZeusSessionInfo
class AllModulesViewController: UIViewController {

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
    
    lazy var decorativeNotchIv: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "decorativeNotch")
        return iv
    }()
    
    lazy var searchBarView: ZDSNavigationSearchBar = {
        let view = ZDSNavigationSearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        view.delegate = self
        view.placeholder =  "¿Qué deseas hacer?"
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.isScrollEnabled = false
        cv.register(MyFavoritesCell.self, forCellWithReuseIdentifier: MyFavoritesCell.identifier)
        cv.clipsToBounds = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var emptyResultsLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "No sé encontraron resultados, tal vez quieras intentarlo nuevamente"
        lbl.numberOfLines = 0
        lbl.font = UIFont(style: .bodyTextL(variant: .regular, isItalic: false))
        lbl.textColor = UIColor(hexString: "#69657B")
        lbl.isHidden = true
        return lbl
    }()
    
    private var myWindow: UIWindow?
    var delegate: HomeViewControllerPermission?
    var backupMenuFrameworks: [PermissionMenuModel] = []
    var menuFrameworks: [PermissionMenuModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var goToFavoriteSelected: ((_ permissionItem: PermissionMenuModel) -> Void)? = nil
    var shouldOpenModulesMenu: ((_ shouldOpenModules: Bool) -> Void)? = nil
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        backupMenuFrameworks = menuFrameworks
        IQKeyboardManager.shared.resignOnTouchOutside = true
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.containerView.frame.origin
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
        containerView.addSubview(searchBarView)
        containerView.addSubview(collectionView)
        containerView.addSubview(emptyResultsLbl)
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
            
            searchBarView.topAnchor.constraint(equalTo: decorativeNotchIv.topAnchor, constant: 16),
            searchBarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            searchBarView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            searchBarView.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            collectionView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            emptyResultsLbl.topAnchor.constraint(equalTo: collectionView.topAnchor),
            emptyResultsLbl.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            emptyResultsLbl.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
        ])
        
    }
    
    private func activateDismissAnimation(shouldOpenModulesMenu: Bool = false){
        searchBarView.resignFirstResponder()
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
                if shouldOpenModulesMenu {
                    self.shouldOpenModulesMenu?(true)
                }
            }
        )
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
        searchBarView.resignFirstResponder()
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

    
}

extension AllModulesViewController: ZDSUDNViewControllerSearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filterArray = backupMenuFrameworks
        if searchBar.text == "" || searchBar.text == nil {
            menuFrameworks = backupMenuFrameworks
        } else {
            menuFrameworks = filterArray.filter{ ($0.name ?? "").lowercased().contains((searchBar.text ?? "").lowercased())  }
        }
        
        if menuFrameworks.count <= 0 {
            emptyResultsLbl.isHidden = false
        } else {
            emptyResultsLbl.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension AllModulesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuFrameworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFavoritesCell.identifier, for: indexPath) as? MyFavoritesCell else {
            return UICollectionViewCell()
        }
        //MARK: CHECK
        let data = menuFrameworks[indexPath.row]
        cell.configureCell(data: data, badge: 0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let permissonId = menuFrameworks[indexPath.row].idPermission
        SessionInfoQueries.shared.updateBadgePriority(idPermission: permissonId, priority: 4)
        delegate?.updateData()
        
        activateDismissAnimation(shouldOpenModulesMenu: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let permisson = self.menuFrameworks[indexPath.row]
            self.goToFavoriteSelected?(permisson)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        let width = collectionViewSize / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

