//
//  SyncedFiledView.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import UIKit
import ZeusUtils

final class SyncedFiledView: DetailMenuCell {
    
    lazy var progressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(style: .bodyTextS(variant: .semiBold))
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var progressBar: UIProgressView = {
        let view = UIProgressView()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(testing))
        view.addGestureRecognizer(recognizer)
        view.progress = 0.0
        view.layer.cornerRadius = 2.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(style: .bodyTextS())
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc
    func testing() {
        progressBar.setProgress(0.80, animated: true)
    }
    
    var barWidthContraint: NSLayoutConstraint?
    
    func updateWith(syncedFiles: Int, totalFiles: Int) {
        label.text = "\(syncedFiles)/\(totalFiles) archivos sincronizados"
        
        var percentage: Float = Float(syncedFiles) / Float(totalFiles)
        if percentage.isNaN || percentage.isInfinite {
            percentage = 1.0
        }
        
        progressLabel.text = String(format: "%.0f", percentage * 100) + "%"
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { [weak self] in
            self?.progressBar.setProgress(percentage, animated: true)
        }
    }
    
    override func configure() {
        titleLabel.text = "Archivos Sincronizados"
        iconView.image = UIImage(named: "folderTabBar")
        configureConstraints()
        contentStack.addArrangedSubview(progressView)
        contentStack.addArrangedSubview(label)
    }
    
    private func configureConstraints() {
        progressView.addSubview(progressBar)
        progressView.addSubview(progressLabel)
        
        NSLayoutConstraint.activate([
            progressLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: progressView.topAnchor, multiplier: 0.5),
            progressView.bottomAnchor.constraint(equalToSystemSpacingBelow: progressLabel.lastBaselineAnchor, multiplier: 0.5),
            progressLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: -12.0),
            
            progressBar.centerYAnchor.constraint(equalTo: progressLabel.centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4.0),
            progressBar.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: progressLabel.leadingAnchor, constant: -10.0),
        ])
    }
    
    override func set(udnColor: UIColor?) {
        progressBar.progressTintColor = udnColor
    }
}
