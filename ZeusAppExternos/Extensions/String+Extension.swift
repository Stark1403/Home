//
//  String+date.swift
//  ZeusAttendance
//
//  Created by David on 29/07/20.
//  Copyright © 2020 Gabriel Briseño. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func toAvatarName() -> String{
        let fullName = self.components(separatedBy: " ")
        var avatarName = ""
        if !fullName.isEmpty{
            let firstName = fullName[fullName.startIndex]
            var secondName = ""
            if fullName.count <= 2{
                secondName = fullName[fullName.endIndex - 1]
            }else{
                secondName = fullName[fullName.endIndex - 2]
            }
            if !firstName.isEmpty{
                avatarName.append(firstName[firstName.startIndex])
            }
            if !secondName.isEmpty{
                avatarName.append(secondName[secondName.startIndex])
            }
        }
        return avatarName
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func getDate() -> Date? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           dateFormatter.locale = Locale(identifier: "es_MX")
           let date = dateFormatter.date(from: self)
           return date
       }
}

func convertDictionaryToJSONString(dictionary: [String: Any]) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    } catch {
        print("Error converting dictionary to JSON string: \(error)")
    }
    return nil
}
