//
//  ZDSGenericWebView.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 27/03/24.
//

import Foundation
import UIKit
import WebKit
import Alamofire
import ZeusCoreDesignSystem
import ZeusCoreInterceptor
import ZeusSessionInfo

public class ZDSGenericWebView: ZDSUDNViewController, UIWebViewDelegate, WKNavigationDelegate {
    var connectionAvailable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    public var url = ""
    var webV = WKWebView()
    var failClosure: (() -> Void)?
    
    override public func viewDidLoad() {
        self.headerColor = SessionInfo.shared.company?.primaryUIColor
        super.viewDidLoad()
        //TYC
        SideMenuCollector.send(category: .legalSideBar, subCategory: .tyc, event: .openView, action: .view, metadata: "")
        showNavBar()
        
        loadInfo()
    }
    
    func showNoInternetAlert() {
        let errorAlert = ZDSResultAlertViewController(typeLottie: .errorInternet, titulo: "¡Algo pasó!", descripcion: "Tuvimos un problema de conexión, inténtalo más tarde", textoBoton: "Entendido", color: SessionInfo.shared.company?.primaryUIColor, isShowBackButton: true)
        errorAlert.delegate = self
        errorAlert.navigationController?.isNavigationBarHidden = false
//        errorAlert.modalPresentationStyle = .overFullScreen
        present(errorAlert, animated: true)
    }
    
    func showNavBar() {
        self.view.backgroundColor = .getMainBackgroundColor()

        let btnAceptar = ZDSButtonAlt()
        btnAceptar.backgroundColor = SessionInfo.shared.company?.primaryUIColor
        btnAceptar.layer.cornerRadius = 10
        btnAceptar.titleLabel?.font = UIFont.customFont(named: "Avenir Black", size: 16)
        btnAceptar.titleLabel?.text = "Aceptar"
        btnAceptar.setTitle("Aceptar", for: .normal)
        btnAceptar.addTarget(self, action: #selector(onBackClicked(_:)), for: .touchUpInside)
        webV.frame = CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 160)
        webV.backgroundColor = .clear
        webV.isOpaque = false
        webV.navigationDelegate = self

        view.addSubview(webV)
        view.addSubview(btnAceptar)
        webV.translatesAutoresizingMaskIntoConstraints = false
        btnAceptar.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            webV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webV.bottomAnchor.constraint(equalTo: btnAceptar.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            btnAceptar.heightAnchor.constraint(equalToConstant: 40),
            btnAceptar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAceptar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btnAceptar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btnAceptar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
        ])
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
        showDSLoader()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func backAction() {
        (navigationController as? ZCINavigationController)?.flowInfo = ["title": self.titleString ?? ""]
        ZCInterceptor.shared.releaseLastFlow()
    }
    
    @objc private func onBackClicked(_ sender: Any) {
        (navigationController as? ZCINavigationController)?.flowInfo = ["title": self.titleString ?? ""]
        ZCInterceptor.shared.releaseLastFlow()
        SideMenuCollector.send(category: .legalSideBar, subCategory: .tyc, event: .tapTemsAndCond, action: .error, metadata: "Error en el servicio")
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                self?.hideDSLoader()
                
                if let nsError = error as NSError? {
                    self?.failClosure?()
                    if nsError.code == NSURLErrorNotConnectedToInternet {
                        // Handle the scenario when there's no internet connection
                        self?.showNoInternetAlert()
                    }
                }
            })
        }
    }
}

public class ZDSGenericWebViewFlows {

    public static func registerActions() {
        ZCInterceptor.shared.registerFlow(withNavigatorItem: ZDSGenericWebViewItem.self)
        ZCInterceptor.shared.registerFlow(withNavigatorItem: ZDSGenericWebViewItem.self)
    }
}

public class ZDSGenericWebViewItem: ZCInterceptorItem {
    static public func updateInfoFlow(withInfo parameters: [String : Any]?, withCurrent navigator: ZCINavigationController) {
        
    }
    
    public static var moduleName: String {
        return ZCIExternalZeusKeys.webView.rawValue
    }

    public static func createModule(withInfo parameters: [String : Any]?) -> UIViewController {
        let vc = ZDSGenericWebView()
        vc.url = parameters?["url"] as? String ?? ""
        
        if let failClosure = parameters?["eventFailed"] as? () -> Void {
            vc.failClosure = failClosure
        }
  
        if let title = parameters?["title"] as? String {
            vc.titleString = title
        }
        return vc
    }
}

extension ZDSGenericWebView: ZDSResultAlertViewControllerDelegate {
    func dismissC() {
        self.dismiss(animated: true) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    public func onSuccess() {
        dismissC()
    }
    
    public func onSecondary() {
        dismissC()
    }
    
    public func backButtonAction() {
        dismissC()
    }
}

