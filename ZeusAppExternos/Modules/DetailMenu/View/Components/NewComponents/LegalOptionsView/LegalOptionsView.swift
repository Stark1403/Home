//
//  LegalOptionsView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 02/05/24.
//

import UIKit
import ZeusCoreDesignSystem
class LegalOptionsView: UIView {

    lazy var headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backArrowIV: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "arrow-back")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var userNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Legales"
        lbl.font = UIFont(style: .headline3(isItalic: false))
        lbl.textColor = UIColor(hexString: "#69657B")
        return lbl
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#69657B")
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        let cutomSmallSeparatorView1 = CutomSmallSeparatorView()
        let cutomSmallSeparatorView2 = CutomSmallSeparatorView()
        [termsView, privacyView].forEach{ sv.addArrangedSubview($0) }
        return sv
    }()
    
    lazy var termsView: NewLegalUserViewTwo = {
        let view = NewLegalUserViewTwo()
        view.setView(title: "Términos y condiciones", isFromLegalOption: true, optionType: "terms")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var privacyView: NewLegalUserViewTwo = {
        let view = NewLegalUserViewTwo()
        view.setView(title: "Aviso de privacidad", isFromLegalOption: true, optionType: "priv")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
        setupGestureRecognizers()
        
        //Legal
        SideMenuCollector.send(category: .legalSideBar, subCategory: .legalDetail, event: .openView, action: .view, metadata: "")
    }
    
    var goToOptionCallBack: ((_ goToTerms: Bool) -> Void)? = nil
    var dismissViewCallBack: ((_ dismissView: Bool) -> Void)? = nil
    
    
    private func setupViewLayout(){
        
        addSubview(headerContainerView)
        headerContainerView.addSubview(backArrowIV)
        headerContainerView.addSubview(userNameLbl)
        headerContainerView.addSubview(separatorView)
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            headerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            userNameLbl.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 60),
            userNameLbl.leadingAnchor.constraint(equalTo: backArrowIV.trailingAnchor, constant: 10),
            userNameLbl.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            userNameLbl.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -20),
            
            backArrowIV.centerYAnchor.constraint(equalTo: userNameLbl.centerYAnchor),
            backArrowIV.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            backArrowIV.heightAnchor.constraint(equalToConstant: 25),
            backArrowIV.widthAnchor.constraint(equalToConstant: 25),
            
            separatorView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 70),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            stackView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
        ])
    }
    
    func setupGestureRecognizers(){
        let tapTerms = UITapGestureRecognizer(target: self, action: #selector(goToSelectedOption))
        let tapPrivacy = UITapGestureRecognizer(target: self, action: #selector(goToSelectedPrivacy))
        let tapDismissView = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        
        backArrowIV.addGestureRecognizer(tapDismissView)
        termsView.addGestureRecognizer(tapTerms)
        privacyView.addGestureRecognizer(tapPrivacy)
        
    }
    
    @objc func goToSelectedOption(){
        goToOptionCallBack?(true)
    }
    
    @objc func goToSelectedPrivacy(){
        goToOptionCallBack?(false)
    }
    
    @objc func dismissView(){
        dismissViewCallBack?(true)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        configureConstraints()
    }
    
    func set(udnColor: UIColor?) {
        //        image.tintColor = udnColor
    }

}

