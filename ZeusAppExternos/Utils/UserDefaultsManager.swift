//
//  UserDefaults.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 11/09/23.
//

import Foundation

enum UserDefaultsKey: String {
    //    MARK: Token of push notifications
    case fcmTokenManager = "FCMTokenManager"
    
    //    MARK: Remote notifications from killed app
    case remoteNotification = "remoteNotification"
    
    //    MARK: Current chat active in foreground
    case currentChat = "currentChat"
    
    //    MARK: Movil Data is actived
    case mobileDataactivated = "mobileDataactivated"
    
    case isGuestUser = "isGuestUser"

    //    MARK: 
    case downloadInternalRegulations = "downloadInternalRegulations"
    
    //    MARK: syncFilesPercent in menu slide
    case syncFilesPercent = "syncFilesPercent"
    
    case firstUserLoad = "FirstUserLoad"
    
    case MyProfile = "MyProfile.DateValidationCode"
    
}

class UserDefaultsManager{
    
    public static func getString(key: UserDefaultsKey) -> String{
        guard let string = UserDefaults.standard.string(forKey: key.rawValue) else{
            return ""
        }
        return string
    }
    
    public static func setString(key: UserDefaultsKey, value: String){
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    public static func getDictionary(key: UserDefaultsKey) -> [String: Any]?{
        return  UserDefaults.standard.object(forKey: key.rawValue) as? [String: Any]
    }
    
    public static func getBool(key: UserDefaultsKey) -> Bool{
        if UserDefaults.standard.bool(forKey: key.rawValue){
            return true
        }
        return false
    }
    
    public static func setBool(key: UserDefaultsKey, value: Bool){
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    public static func setDictionary(key: UserDefaultsKey, value: [AnyHashable : Any]){
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    public static func getInt(key: UserDefaultsKey) -> Int{
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    public static func setInt(key: UserDefaultsKey, value: Int){
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    public static func removeObject(key: UserDefaultsKey){
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    public static func setIsFirstUserLoad(for zeusId: String, value: Bool){
        UserDefaults.standard.set(value, forKey: zeusId)
    }
    
    public static func getIsFirstUserLoad(for zeusId: String) -> Bool {
        if UserDefaults.standard.bool(forKey: zeusId){
            return true
        }
        return false
    }
    
    public static func setIsFirstUserLoadAnnouncements(for zeusId: String, value: Bool){
        UserDefaults.standard.set(value, forKey: "announcements-\(zeusId)")
    }
    
    public static func getIsFirstUserLoadAnnouncements(for zeusId: String) -> Bool {
        if UserDefaults.standard.bool(forKey: "announcements-\(zeusId)"){
            return true
        }
        return false
    }
}

