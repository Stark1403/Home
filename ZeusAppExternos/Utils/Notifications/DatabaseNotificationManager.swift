//
//  DatabaseNotificationManager.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Perez on 10/19/23.
//
import Foundation
import SQLite3
import ZeusUtils

public class DatabaseNotificationManager {
    public static let shared = DatabaseNotificationManager()
    var db:OpaquePointer? = nil
    internal var isInitDB = false
    internal var isInitTables = false
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    private func initDB() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Notifications.sqlite")
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            self.isInitDB = false
            PrintManager.print("error opening database notifications")
            return
        } else {
            PrintManager.print("Successfully opened connection to database at \(fileURL.absoluteString)")
            self.isInitDB = true
        }

    }
    
    public func createDB() {
        if db == nil { self.initDB() }
        var ok = true
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS notificationstatus (notification_id TEXT, status INTEGER, PRIMARY KEY (notification_id))", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            PrintManager.print("Zeus: error creating table training: \(errmsg)")
            ok = false
        }

        self.isInitTables = ok
    }
    
    func saveNotificationStatus(notification: NewNotification) {
        //creating a statement an query
        var stmt: OpaquePointer?
        let queryString = "INSERT INTO notificationstatus (notification_id, status) VALUES (?,?)"
        
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            PrintManager.print("Zeus: error preparing insert in table notificationstatus: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, String(notification.id), -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            PrintManager.print("Zeus: failure binding id in table notificationstatus: \(errmsg)")
            return
        }
        if sqlite3_bind_int(stmt, 2, Int32(notification.status)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            PrintManager.print("Zeus: failure binding status in table notificationstatus: \(errmsg)")
            return
        }

        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            PrintManager.print("Zeus: failure inserting status in table notificationstatus: \(errmsg)")
            return
        }
        
        //finalize OpaquePointer
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            PrintManager.print("Zeus: error finalize stmt in notificationstatus: \(errmsg)")
        }
        
    }
    
    func getNotificationStatus(idNotification: String) -> Int {
        let queryString = "SELECT status FROM notificationstatus WHERE notification_id = '\(idNotification)'"
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            // Ejecuta la consulta SQL
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let iterations = sqlite3_column_int(queryStatement, 0)
                sqlite3_finalize(queryStatement)
                return Int(iterations)
            } else {
                sqlite3_finalize(queryStatement)
                return 1
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            PrintManager.print("Error al preparar la consulta: \(errorMessage)")
            return 1
        }
    }
}
