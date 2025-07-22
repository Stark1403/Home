//
//  FirebaseEntityGenerator.swift
//  ZeusAppExternos
//
//  Created by Jesus Rivera on 26/05/23.
//

import ZeusUtils
import Firebase
import FirebaseFirestore
import ZeusKeyManager

enum FirebaseInstance: String, CaseIterable {
    case genericApp = "ZeusGenericAppFirebase"
}

class FirebaseInstanceManager {
    
    static var shared = FirebaseInstanceManager()
    
    private enum FirebaseOptionsKeys: String {
        case databaseURL = "DatabaseURL"
        case storageBucket = "StorageBucket"
        case projectID = "ProjectID"
        case clientID = "ClientID"
        case apiKey = "APIKey"
        case bundleID = "BundleID"
        case gmcSenderID = "GmcSenderID"
        case googleAppID = "GoogleAppID"
    }
    
    private func getFirebaseOptions(for name: String) -> FirebaseOptions {
        let dict = ZKMConfiguration.dict(for: name)
        let builder = FirebaseOptions(googleAppID: dict[FirebaseOptionsKeys.googleAppID.rawValue] ?? "",
                                      gcmSenderID: dict[FirebaseOptionsKeys.gmcSenderID.rawValue] ?? "")
        builder.bundleID                = dict[FirebaseOptionsKeys.bundleID.rawValue] ?? ""
        builder.apiKey                  = dict[FirebaseOptionsKeys.apiKey.rawValue]
        builder.clientID                = dict[FirebaseOptionsKeys.clientID.rawValue]
        builder.databaseURL             = dict[FirebaseOptionsKeys.databaseURL.rawValue]?.replacingOccurrences(of: "\\", with: "")
        builder.storageBucket           = dict[FirebaseOptionsKeys.storageBucket.rawValue]
        builder.projectID               = dict[FirebaseOptionsKeys.projectID.rawValue]
        return builder
    }
    
    private func instanceNotExists(named name: String, defaultInstance: Bool = false) -> Bool {
        guard let firebaseApps = FirebaseApp.allApps else { return true }
        if defaultInstance { return FirebaseApp.app() == nil }
        for app in firebaseApps where app.value.name == name {
            return false
        }
        return true
    }
    
    func getInstance(_ instance: FirebaseInstance) -> FirebaseApp? {
        if instance == .genericApp {
            return getInstance(named: instance.rawValue, defaultInstance: true)
        }
        return getInstance(named: instance.rawValue)
    }
    
    func getInstance(named name: String, defaultInstance: Bool = false) -> FirebaseApp? {
        if defaultInstance || name == FirebaseInstance.genericApp.rawValue {
            guard instanceNotExists(named: name, defaultInstance: true) else { return FirebaseApp.app() }
                FirebaseApp.configure(options: getFirebaseOptions(for: name))
            return FirebaseApp.app()
        } else {
            guard instanceNotExists(named: name) else { return FirebaseApp.app(name: name) }
            FirebaseApp.configure(name: name, options: getFirebaseOptions(for: name))
            return FirebaseApp.app(name: name)
        }
    }
    
    func configure() {
        for instance in FirebaseInstance.allCases {
            _ = getInstance(instance)
        }
    }
}
