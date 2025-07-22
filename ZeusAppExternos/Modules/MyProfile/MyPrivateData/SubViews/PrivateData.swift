//
//  privateData.swift
//  ZeusAppExternos
//
//  Created by Satori Tech 209 on 11/5/24.
//

import Foundation
import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
class PrivateData : UIView {
    lazy var mainScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    
    lazy var RFCView: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "RFC"
        tf.disabled = true
        return tf
    }()
    
    lazy var CURPView: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "CURP"
        tf.disabled = true
        return tf
    }()
    
    lazy var INEView: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "INE"
        tf.disabled = true
        return tf
    }()

    lazy var NSSView: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "NSS"
        tf.disabled = true
        return tf
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = .mediumA
        stack.addArrangedSubview(RFCView.asUIKitView())
        stack.addArrangedSubview(CURPView.asUIKitView())
        stack.addArrangedSubview(INEView.asUIKitView())
        stack.addArrangedSubview(NSSView.asUIKitView())
        return stack
    }()
    
    public func setup(){
        backgroundColor = .white
        setupConstraints()
    }
    
    public func setData(data: PrivateDate){
        RFCView.text = data.rfc ?? ""
        CURPView.text = data.curp ?? ""
        INEView.text = data.ine ?? ""
        NSSView.text = data.nss ?? ""
    }
    
    private func setupConstraints(){
        addSubview(mainScrollView)
        mainScrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            mainScrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainScrollView.topAnchor.constraint(equalTo: topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
        ])
    }
    
}
