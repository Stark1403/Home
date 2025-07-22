//
//  DetailMenuInteractor.swift
//  ZeusAppExternos
//
//  Created by Angel Ruiz on 03/04/23.
//

import Foundation
import ZeusSessionInfo

final class DetailMenuInteractor: DetailMenuInteractorProtocol {

    weak var presenter: DetailMenuPresenterProtocol?
    
    var syncedFiles = 0
    var totalNumberOfFiles = 0
    
    var totalMessages = 0
    var syncedMessages = 0
    
    func getInitialData() {
        getInitialNumberOfFiles()
        getComunicadosSyncData()
        updateView()
        getAppVersion()
    }
    
    func updateUIWithSyncData() {
        presenter?.updateWith(syncedFiles: syncedFiles, totalFiles: totalNumberOfFiles)
    }
    
    private func getInitialNumberOfFiles() {
        let hundredPercent = UserDefaultsManager.getInt(key: .syncFilesPercent)
        if hundredPercent == 0{
        }else{
            totalNumberOfFiles = hundredPercent
        }
    }
   
    private func getComunicadosSyncData() {
        if totalMessages == syncedMessages
        {
            totalMessages = 0
            syncedMessages = 0
        }
    }
    
    private func getAppVersion() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let _ = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
        presenter?.setApp(version: "v.\(appVersion)")
    }
    
    private func updateView() {
        presenter?.updateWith(syncedFiles: syncedFiles + syncedMessages, totalFiles: totalNumberOfFiles + totalMessages)
    }
}

extension DetailMenuInteractor{
    func updatePercentage(percentage: Int) {
        totalNumberOfFiles = UserDefaultsManager.getInt(key: .syncFilesPercent)
        let floatProgress: Float = Float(percentage) / 100
            
        syncedFiles = Int((floatProgress * Float(totalNumberOfFiles)).rounded())
        updateView()
        if percentage == 100 {
            UserDefaultsManager.setInt(key: .syncFilesPercent, value: 0)
        }
    }

    func updateHundredPercentValue(maximumValue: Int) {
        UserDefaultsManager.setInt(key: .syncFilesPercent, value: maximumValue)

        if syncedFiles >= totalNumberOfFiles {
            syncedFiles = 0
        }
        
        totalNumberOfFiles = maximumValue
        updateView()
    }
}
