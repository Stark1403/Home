//
//  EmptyContactsView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 25/09/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo
import Lottie
class EmptyContactsView : UIView {
    
    lazy var emptyStateLottie: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "zhc_not_found")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(style: .headline2(isItalic: false))
        lbl.text = "¡Parece que aún no hay \nnada por aquí!"
        lbl.textColor = UIColor(hexString: "#393647")
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var subTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(style: .bodyTextXL(variant: .regular, isItalic: false))
        lbl.text = "Recuerda que solo podrás agregar un \nmáximo de 3 contactos."
        lbl.textColor = UIColor(hexString: "#69657B")
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    private func setupConstraints(){
        addSubview(emptyStateLottie)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        NSLayoutConstraint.activate([
            emptyStateLottie.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            emptyStateLottie.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLottie.topAnchor.constraint(equalTo: topAnchor),
            emptyStateLottie.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            titleLabel.topAnchor.constraint(equalTo: emptyStateLottie.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class NumberIndicatorView : UIView {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F5F5F7")
        view.layer.borderColor = UIColor(hexString: "#CCCBD2").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var flagImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "mexicoFlagIc", in: Bundle.local, with: nil)
        iv.backgroundColor = .clear
        return iv
    }()
    
    lazy var numberLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "+52"
        lbl.textAlignment = .center
        lbl.textColor = UIColor(hexString: "#21222C")
        lbl.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    var shouldShrinkView: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
     func setupConstraints(shouldShrinkView: Bool = false){
        addSubview(containerView)
        containerView.addSubview(flagImageView)
        containerView.addSubview(numberLabel)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 56),
//            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: shouldShrinkView ? -8 : 0),
            
            flagImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            flagImageView.heightAnchor.constraint(equalToConstant: 20),
            flagImageView.widthAnchor.constraint(equalToConstant: 20),
            
            numberLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 5),
            numberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
