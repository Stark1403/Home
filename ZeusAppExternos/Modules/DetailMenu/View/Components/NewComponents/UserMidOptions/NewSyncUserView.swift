//
//  NewSyncUserView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 29/04/24.
//

import UIKit
import ZeusCoreDesignSystem
import ZeusNewSurveys
class NewSyncUserView: UIView {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var syncImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(materialIcon: .cloudDone)?.withTintColor(.dark600 ?? .black, renderingMode: .alwaysTemplate)
        iv.tintColor = .black
        return iv
    }()
    
    lazy var precentageLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sincronización - 100%"
        lbl.font = UIFont(style: .bodyTextL(variant: .regular, isItalic: false))
        return lbl
    }()
    
    lazy var filesSyncLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0/0 archivos sincronizados"
        lbl.font = UIFont(style: .bodyTextM(variant: .regular, isItalic: false))
        return lbl
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 2
        [precentageLabel, filesSyncLabel].forEach{ sv.addArrangedSubview($0) }
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
        setSyncItems()
        NotificationCenter.default.addObserver(self, selector: #selector(setSyncItems), name: Notification.Name("SyncFile"), object: nil)
    }
    
    @objc private func setSyncItems(){
            let totalItems = SurveysMultimediaSendingManager.shared.totalItemsToSincronize()
            let sincronizedItems = SurveysMultimediaSendingManager.shared.totalItemsSincronized()
            
            filesSyncLabel.text = "\(sincronizedItems)/\(totalItems) archivos sincronizados"
            
            let percentage = calculatePercentage(part: Double(sincronizedItems), total: Double(totalItems))
            precentageLabel.text = "Sincronización - \(percentage ?? 0)%"
        }
        
        private func calculatePercentage(part: Double, total: Double) -> Int? {
            guard total != 0 else {
                return 100
            }
            
            let percentage = (part / total) * 100
            return Int(percentage)
        }
    
    private func setupViewLayout(){
        addSubview(containerView)
        containerView.addSubview(syncImageView)
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            syncImageView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            syncImageView.heightAnchor.constraint(equalToConstant: 20),
            syncImageView.widthAnchor.constraint(equalToConstant: 20),
            syncImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            stackView.leadingAnchor.constraint(equalTo: syncImageView.trailingAnchor, constant: 12)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        configureConstraints()
    }
    
    func set(udnColor: UIColor?) {
        //        image.tintColor = udnColor
    }
}
