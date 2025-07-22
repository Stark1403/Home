//
//  CompanyStatusValidator.swift
//  ZeusAppExternos
//
//  Created by Rafael on 24/08/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import ZeusSessionInfo
import ZeusExternosLogin
import ZeusAttendanceControl

class CompanyStatusValidator {
    
    public static let shared = CompanyStatusValidator()
    
    var listener: ListenerRegistration?
    
    var isBiometricsNeeded: Bool = false
    
    func activateValidator(companyID: String?, completion: ((_ isActive: Bool)->())?) {
        guard let companyID = companyID else {
            completion?(true)
            return
        }
        if let app = FirebaseInstanceManager.shared.getInstance(FirebaseInstance.genericApp) {
            let database = Firestore.firestore(app: app)
            self.listener?.remove()
            self.listener = database.collection("zeus_companies").document(companyID).addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                if let error = error {
                    debugPrint("::zeus_companies::", error)
                    completion?(true)
                    return
                } else {
                    guard let snapshot = snapshot else {
                        debugPrint("::zeus_companies:: NO SNAPSHOT")
                        completion?(true)
                        return
                    }
                    guard let data = snapshot.data() else {
                        completion?(true)
                        return
                    }
                    
                    //validate company configs
                    if let lastUpdate = data["update"] as? Double {
                        self.validateLastUpdate(lastUpdate)
                    }
                    
                    if let biometrics = data["biometrics"] as? Bool {
                        self.isBiometricsNeeded = biometrics
                        AttendanceOpenClass.shared.configureNotificationsActions(shouldUseBiometrics: biometrics)
                        print("---> biometrics: ", biometrics)
                    } else {
                        // Update documment if not exist
                        print("---> biometrics not exists")
                        let biometricsActive = ["biometrics": false]
                        database.collection("zeus_companies").document(companyID).updateData(biometricsActive)
                    }
                    
                    guard let active = data["active"] as? Bool else {
                        // Update documment if not exist
                        let status = ["active": true]
                        database.collection("zeus_companies").document(companyID).updateData(status)
                        completion?(true)
                        return
                    }
                    self.validateStatus(isActive: active)
                    completion?(active)
                    return
                }
            }
        }
    }
    
    private func validateStatus(isActive: Bool) {
        debugPrint(":: COMPANY STATUS (IS ACTIVE) ::", isActive)
        if !isActive {
            listener?.remove()
            SessionManager.logout(isRemoteLogOut: true)
        }
    }
    
    private func validateLastUpdate(_ timestamp: Double) {
        let lastLocalUpdate = UserDefaults.standard.getLastUpdateCompanyInfo()
        let lastRemoteUpdate = timestamp
        if lastLocalUpdate < lastRemoteUpdate {
            guard let companyId = UserDefaults.standard.getCompanyIdentifier(),
                  let lastName = SessionInfo.shared.user?.lastName else { return }
            CompanyValidatorNetwork().updateCompanyConfiguration(id: companyId, lastName: lastName)
        }
    }
}
