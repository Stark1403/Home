//
//  GuestHomeMenuViewController+Views.swift
//  ZeusAppExternos
//
//  Created by Rafael on 22/08/23.
//
import UIKit

//Use this class to create views inside of GuestHomeMenuViewController
class GuestHomeMenuViews {
    
    let detailedMenuView = DetailMenuView()
    
    let shadowGray: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}
