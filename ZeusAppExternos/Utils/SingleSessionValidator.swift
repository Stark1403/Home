//
//  SingleSessionValidator.swift
//  ZeusAppExternos
//
//  Created by Jesus Rivera on 08/06/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import ZeusUtils
import ZeusSessionInfo

enum ZEUniqueSessionData {
    case multisession
    case otherActive
    case newSession
}

final class SingleSessionValidator {
    
    public static let shared = SingleSessionValidator()
    
    private static let usersCollection = "zeus_users"
    private static let sessionsCollection = "sessions"
    private static let deviceIDDocument = "deviceId"
    private static let isloggedDocument = "isLogged"
    private var listener: ListenerRegistration? = nil
    
    private var appGenericFirestore: Firestore? {
        
        guard let firebaseInstance = FirebaseInstanceManager.shared.getInstance(FirebaseInstance.genericApp) else { return nil }
        return Firestore.firestore(app: firebaseInstance)
    }
    
    private func areThereOthersSessionsActive(zeusId: String, deviceId: String) async -> Bool {
        do {
            let sessionsCollection = appGenericFirestore?.collection(SingleSessionValidator.usersCollection)
                .document(zeusId)
                .collection(SingleSessionValidator.sessionsCollection)
            
            let queryLogged = sessionsCollection?.whereField(SingleSessionValidator.isloggedDocument, isEqualTo: true)
            let queryResults = try await queryLogged?.getDocuments()
            
            if (queryResults?.isEmpty ?? true) {
                return false
            } else {
                var isNotCurrentDeviceId = false
                queryResults?.documents.forEach { document in
                    let data = document.data()
                    if let documentDeviceId = data[SingleSessionValidator.deviceIDDocument] as? String {
                        isNotCurrentDeviceId = documentDeviceId != deviceId
                    }
                }
                return isNotCurrentDeviceId
            }
        } catch {
            PrintManager.print("areThereOthersSessionsActive, error: \(error)")
            return false
        }
    }
    
    private func setSessionsInactive(zeusId: String, deviceId: String)  {
        if zeusId != "" {
            appGenericFirestore?.collection(SingleSessionValidator.usersCollection)
                .document(zeusId)
                .collection(SingleSessionValidator.sessionsCollection)
                .whereField(SingleSessionValidator.deviceIDDocument, isNotEqualTo: deviceId).getDocuments(completion: { (querySnapshot, err) in
                    if !(querySnapshot?.documents.isEmpty ?? true) {
                        querySnapshot?.documents.forEach({ document in
                            document.reference.updateData([SingleSessionValidator.isloggedDocument : false]) {errorUD in
                                PrintManager.print("setSessionsInactive, error: \(errorUD.debugDescription)")
                            }
                        })
                    }
                })
        }
    }
    
    private func registerSessionActive(
        zeusId: String,
        deviceId: String,
        logged: Bool
    ) {
        guard zeusId != "" else{
            return
        }
            
            
        let data: [String : Any] = [SingleSessionValidator.isloggedDocument: logged,
                                    SingleSessionValidator.deviceIDDocument: deviceId]
        
        let deviceIdDocument = appGenericFirestore?.collection(SingleSessionValidator.usersCollection)
            .document(zeusId)
            .collection(SingleSessionValidator.sessionsCollection)
            .document(deviceId)
        
        deviceIdDocument?.setData(data, merge: true) { err in
            PrintManager.print("registerSession, error: \(err.debugDescription)")
        }
        if logged{
            addPushNotificationCredentials()
        }
    }
    
    private func setSnapshotListener(zeusId: String, deviceId: String) {
        listener = appGenericFirestore?.collection(SingleSessionValidator.usersCollection)
            .document(zeusId)
            .collection(SingleSessionValidator.sessionsCollection)
            .document(deviceId).addSnapshotListener { snapshot, error in
                switch(snapshot, error){
                    case (.none, .none):
                        debugPrint("No data")
                        break
                    case (.some(let snapshot), _):
                        guard let data = snapshot.data() else {return}
                        guard let isLogged = data["isLogged"] as? Bool else {return}
                        if !isLogged{
                            SessionManager.logout(isRemoteLogOut: true)
                        }
                        break
                    case (.none, .some(let error)):
                        debugPrint("Error \(error)")
                        break
                }
            }
    }
  
