//
//  GuestHomeTabBar.swift
//  ZeusAppExternos
//
//  Created by Rafael on 17/08/23.
//

import Foundation
import UIKit
import ZeusUtils
import ZeusCoreDesignSystem
class GuestHomeTabBar: UITabBarController {
    
    private var currentIndex: Int = 0
    var tabItems: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .zeusPrimaryColor
        configureTabbar()
        createTabBarItems()
    }
    
    func createTabBarItems(){
        let tabZero = UIViewController()
        let tabOne = GuestHomeRouter.createModule()
        let tabZeroBarItem = UITabBarItem(title: "Menú", image: UIImage(named: "hamb.png"), selectedImage: UIImage(named: "hamb.png"))
        tabZeroBarItem.tag = 0
        let tabOneBarItem = UITabBarItem(title: "Inicio", image: UIImage(named: "Home.png"), selectedImage: UIImage(named: "Home-Selected.png"))
        tabOneBarItem.tag = 1
        tabZero.tabBarItem = tabZeroBarItem
        tabOne.tabBarItem = tabOneBarItem
        tabItems = [tabZero, tabOne]
        
        viewControllers = tabItems
        DispatchQueue.main.async {
            self.updateTabbarIndicatorBySelectedTabIndex(index: 1)
            self.selectedIndex = 1
        }
    }
    
    func configureTabbar(){
        self.tabBar.backgroundColor = UIColor.extraLight100
        self.tabBar.tintColor = .zeusPrimaryColor ?? .gray
        self.tabBar.layer.cornerRadius = 16
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    
    private func updateTabbarIndicatorBySelectedTabIndex(index: Int) -> Void {
        if index != 0 {
            guard let itemsCount = self.tabBar.items?.count else { return }
            
            let indicator = UIImage().createSelectionIndicatorTabBarItem(color: .zeusPrimaryColor ?? .gray,
                                                               size: CGSize(width: 60,
                                                                            height: self.tabBar.frame.height),
                                                               lineHeight: 4)
            self.tabBar.selectionIndicatorImage = indicator
            self.currentIndex = index
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            self.openHamburguerMenu(menuSlide: menuSlideGuest)
        }
    }
    
    func openHamburguerMenu(menuSlide: [GuestMenuList]) {
        var menuOptions: [PermissionMenuModel] = []
        menuSlide.forEach { data in
            menuOptions.append(data.getPermissionModel())
        }
        
        UserDefaultsManager.setBool(key: .isGuestUser, value: true)
        let detailMenu = DetailMenuRouter.createModule(menuPermissions: menuOptions, isGuest: true)
        self.presentSlide(detailMenu, direction: .right, permissionModel: menuOptions, isGuest: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.selectedIndex = 1
        }
    }
}
