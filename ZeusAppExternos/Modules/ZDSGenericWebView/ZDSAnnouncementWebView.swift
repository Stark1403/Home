//
//  ZDSAnnouncementWebView.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 06/08/24.
//

import Foundation
import UIKit
import WebKit
import Alamofire
import ZeusCoreDesignSystem
import ZeusUtils
public class ZDSAnnouncementWebView: UIViewController, UIWebViewDelegate, WKNavigationDelegate, ZDSResultAlertViewControllerDelegate {
    
    var connectionAvailable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    public var url = ""
    public var titleView = ""
    var webV = WKWebView()
    var failClosure: (() -> Void)?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        //TYC
        SideMenuCollector.send(category: .legalSideBar, subCategory: .tyc, event: .openView, action: .view, metadata: "")
        showNavBar()
        
        loadInfo()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showNoInternetAlert() {
        let errorAlert = ZDSResultAlertViewController(typeLottie: .errorInternet, titulo: "¡Algo pasó!", descripcion: "Tuvimos un problema de conexión, inténtalo más tarde", textoBoton: "Entendido", color: UDNSkin.global.color, isShowBackButton: true)
        errorAlert.delegate = self
        errorAlert.navigationController?.isNavigationBarHidden = false
        errorAlert.modalPresentationStyle = .overFullScreen
        present(errorAlert, animated: true)
    }
    
    func showNavBar() {
        self.view.backgroundColor = .getMainBackgroundColor()
        
        let header = UIView()
        header.backgroundColor = UDNSkin.global.color
        let button = UIButton()
        button.setImage(UIImage(named: "left-icon"), for: .normal)
        button.addTarget(self, action: #selector(onBackClicked), for: .touchUpInside)
        let labelText = UILabel()
        labelText.text = self.titleView
        labelText.font = .header4
        labelText.textColor = .white
        labelText.numberOfLines = 1
        
        webV.frame = CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width - (UIScreen.main.bounds.height * 0.14))
        webV.backgroundColor = .clear
        webV.isOpaque = false
        webV.navigationDelegate = self

        view.addSubview(webV)
        view.addSubview(header)
        view.addSubview(button)
        view.addSubview(labelText)
        webV.translatesAutoresizingMaskIntoConstraints = false
        header.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        labelText.translatesAutoresizingMaskIntoConstraints = false
        
      
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            header.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.14),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 32),
            button.heightAnchor.constraint(equalToConstant: 32),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            labelText.heightAnchor.constraint(equalToConstant: 32),
            labelText.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 16),
            labelText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            labelText.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -16),
        ])
        
        // Constraints
        NSLayoutConstraint.activate([
            webV.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 0),
            webV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8)
        ])
        
    
    }
    
    @objc private func onBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadInfo() {
        guard let pdfURL = URL(string: url) else {
            guard connectionAvailable else {
                /// Internet connection lost
                showNoInternetAlert()
                self.failClosure?()
                return
            }
            self.failClosure?()
            /// Url fails
            return
        }
        let request = URLRequest(url: pdfURL)
        webV.load(request)
        guard connectionAvailable else {
            self.failClosure?()
            /// Internet connection lost
            return
        }
        showDSLoader(message: ZDSLoaderMessage(message: "Sólo tomará un momento conectarnosa los sistemas internos de Grupo Salinas", font: .headline3(isItalic: false)))
    }
    
    public func onSuccess() {
        self.dismiss(animated: false)
        self.dismiss(animated: true)
    }
    
    public func onSecondary() {
        self.dismiss(animated: false)
        self.dismiss(animated: true)
    }
    
    public func backButtonAction() {
        self.dismiss(animated: false)
        self.dismiss(animated: true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.hideDSLoader()
        })
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.failClosure?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                self?.hideDSLoader()
            })
        }
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async { [weak self] in
            if let nsError = error as NSError? {
                self?.failClosure?()
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    // Handle the scenario when there's no internet connection
                    self?.showNoInternetAlert()
                }
            }
        }
    }
}


