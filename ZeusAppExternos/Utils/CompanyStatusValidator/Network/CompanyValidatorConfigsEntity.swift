//
//  CompanyValidatorConfigsEntity.swift
//  ZeusAppExternos
//
//  Created by Rafael on 16/11/23.
//

import Foundation
import ZeusSessionInfo
import UPAXNetworking

struct CompanyConfigurationRequest: UNCodable {
    let id: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case lastName = "last_name"
    }
    
    func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "id", serializedName: "id", requiresEncryption: false),
            .init(property: "lastName", serializedName: "last_name", requiresEncryption: false)
        ]
    }
}

// MARK: - CompanyConfigurationResponse
struct CompanyConfigurationResponse: UNCodable {
    let id: String
    let company: CompanyResponse
    let name:String
    let lastName:String?
    let email:String?
    let phoneNumber: String?
    let secondLastName: String?
    let position: String?
    let employeeNumber: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case company
        case name = "name"
        case lastName = "last_name"
        case email = "email"
        case phoneNumber = "phone_number"
        case secondLastName = "second_last_name"
        case position = "position"
        case employeeNumber = "employee_number"
        case profileImage = "profile_image"
    }
    
    func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "id", requiresEncryption: false),
            .init(property: "company", requiresEncryption: false),
            .init(property: "name",serializedName:  "name"),
            .init(property: "lastName",serializedName: "last_name"),
            .init(property: "email",serializedName: "email"),
            .init(property: "phoneNumber",serializedName: "phone_number"),
            .init(property: "secondLastName",serializedName: "second_last_name"),
            .init(property: "position",serializedName: "position"),
            .init(property: "employeeNumber",serializedName: "employee_number"),
            .init(property: "profileImage",serializedName: "profile_image"),
            
        ]
    }
    
    func saveSessionInfo() {
        let company = ZeusSessionInfo.Company(zeusId: id,
                                              companyId: company.id,
                                              name: company.name,
                                              photo: company.logo ?? "",
                                              miniature: company.logo ?? "",
                                              primaryColor: company.configuration.color ?? "",
                                              secondaryColor: company.configuration.font ?? "",
                                              titleColor: company.configuration.font ?? "",
                                              iconColor: company.configuration.color ?? "",
                                              planLevel: 0)
        
        SessionInfoQueries.shared.insertCompany(company, updatingSingleton: false)
    }
    
    func saveSessionInfoUser(){
        guard let user = SessionInfo.shared.user else {return}
        SessionInfoQueries.shared.updateUserInfo(user: User(zeusId: user.zeusId, employeeNumber: user.employeeNumber, name: name, lastName: lastName ?? user.lastName, secondLastName: secondLastName ?? user.secondLastName, photo: (profileImage ?? user.photo) ?? "", job: (position ?? user.job) ?? "", area: user.area , mail: (email ?? user.mail) ?? "", phoneNumber: (phoneNumber ?? user.phoneNumber) ?? "", countryCode: user.countryCode, leaderZeusId: user.leaderZeusId, udnId: user.udnId, companyIdentifier: user.companyIdentifier))
    }
}


// MARK: - Company
struct CompanyResponse: UNCodable {
    let configuration: CompanyConfiguration
    let id: Int
    let name: String
    let logo: String?
    
    enum CodingKeys: String, CodingKey {
        case configuration
        case id
        case name
        case logo
    }
    
    func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "configuration", requiresEncryption: false),
            .init(property: "id", requiresEncryption: false),
            .init(property: "name", requiresEncryption: false),
            .init(property: "logo", requiresEncryption: false)
        ]
    }
    
}

// MARK: - Configuration
struct CompanyConfiguration: UNCodable {
    let color, font: String?
    
    enum CodingKeys: String, CodingKey {
        case color
        case font
    }
    
    func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "color", requiresEncryption: false),
            .init(property: "font", requiresEncryption: false)
        ]
    }
    
}

