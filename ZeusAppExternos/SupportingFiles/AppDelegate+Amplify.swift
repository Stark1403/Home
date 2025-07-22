//
//  AppDelegate+Amplify.swift
//  ZeusAppExternos
//
//  Created by Rafael - Work on 28/03/25.
//

import Amplify
import AmplifyPlugins
import ZeusKeyManager

extension AppDelegate {
    func initAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            let amplifyConfigurationFilename = TalentoZeusConfiguration.amplifyFilename
            
            if let amplifyConfiguration = Bundle.main.url(forResource: amplifyConfigurationFilename, withExtension: "json") {
                try Amplify.configure(AmplifyConfiguration(configurationFile: amplifyConfiguration))
                print("Amplify", "OK")
            }
        } catch {
            print("Amplify", error)
        }
    }
}
