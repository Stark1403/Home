//
//  RegisterActions.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 25/05/23.
//

import Foundation
import ZeusAnnouncements
import ZeusNewSurveys
import ZeusBox
import ZeusExternosLogin
import ZeusMissionVision
import ZeusChat
import ZeusTermsConditions
import ZeusAttendanceControl
import ZeusDocumentsRequest
import ZeusOrganizationalChart
import ZeusManagementIndicators
import ZeusCreateTask
import ZeusWorkFlow
import ZeusIntercomExterno
import ZeusCoreInterceptor
import ZeusVerifyCollaborator
import TalentoZeusMyTalent
import ZeusDocumentManager
import ZeusSocialNetwork
import ZeusWebviewsManager

class RegisterActions {
    static func registerActions() {
        MyProfileFlows.registerActions()
        CreateTaskFlows.registerActions()
        PlanningFlows.registerActions()
        ComunicadosFlows.registerActions()
        DriveFlows.registerActions()
        LoginFlows.registerActions()
        MissionFlows.registerActions()
        SurveysFlows.registerActions()
        AlertPrivacyTermsFlows.registerActions()
        ZDSGenericWebViewFlows.registerActions()
        ChatZeusFlows.registerActions()
        ManagementIndicatorsFlows.registerActions()
        AttendanceDetailsFlows.registerActions()
        DocumentsRequestFlows.registerActions()
        ZeusOrganizationalChartFlow.registerActions()
        ManagementIndicatorsFlows.registerActions()
        WorkFlowFlows.registerActions()
        ZeusIntercomExternoFlow.registerActions()
        ZeusVerifyCollaboratorFlows.registerActions()
        ZeusMyTalentFlow.registerActions()
        DocumentManagerFlows.registerActions()
        ZeusSocialNetworkFlows.registerActions()
        LaborQualityFlow.registerActions()
    }
    
//    MARK: Call removeModulesData() for every module that wants remove data in logout action
    static func removeModulesData() {
//        MARK: Examples of use
//        ChatZeusFlows.removeModulesData()
//        DriveItem.removeModulesData()
        ChatZeusFlows.removeModulesData()
    }
    
    static func updateInfoFlow(withInfo parameters: [String: Any]? = nil){
        guard let navigator = ZCInterceptor.shared.currentNavigatorController, let action = parameters?["action"] as? String else {
            return
        }

        let modulo = ZCIExternalZeusKeys(rawValue: action)
        
        switch modulo{
            case .tareasID:
                ExternalSurveysTasksFlow.updateInfoFlow(withInfo: parameters, withCurrent: navigator)
            case .chatZeus:
                ChatZeusItem.updateInfoFlow(withInfo: parameters, withCurrent: navigator)
            break
            default:
                return
        }
    }
}
