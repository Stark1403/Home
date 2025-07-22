//
//  TabBarViewController.swift
//  ZeusAppExternos
//
//  Created by Alexander Betanzos Lopez on 30/03/23.
//

import Foundation
import UIKit
import ZeusSessionInfo
import ZeusNotificationsCenter
import ZeusIntercomExterno
import ZeusCoreDesignSystem
import ZeusCoreInterceptor

var menuSlideTemp: [PermissionMenuModel] = []
class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    private var currentIndex: Int = 1
    var notifications: [BadgeNotifications] = [BadgeNotifications]()
    var tabItems: [UIViewController] = []
    var menuSlide: [PermissionMenuModel] = []
    var controlSubviews: [UIControl] = []
    
    let typeMenuPermission = 2
    let IdPermissionChat = 34
    let IdPermissionHelp = 66
    let notificationPermission = 141
    let idSocialNetwork = 123
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        pushNotificationObserver()
        getHelpPermission()
        setupObservers()
        self.view.backgroundColor = .white
        configureTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func pushNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(pushNotificationHandler(_:)) , name: NSNotification.Name(rawValue: "newPushNotification"), object: nil)
    }
    
    func getHelpPermission() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SetHideHelpPermission"), object: nil, queue: nil) { _ in
            self.tabItems.removeAll { item in
                return item.title == "Ayuda"
            }
            self.viewControllers = self.tabItems
        }
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("BottomBarGoToNotifications"), object: nil, queue: nil) { _ in
            let tabIndex = self.tabItems.firstIndex { item in
                return item.view.tag == self.notificationPermission
            }
            if let tabIndex = tabIndex {
                self.selectedIndex = tabIndex
            }
        }
    }
    
    func configureTabbar() {
        //self.tabBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
        self.tabBar.backgroundColor = UIColor.extraLight100
        self.tabBar.tintColor = SessionInfo.shared.company?.primaryUIColor
        self.tabBar.layer.cornerRadius = 16
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if SessionInfo.shared.permissions?.count == 0{
            showDSLoader()
            PermissionManager.shared.getMenu(zeusId: SessionInfo.shared.company?.zeusId ?? "") { [weak self]_ in
                self?.createTabBarItems()
                self?.hideDSLoader()
            }
            
        }else{
            createTabBarItems()
            reloadNotifications()
        }
    }
    
    func createTabBarItems(){
        addHomeTab()
        
        if let permissions = SessionInfo.shared.permissions, permissions.count >= 1 {
            
            if permissions.contains(where: {$0.id == IdPermissionHelp && $0.type == typeMenuPermission}) {
                addSupportTab()
            }
            
            if let permission = permissions.first(where: {$0.id == idSocialNetwork && $0.type == typeMenuPermission}) {
                addSocialNetworkTab(permission)
            }
            
            addNotificationsTab()
            
            if permissions.contains(where: {$0.id == IdPermissionChat && $0.type == typeMenuPermission}) {
                addChatTab()
            }
        }
        
        viewControllers = tabItems
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setBadgeOn()
            self.tabBar.tintColor = SessionInfo.shared.company?.primaryUIColor
            self.updateTabbarIndicatorBySelectedTabIndex(index: 0)
            self.selectedIndex = 0
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SetHamburguerPermission"), object: nil, queue: nil) { _ in
            if !PermissionSingleton.shared.getValueForHamburgueMenu() {
                guard let item = self.tabItems.firstIndex(where: { r in
                    return r.tabBarItem.tag == 0
                }) else { return }
                
                self.tabItems.remove(at: item)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(openMenuBiometric(_:)), name: .openSideMenuBiometric, object: nil)
    }
    
    func setTagSubView() {
        guard let tabBarItems = self.tabBar.items else { return }
        let controlSubviews = self.tabBar.subviews.compactMap { $0 as? UIControl }
        
        for (index, tabBarItem) in tabBarItems.enumerated() {
            guard index < controlSubviews.count else { continue }
            let controlSubview = controlSubviews[index]
            controlSubview.tag = tabBarItem.tag
         
            if let existingView = controlSubview.subviews.first(where: { $0.tag == tabBarItem.tag }) {
                existingView.removeFromSuperview()
                print("Subview con tag \(tabBarItem.tag) eliminado dentro de controlSubview.")
            }
            
        }
    }

    
    func setBadgeOn() {
        guard let tabBarItems = self.tabBar.items else { return }
        self.controlSubviews = self.tabBar.subviews.compactMap { $0 as? UIControl }
        let permissions = SessionInfo.shared.permissions

        for (index, tabBarItem) in tabBarItems.enumerated() {
            guard index < controlSubviews.count else { continue }
            let controlSubview = controlSubviews[index]
            controlSubview.tag = tabBarItem.tag
           
            
            if let menu = permissions?.first(where: { $0.id == tabBarItem.tag }), menu.badgePriority == 3 {
                print(menu.id)
                let view = getBadgePriorityView()
                view.tag = tabBarItem.tag
                view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                controlSubview.addSubview(view)
                
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: controlSubview.topAnchor, constant: -12),
                    view.centerXAnchor.constraint(equalTo: controlSubview.centerXAnchor)
                ])
            }
        }
    }
    
    
    func setBadgeOff(tagSelect: Int) {
        if let controlSubview = controlSubviews.first(where: { $0.tag == tagSelect }) {
            if let existingView = controlSubview.subviews.first(where: { $0.tag == tagSelect }) {
                existingView.removeFromSuperview()
            }
        }
    }

    func getBadgePriorityView() -> UIView {
        var badge = ZDSBadge()
        badge.title = "🔥 Nuevo"
        badge.style = .high
        return badge.asUIKitView()
    }
    
    private func addHomeTab() {
        let tabOne = HomeViewControllerRouter.createModule(delegate: self)
        let tabOneBarItem = UITabBarItem(title: "Inicio", image: UIImage(named: "Home.png"), selectedImage: UIImage(named: "Home-Selected.png"))
        let navController = UINavigationController(rootViewController: tabOne)
        navController.isNavigationBarHidden = true
        navController.tabBarItem = tabOneBarItem
        tabItems.insert(navController, at: 0)
    }
    
    private func addSupportTab() {
        let tabTwo = UIViewController() ///some view controller to add in the tab bar item
        tabTwo.view.tag = IdPermissionHelp ///set tag to identify this view controller in should select method
        let tabTwoBarItem2 = UITabBarItem(title: "Ayuda", image: UIImage(named: "Ayuda.png"), selectedImage: UIImage(named: "Ayuda.png"))
        tabTwoBarItem2.tag = IdPermissionHelp
        tabTwo.tabBarItem = tabTwoBarItem2
        tabItems.append(tabTwo)
    }
    
    private func addNotificationsTab() {
        let tabThree = ZNCViewProvider.getNotificationCenterView()
        let tabTwoBarItem3 = UITabBarItem(title: "Notificaciones", image: UIImage(named: "AlertasInactive"), selectedImage: UIImage(named: "AlertasActive"))
        tabTwoBarItem3.tag = notificationPermission
        tabThree.view.tag = notificationPermission
        let navControllerTwo = UINavigationController(rootViewController: tabThree)
        
        navControllerTwo.tabBarItem = tabTwoBarItem3
        navControllerTwo.view.tag = notificationPermission
        
        tabItems.append(navControllerTwo)
    }
    
    private func addChatTab() {
        let tabFour = UIViewController()
        tabFour.view.tag = IdPermissionChat
        let tabTwoBarItem4 = UITabBarItem(title: "Chat", image: UIImage(named: "Chat_Zeus.png"), selectedImage: UIImage(named: "Chat_Zeus.png"))
        tabTwoBarItem4.tag = 5
        tabFour.tabBarItem = tabTwoBarItem4
        tabTwoBarItem4.tag = IdPermissionChat
        tabItems.append(tabFour)
    }
    
    private func addSocialNetworkTab(_ permission: Permission) {
        let vc = UIViewController() ///some view controller to add in the tab bar item
        vc.view.tag = idSocialNetwork ///set tag to identify this view controller in should select method
        let name = permission.name
        let item = UITabBarItem(title: "Red social", image: UIImage(named: "ic-star.png"), selectedImage: UIImage(named: "ic-star.fill.png"))
        item.tag = idSocialNetwork
        vc.tabBarItem = item
        tabItems.append(vc)
    }
    
    
    @objc func openMenuBiometric(_ notification: Notification) {
        self.openHamburguerMenu()
        
        if let slideView = UIApplication.shared.sliderView as? DetailMenuViewController {
            slideView.settingsOptionsContainerView.isHidden = false
        }
    }
    
    @objc func pushNotificationHandler(_ notification : NSNotification) {
        reloadNotifications()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        SessionInfoQueries.shared.updateBadgePriority(idPermission: item.tag, priority: 4)
        updateNotifications(idPermission: item.tag)
        setBadgeOff(tagSelect: item.tag)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.view.tag == 6 {
            self.openHamburguerMenu()
            return false
        }
        
        switch viewController.view.tag {
        case IdPermissionHelp:
            HomeEventCollector.send(category: .homeEvent, subCategory: .mainView, event: .tapNavBarSuport, action: .click)
            ZeusIntercomSDK.isLoggedUser() ? openModuleIntercom() : loginIntercom()
            return false
        case IdPermissionChat:
            HomeEventCollector.send(category: .homeEvent, subCategory: .mainView, event: .tapNavBarChat, action: .click)
            ZeusCoreInterceptor.Navigator.shared.startFlow(forAction: ZCIExternalZeusKeys.chatZeus, navigateDelegate: self)
            return false
        case notificationPermission:
            HomeEventCollector.send(category: .homeEvent, subCategory: .mainView, event: .tapNavBarNotification, action: .click)
        case idSocialNetwork:
            Navigator.shared.startFlow(forAction: ZCIExternalZeusKeys.socialNetwork, navigateDelegate: self)
            return false
        case 1:
            HomeEventCollector.send(category: .homeEvent, subCategory: .mainView, event: .tapNavBarHome, action: .click)
        default:
            return true
        }
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.tabBar.selectionIndicatorImage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // delay for bounds
            self.updateTabbarIndicatorBySelectedTabIndex(index: self.currentIndex)
        }
    }
    
    private func updateTabbarIndicatorBySelectedTabIndex(index: Int) -> Void {
        guard self.tabBar.items?.isEmpty == false else { return }
        self.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicatorTabBarItem(color: SessionInfo.shared.company?.primaryUIColor ?? .yellow, size: CGSize(width: 60, height: self.tabBar.frame.height), lineHeight: 4)
        self.currentIndex = index
    }
    
    func openHamburguerMenu() {
        HomeEventCollector.send(category: .homeEvent, subCategory: .mainView, event: .tapSideMenu, action: .click)
        UserDefaultsManager.setBool(key: .isGuestUser, value: false)
        let detailMenu = DetailMenuRouter.createModule(menuPermissions: menuSlideTemp)
       
        
        self.presentSlide(detailMenu, direction: .right, permissionModel: menuSlideTemp)
    }
    
 
    func loginIntercom() {
        if let id = SessionInfo.shared.user?.zeusId,
           let name = SessionInfo.shared.user?.name,
           let lastName = SessionInfo.shared.user?.lastName,
           let secondLastName = SessionInfo.shared.user?.secondLastName,
           let companyId = SessionInfo.shared.company?.companyId,
           let companyName = SessionInfo.shared.company?.name {
            ZeusIntercomSDK.intercomLogin(zeusId: id,
                                          employeeName: "\(name) \(lastName) \(secondLastName)",
                                          companyId: "\(companyId)",
                                          companyName: companyName) {
                self.openModuleIntercom()
            }
        }
    }
    
    func openModuleIntercom() {
        if let id = SessionInfo.shared.user?.zeusId,
           let name = SessionInfo.shared.user?.name,
           let navigation = self.navigationController {
            ZeusIntercomSDK.openModule(in: navigation,
                                       zeusId: id,
                                       employeName: name)
            IntercomEvents.shared.sendEvent(.menuIntercom)
        }
    }
}
