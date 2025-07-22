//
//  TabBarViewController+HomeViewControllerDelegate.swift
//  ZeusAppExternos
//
//  Created by Pedro Ivan Soriano Flores on 16/01/25.
//

import UIKit


extension TabBarViewController: HomeViewControllerDelegate {
    func pushToMainNavigationController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
