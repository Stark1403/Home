//
//  MyPrivateDataView.swift
//  ZeusAppExternos
//
//  Created Satori Tech 209 on 11/5/24.
//  Template generated by UPAX Zeus
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo

class MyPrivateDataView: UIView {
    // MARK: Child views
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var segmentedController: ZDSSegmentedController = {
        let sc = ZDSSegmentedController()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.numberOfSegments = 2
        sc.segmentsTitle = "Datos privados, Dirección"
        sc.currentIndexTitleColor = SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor ?? .purple
        sc.otherIndexTitleColor = UIColor(hexString: "#393647")
        sc.currentIndexBackgroundColor = SessionInfo.shared.company?.primaryUIColor ?? .zeusPrimaryColor ?? .purple
        return sc
    }()
    
    lazy var privateDataView: PrivateData = {
        let view = PrivateData()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: ADDRESS
    lazy var mainScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    lazy var streetField: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "Calle"
        tf.keyboardType = .alphabet
        tf.maxWidth = 40
        return tf
    }()
    
    lazy var outerNumberField: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "No. Exterior"
        tf.keyboardType = .numberPad
        return tf
    }()
    lazy var interiorNumberField: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "No. Interior"
        tf.keyboardType = .numberPad
        return tf
    }()

    lazy var CPField: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "C.P."
        tf.keyboardType = .numberPad
        return tf
    }()
    

    
    lazy var dropDown: ZDSDropdownView = {
        var dropdown = ZDSDropdownView()
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        dropdown.hint = "Colonia"
        return dropdown
    }()
    
    lazy var municipalityField: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "Municipio/Delegación"
        tf.disabled = true
        tf.keyboardType = .alphabet
        return tf
    }()
    
    lazy var stateField: ZDSTextField = {
        var tf = ZDSTextField()
        tf.title = "Estado"
        tf.disabled = true
        tf.keyboardType = .alphabet
        return tf
    }()
    
    lazy var updateBtn: ZDSButton = {
        var btn = ZDSButton()
        btn.style = .primary
        btn.title = "Actualizar direccion"
        btn.disabled = true
        btn.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .purple
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .mediumA
        stack.addArrangedSubview(streetField.asUIKitView())
        stack.addArrangedSubview(outerNumberField.asUIKitView())
        stack.addArrangedSubview(interiorNumberField.asUIKitView())
        stack.addArrangedSubview(CPField.asUIKitView())
        stack.addArrangedSubview(dropDown)
        stack.addArrangedSubview(municipalityField.asUIKitView())
        stack.addArrangedSubview(stateField.asUIKitView())
        return stack
    }()
    
    // MARK: Initializers
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

