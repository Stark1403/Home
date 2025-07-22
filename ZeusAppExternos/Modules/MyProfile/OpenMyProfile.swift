//
//  OpenMyProfile.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 17/09/24.
//

import Foundation
import ZeusSessionInfo
import ZeusCoreInterceptor

public class MyProfileFlows {
    public static func registerActions() {
        ZCInterceptor.shared.registerFlow(withNavigatorItem: ExternalMyProfileFlow.self)
    }
}

public class ExternalMyProfileFlow : NavigatorItem {
    
    public static var moduleName: String {
        ZCIExternalZeusKeys.myProfile.rawValue
    }
    
    public static func createModule(withInfo parameters: [String : Any]?) -> UIViewController {
        let view = MyProfileViewController()
        MyAccountEvents.shared.sendEvent(.myAccount)
        return view
    }
    
    static public func openModule(in navigationController: UINavigationController, zeusId: String, employeName: String) {
//        shared = .init(zeusId: zeusId)
//        shared?.userName = employeName
        let intercomViewController = ExternalMyProfileFlow.createModule(withInfo: nil)
        navigationController.pushViewController(intercomViewController, animated: true)
    }
}
