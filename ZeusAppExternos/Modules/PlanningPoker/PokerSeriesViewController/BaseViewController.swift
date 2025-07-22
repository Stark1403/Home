//
//  BaseViewController.swift
//  LocationEKT
//
//  Created by ARIEL DIAZ on 4/20/19.
//  Copyright © 2019 Latbc. All rights reserved.
//

import UIKit
import ZeusCoreInterceptor
import ZeusCoreDesignSystem

class BaseViewController: ZDSUDNViewController {
    
    // MARK: Outlets
    @IBOutlet weak var cstBottomView: NSLayoutConstraint!
    
    // MARK: Attibutes
    weak var _placeholderView: AgilePlaceholderView!
    var _snackBar: UILabel!
    var _canShowSnackBar: Bool!
    var _toolBar: UIToolbar!
    var _pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBottomCst()
        _canShowSnackBar = true
    }
    
    override func backAction() {
    }
    
    @objc func backMethod() {
        ZCInterceptor.shared.releaseLastFlow()
    }
    
    func _showSnackBar(with text: String) {
        guard _canShowSnackBar else { return }
        _canShowSnackBar = false
        _snackBar = UILabel(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 0))
        _snackBar.textAlignment = .center
        _snackBar.numberOfLines = 0
        _snackBar.minimumScaleFactor = 0.5
        _snackBar.adjustsFontSizeToFitWidth = true
        _snackBar.textColor = .white
        _snackBar.backgroundColor = .black
        view.addSubview(_snackBar)
        _snackBar.text = text
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self._snackBar.frame = CGRect(x: 0, y: self.view.frame.height - 60, width: self.view.frame.width, height: 60)
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000), execute: { [unowned self] in
                UIView.animate(withDuration: 0.3, animations: {
                    self._snackBar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
                }, completion: { [weak self] _ in
                    self?._canShowSnackBar = true
                })
            })
        })
    }
}


// MARK: PlaceholderViewMethods
extension BaseViewController {
    
    func _setPlaceholder(on view: UIScrollView, with message: String) {
        _placeholderView = nil
        _placeholderView = UIView.fromNib()
        if let tableView = view as? UITableView {
            tableView.backgroundView = _placeholderView
            
        } else if let collectionView = view as? UICollectionView {
            collectionView.backgroundView = _placeholderView
            
        } else if let placeholderView = _placeholderView {
            placeholderView.frame = view.bounds
            view.addSubview(placeholderView)
            
        }
        _placeholderView?.activityView.startAnimating()
        _placeholderView?.lblDescription.text = message
        
    }
    
    func _setPlaceholder(on view: UIView, with message: String) {
        _placeholderView?.removeFromSuperview()
        _placeholderView = nil
        _placeholderView = UIView.fromNib()
        if let placeholderView = _placeholderView {
            placeholderView.frame = view.bounds
            view.addSubview(placeholderView)
            
        }
        _placeholderView?.activityView?.startAnimating()
        _placeholderView?.lblDescription?.text = message
        
    }
    
    func _setPlaceholder(with error: String, image: UIImage?, retryAction: Bool) {
        _placeholderView?.btnRetry?.isHidden = retryAction
        if let image = image {
            _placeholderView?.set(with: image, color: .clear, description: error, retryAction: retryAction)
            
        } else {
            _placeholderView?.setPlaceholder(with: error)
            
        }
    }
    
    func _removePlaceholder() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?._placeholderView?.alpha = 0
                
            }, completion: { [weak self] _ in
                self?._placeholderView?.removeFromSuperview()
                self?._placeholderView = nil
                
            })
        }
    }
    
}

// MARK: settings
extension BaseViewController {
    func setBottomCst() {
        if screen.rawValue < ScreenHeight.iPhoneX.rawValue {
            cstBottomView?.constant = 0
        }
    }
}

enum ScreenHeight: CGFloat {
    case iPhoneSE=500, iPhone=600, iPhonePlus=700, iPhoneX=800
    
}

extension UIViewController {
    var screen: ScreenHeight {
        let height: CGFloat = self.view.frame.height
        return height < 600 ? .iPhoneSE : height < 700 ? .iPhone : height < 800 ? .iPhonePlus : .iPhoneX
        
    }
}
