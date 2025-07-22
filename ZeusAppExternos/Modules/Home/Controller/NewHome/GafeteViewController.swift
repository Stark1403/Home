//
//  ModalViewController.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 26/06/24.
//

import Foundation
import UIKit
import ZeusSessionInfo

class GafeteViewController: UIViewController {

    var userFirstName: String = ""
    var userLastName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25,
                       delay: 0.25,
                       options: [.curveEaseInOut],
                       animations: {
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        },
        completion: nil)
    }

    private func setupContainerView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        // Constraints for the container view
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7)
        ])
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = SessionInfo.shared.company?.primaryUIColor ?? UIColor.clear
        profileImageView.layer.cornerRadius = 70
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.masksToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create initials label
        let initialsLabel = UILabel()
        initialsLabel.text = "\(userFirstName.prefix(1))\(userLastName.prefix(1))"
        initialsLabel.textAlignment = .center
        initialsLabel.textColor = .white
        initialsLabel.font = UIFont.boldSystemFont(ofSize: 48)
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let photo = SessionInfo.shared.user?.photo {
            profileImageView.downloadImage(from: photo, placeHolderImageName: nil, in: Bundle.local) { v, image in
                DispatchQueue.main.async {
                    profileImageView.image = image
                }
                
            }
        } else {
            profileImageView.addSubview(initialsLabel)
        }
        
        containerView.addSubview(profileImageView)
        
        if SessionInfo.shared.user?.photo == nil {
            // Constraints for the profile image view and initials label
            NSLayoutConstraint.activate([
                profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -50),
                profileImageView.widthAnchor.constraint(equalToConstant: 140),
                profileImageView.heightAnchor.constraint(equalToConstant: 140),
                
                initialsLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
                initialsLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
            ])
        } else {
            // Constraints for the profile image view and initials label
            NSLayoutConstraint.activate([
                profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -50),
                profileImageView.widthAnchor.constraint(equalToConstant: 140),
                profileImageView.heightAnchor.constraint(equalToConstant: 140),
            ])
        }
        
        
        // Empresa logo image
        let companyLogoImageView = UIImageView(image: SessionInfo.shared.company?.logo)
        companyLogoImageView.contentMode = .scaleAspectFit
        companyLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(companyLogoImageView)
        
        // Nombre del usuario
        let nameLabel = UILabel()
        var firstPartName = userFirstName
        var secondPartName = ""
        if userFirstName.contains(" ") {
            firstPartName = userFirstName.components(separatedBy: " ")[0]
        }
        secondPartName = userLastName
        nameLabel.text = firstPartName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 48)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        
        let lastNameLabel = UILabel()
        lastNameLabel.text = "\(secondPartName)"
        lastNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        lastNameLabel.textAlignment = .center
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lastNameLabel)
        
        // Puesto
        let puestoLabel = UILabel()
        puestoLabel.text = "Puesto: \(SessionInfo.shared.user?.job ?? "")"
        puestoLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        puestoLabel.textAlignment = .center
        puestoLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(puestoLabel)
        
        // Área
        let areaLabel = UILabel()
        areaLabel.text = "Área: \(SessionInfo.shared.user?.area ?? "")"
        areaLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        areaLabel.textAlignment = .center
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(areaLabel)
        
        // ID
        let idLabel = UILabel()
        idLabel.text = "ID: \(SessionInfo.shared.user?.employeeNumber ?? "")"
        idLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        idLabel.textAlignment = .center
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(idLabel)
        
        /*let companyNameLabel = UILabel()
        companyNameLabel.text = " \(SessionInfo.shared.company?.name ?? "")"
        companyNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        companyNameLabel.textAlignment = .center
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(companyNameLabel)*/
        
        let vigencyLabel = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        vigencyLabel.text = "Vigencia: \(formatter.string(from: Date()))"
        vigencyLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        vigencyLabel.textAlignment = .center
        vigencyLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(vigencyLabel)
        
        // Constraints for additional labels
        NSLayoutConstraint.activate([
            companyLogoImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30),
            companyLogoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            companyLogoImageView.widthAnchor.constraint(equalToConstant: 100),
            companyLogoImageView.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: companyLogoImageView.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 44),
            
            lastNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            lastNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            lastNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            lastNameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            puestoLabel.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 30),
            puestoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            puestoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            areaLabel.topAnchor.constraint(equalTo: puestoLabel.bottomAnchor, constant: 10),
            areaLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            areaLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            idLabel.topAnchor.constraint(equalTo: areaLabel.bottomAnchor, constant: 10),
            idLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            /*companyNameLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 40),
            companyNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            companyNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
             */
            
            vigencyLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            vigencyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            vigencyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmiss))
        self.view.addGestureRecognizer(tap)

    }
    
    @objc func dissmiss() {
        self.view.backgroundColor = UIColor.clear
        self.dismiss(animated: true)
    }

    
    static func present(from parentVC: UIViewController, firstName: String, lastName: String) {
        GafeteEventCollector.send(category: .homeEvent, subCategory: .mainView, event: .gafete, action: .view)
        let modalVC = GafeteViewController()
        modalVC.userFirstName = firstName
        modalVC.userLastName = lastName
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.transitioningDelegate = modalVC
        parentVC.present(modalVC, animated: true, completion: nil)
    }
}

extension GafeteViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInFromRightTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideOutToRightTransition()
    }
}

class SlideInFromRightTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        toViewController.view.frame = finalFrame.offsetBy(dx: containerView.frame.width, dy: 0)
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.frame = finalFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}

class SlideOutToRightTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        let initialFrame = transitionContext.initialFrame(for: fromViewController)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = initialFrame.offsetBy(dx: containerView.frame.width, dy: 0)
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}