  private func setUserEnableSnapshopListener(zeusId: String) {
    listener = appGenericFirestore?.collection(SingleSessionValidator.usersCollection)
      .document(zeusId).addSnapshotListener({ snapShot, error in
        switch(snapShot, error){
          case (.none, .none):
            debugPrint("No data")
            break
          case (.some(let snapshot), _):
            guard let data = snapshot.data() else {return}
            guard let isLogged = data["active"] as? Bool else {return}
            if !isLogged{
              SessionManager.logout(isRemoteLogOut: true)
            }
            break
          case (.none, .some(let error)):
            debugPrint("Error \(error)")
            break
        }
      })
  }
}

extension SingleSessionValidator {
    func confirmCurrentDeviceRegistration() {
        let zeusId = SessionInfo.shared.user?.zeusId ?? ""
        let deviceId = SessionInfo.shared.UUIDDevice
        setSessionsInactive(zeusId: zeusId, deviceId: deviceId)
        registerSessionActive(zeusId: zeusId, deviceId: deviceId, logged: true)
        setSnapshotListener(zeusId: zeusId, deviceId: deviceId)
        
    }
  
    func confirmNotDisableUser() {
      let zeusId = SessionInfo.shared.user?.zeusId ?? ""
      setUserEnableSnapshopListener(zeusId: zeusId)
    }
    
    
    func validate() async throws -> ZEUniqueSessionData {
        let zeusId = SessionInfo.shared.session?.zeusId ?? ""
        let deviceId = SessionInfo.shared.UUIDDevice
        let isMultiSession = false //userRepository.isMultiSession(zeusId)
        let isMultiSessionVIP = false //userRepository.isMultiSessionVIP(zeusId)
        let areThereActiveOtherSessions = await areThereOthersSessionsActive(zeusId: zeusId, deviceId: deviceId)
        
        if (isMultiSession || isMultiSessionVIP) {
            PrintManager.print("initSessions, multisession")
            return .multisession
        } else {
            if (areThereActiveOtherSessions) {
                PrintManager.print("initSessions, areThereActiveOtherSessions")
                return .otherActive
            } else {
                PrintManager.print("initSessions, No areThereActiveOtherSessions")
                registerSessionActive(zeusId: zeusId, deviceId: deviceId, logged: true)
                setSnapshotListener(zeusId: zeusId, deviceId: deviceId)
                return .newSession
            }
        }
    }
    
    func logOutSessionActive(){
        guard let zeusId = SessionInfo.shared.session?.zeusId else { return }
        let deviceId = SessionInfo.shared.UUIDDevice
        registerSessionActive(zeusId: zeusId, deviceId: deviceId, logged: false)
        listener?.remove()
    }
    
    func addPushNotificationCredentials() {
        
        guard let token = FCMTokenManager.shared.currentToken, token != "" else {
            return
        }
        guard let zeusId = SessionInfo.shared.session?.zeusId, zeusId != "" else { return }
        
        appGenericFirestore?.collection(SingleSessionValidator.usersCollection)
            .document(zeusId)
            .setData(
                [
                    "multi_session": false,
                    "multi_session_vip": false,
                    "platform": "ios",
                    "token": token
                ])
    }
    
    
    /// #Important
    /// This method clean token value in firestore to prevent to backend read whole documents and know wich iddevice is active
    /// Please call when the user do logout manually and check with android Team
    /// ASK to Gerardo about this fuctionality and the importance
    
    func removeTokenInZeusUsers(){
        guard let zeusId = SessionInfo.shared.session?.zeusId else{
            return
        }
        appGenericFirestore?.collection(SingleSessionValidator.usersCollection)
            .document(zeusId)
            .setData(
                [
                    "multi_session": false,
                    "multi_session_vip": false,
                    "platform": "ios",
                    "token": ""
                ])
    }
}
