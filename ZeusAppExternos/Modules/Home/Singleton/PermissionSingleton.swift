//
//  PermissionSingleton.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 14/12/23.
//

import Foundation

class PermissionSingleton {
    static let shared = PermissionSingleton()
    private var showHamburguerMenu = true
    private var showEntry = true
    private var showHelp = true
    private var showGafete = true
    
    func getValueForHamburgueMenu() -> Bool {
        return self.showHamburguerMenu
    }
    
    func setValueForHamburgueMenu(value: Bool) {
        self.showHamburguerMenu = value
    }
    
    func getValueForEntry() -> Bool {
        return self.showEntry
    }
    
    func setValueForEntry(value: Bool) {
        self.showEntry = value
    }
    
    func getValueForGafete() -> Bool {
        return self.showGafete
    }
    
    func setValueForGafete(value: Bool) {
        self.showGafete = value
    }
    
    func getValueForHelp() -> Bool {
        return self.showHelp
    }
    
    func setValueForHelp(value: Bool) {
        self.showHelp = value
    }
    
    
}
