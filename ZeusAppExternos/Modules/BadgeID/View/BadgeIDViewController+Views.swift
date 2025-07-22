//
//  BadgeIDViewController+Views.swift
//  ZeusAppExternos
//
//  Created by Rafael on 19/12/23.
//
import UIKit
import ZeusUtils
import ZeusSessionInfo

//Use this class to create views inside of BadgeIDViewController
class BadgeIDViews {
    
    var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var logoBusinessImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultBusinessLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var waveOneImage: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "WaveOne", in: Bundle.local, compatibleWith: nil) {
            imageView.image = image.withRenderingMode(.alwaysTemplate)
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var waveTwoImage: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "WaveTwo", in: Bundle.local, compatibleWith: nil) {
            imageView.image = image.withRenderingMode(.alwaysTemplate)
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var waveThreeImage: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "WaveThree", in: Bundle.local, compatibleWith: nil) {
            let imageTemplate = image.withRenderingMode(.alwaysTemplate)
            imageView.image = imageTemplate.maskWithGradientColor(colors: [UIColor.white.cgColor, UIColor(red: 0.749, green: 0.757, blue: 0.749, alpha: 1.0).cgColor])
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var viewImageProfile: ProfileImageCircleView = {
        let view = ProfileImageCircleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var bottomSheet: ZUGenericBottomSheet?
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        return blurEffectView
    }()
    
    lazy var nameUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = .header2
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .textPrimary100
        label.textAlignment = .center
        let completeName = "\(SessionInfo.shared.user?.name ?? "")" +
        " \(SessionInfo.shared.user?.lastName ?? "")" +
        " \(SessionInfo.shared.user?.secondLastName ?? "")"
        label.text = completeName
        return label
    }()
    
    lazy var jobPositionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = .LText
        label.textColor = .textPrimary100
        label.textAlignment = .center
        if let jobPosition = SessionInfo.shared.user?.job, jobPosition != "" {
            label.text = "Puesto: \(jobPosition)"
        } else {
            label.text = ""
        }
        
        return label
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = .LText
        label.textColor = .textPrimary100
        label.textAlignment = .center
        let employeeNumber = "\(SessionInfo.shared.user?.employeeNumber ?? "")"
        if employeeNumber != "" {
            label.text = "ID: \(employeeNumber)"
        } else {
            label.text = ""
        }
        return label
    }()
    
    lazy var lifeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = .MBodyBlackText
        label.textColor = .init(hexString: "#333333")
        label.textAlignment = .center
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        label.text = "Vigencia: \(formatter.string(from: Date()))"
        return label
    }()
}
