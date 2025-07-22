//
//  CalendarModalView.swift
//  ZeusAppExternos
//
//  Created by Julio Cesar Michel Torres Licona on 16/01/25.
//

import Foundation
import UIKit
import ZeusCoreDesignSystem
import ZeusSessionInfo

protocol CalendarModalViewProtocol {
    func calendarDidAcceptSelection(_ date: Date?)
}

class CalendarModalViewController: UIViewController {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 16
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fecha de nacimiento"
        label.font = UIFont(style: .bodyTextXL(variant: .bold, isItalic: false))
        label.textColor = .black
        return label
    }()
    
    lazy var buttonClose: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    var calendar: ZDSCalendarView = {
        var calendar = ZDSCalendarView()
        calendar.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .systemBlue
        calendar.headerStyle = .selectMonthAndYear
        calendar.selectionStyle = .singleSelection
        return calendar
    }()
    
    lazy var calendarView: UIView = {
        return self.calendar.asUIKitView()
    }()
    
    var buttonAccept: ZDSButton = {
        var button = ZDSButton()
        button.setTitle("Elegir fecha", for: .normal)
        button.disabled = true
        button.primaryColor = SessionInfo.shared.company?.primaryUIColor ?? .systemBlue
        return button
    }()
    
    lazy var buttonAcceptView: UIView = {
        return self.buttonAccept.asUIKitView()
    }()
    
    private var selectedDate: Date?
    public var delegate: CalendarModalViewProtocol?
    var disabledWeekdays:[ZDSCalendarConfiguration.Weekday] = []
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        self.calendar.disabledWeekDays = self.disabledWeekdays
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !containerView.frame.contains(location) {
            dismissView()
        }
    }
    
    @objc private func acceptAction() {
        guard self.selectedDate != nil else { return }
        
        dismiss(animated: true) { [weak self] in
            self?.delegate?.calendarDidAcceptSelection(self?.selectedDate)
        }
    }
    
}

extension CalendarModalViewController {
    func setupLayout() {
        setupBackground()
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(buttonClose)
        containerView.addSubview(buttonAcceptView)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        buttonAcceptView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -26)
        ])
        
        NSLayoutConstraint.activate([
            buttonClose.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12),
            buttonClose.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            calendarView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            calendarView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
            calendarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            buttonAcceptView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            buttonAcceptView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
            buttonAcceptView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 40),
            buttonAcceptView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40)
        ])
        
        buttonClose.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        buttonAccept.onClick = { [weak self] in
            self?.acceptAction()
        }

        calendar.onChangeSelection = { [weak self] range in
            self?.buttonAccept.disabled = range.isEmpty
            self?.selectedDate = range[0]
        }
    }
    
    private func setupBackground() {
        view.backgroundColor = .clear
        UIView.animate(withDuration: 1, delay: 1) {
            self.view.backgroundColor = .black.withAlphaComponent(0.3)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
