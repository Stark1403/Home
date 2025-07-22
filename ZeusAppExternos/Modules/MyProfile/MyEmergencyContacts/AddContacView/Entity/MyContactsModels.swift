//
//  MyContactsModels.swift
//  ZeusAppExternos
//
//  Created by Manuel Alejandro Soberanis Mis on 30/09/24.
//

import UPAXNetworking

struct SendMyContactsRequestPath: UNCodable {
    let idColaborador: String
    let emergencyContact: [EmergencyContactPost]
    enum CodingKeys: String, CodingKey {
        case idColaborador = "id_collaborator"
        case emergencyContact = "emergencyContact"
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "idColaborador", serializedName: "id_collaborator", requiresEncryption: true),
        ]
    }
}

struct EmergencyContactPost: UNCodable {
    
    static func == (lhs: EmergencyContactPost, rhs: EmergencyContactPost) -> Bool {
        return false
    }
    
    static func < (lhs: EmergencyContactPost, rhs: EmergencyContactPost) -> Bool {
        let a = "\(lhs.name ?? "") \(lhs.surnames ?? "")"
        let b = "\(rhs.name ?? "") \(rhs.surnames ?? "")"
        return a < b
    }
    
    let id: Int
    let name: String?
    let surnames: String?
    let relationship: Int
    let phone: String?
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case surnames
        case relationship
        case phone
        case status = "status_contacto"
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "id", serializedName: "id", requiresEncryption: false),
            .init(property: "name", serializedName: "name", requiresEncryption: false),
            .init(property: "surnames", serializedName: "surnames", requiresEncryption: false),
            .init(property: "relationship", serializedName: "relationship", requiresEncryption: false),
            .init(property: "phone", serializedName: "phone", requiresEncryption: false),
            .init(property: "status", serializedName: "status_contacto", requiresEncryption: false)
        ]
    }
}

struct SendMyContactsResponseData: UNCodable {
    let emergencyContact: SendMyContactsResponse
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "emergencyContact", requiresEncryption: false)
        ]
    }
}

struct SendMyContactsResponse: UNCodable, Comparable{
    static func == (lhs: SendMyContactsResponse, rhs: SendMyContactsResponse) -> Bool {
        return false
    }
    
    static func < (lhs: SendMyContactsResponse, rhs: SendMyContactsResponse) -> Bool {
        let a = "\(lhs.name ?? "") \(lhs.surnames ?? "")"
        let b = "\(rhs.name ?? "") \(rhs.surnames ?? "")"
        return a < b
    }
  
    let id: Int
    let name: String?
    let surnames: String?
    let relationship: MyContactRelationship?
    let phone: String?
    
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "id", requiresEncryption: false),
            .init(property: "name", requiresEncryption: false),
            .init(property: "surnames", requiresEncryption: false),
            .init(property: "relationship", requiresEncryption: false),
            .init(property: "phone", requiresEncryption: false),
        ]
    }
}

struct MyContactRelationship: UNCodable {
    let id: Int
    let description: String
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "id", requiresEncryption: false),
            .init(property: "description", requiresEncryption: false),
        ]
    }
}


struct MyContactsListPathParams: UNCodable {
    let zeusID: String
    
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "zeusID", requiresEncryption: true)
        ]
    }
}
struct DeleteContactParams: UNCodable {
    let contactID: String
    
    private enum CodingKeys: String, CodingKey {
        case contactID = "id-contact"
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            
            .init(property: "contactID", serializedName: "id-contact",requiresEncryption: true)
        ]
    }
}

struct DeleteContactResponse: UNCodable {
    let message: String
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "message", requiresEncryption: false),
        ]
    }
}

// RESPONOSE AFTER SAVE

struct EmergencyContactResponseData: UNCodable {
    let emergencyContact: EmergencyContactResponse
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "emergencyContact", requiresEncryption: false),
        ]
    }
}

struct EmergencyContactResponse: UNCodable {
    let insurancePolicy: String?
    let familyMedicalUnit: String?
    let emergencyContact: [SendMyContactsResponse]

    enum CodingKeys: String, CodingKey {
        case insurancePolicy = "insurance_policy"
        case familyMedicalUnit = "family_medical_unit"
        case emergencyContact = "emergencyContact"
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "insurancePolicy", serializedName: "insurance_policy", requiresEncryption: false),
            .init(property: "familyMedicalUnit", serializedName: "family_medical_unit", requiresEncryption: false),
            .init(property: "emergencyContact", serializedName: "emergencyContact", requiresEncryption: false),
        ]
    }
}

// GET
struct EmergencyContact: UNCodable {
    let emergencyInformation: SendMyContactsListResponse
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "emergencyInformation", requiresEncryption: false),
        ]
    }
}

struct SendMyContactsListResponse: UNCodable {
    let emergencyContact: [SendMyContactsResponse]
    let medicalInformation: MedicalInformation

    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "emergencyContact", requiresEncryption: false),
            .init(property: "medicalInformation", requiresEncryption: false)
        ]
    }
    
    func getSortedData() -> [SendMyContactsResponse] {
        let data = emergencyContact.sorted(by: <)
        return data
    }
    
    func getUMFdata() -> [UMFdata] {
        return [
            UMFdata(id: 1, data1: "Unidad Médica No. \(medicalInformation.familyMedicalUnit ?? "-")", titleInt: medicalInformation.familyMedicalUnit ?? "-", data2: "NSS: \(medicalInformation.nss ?? "-")", image: "imss", color: .clear),
            UMFdata(id: 2, data1: "Póliza de seguro ", titleInt: "", data2: medicalInformation.insurancePolicy ?? "-", image: "stethoscope", color: UIColor(named: "udn-zeus-color") ?? .red)
        ]
    }
}

struct MedicalInformation: UNCodable {
  
    let insurancePolicy: String?
    let familyMedicalUnit: String?
    let nss: String?

    enum CodingKeys: String, CodingKey {
        case insurancePolicy = "insurance_policy"
        case familyMedicalUnit = "family_medical_unit"
        case nss
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "insurancePolicy", serializedName: "insurance_policy", requiresEncryption: false),
            .init(property: "familyMedicalUnit", serializedName: "family_medical_unit", requiresEncryption: false),
            .init(property: "nss", serializedName: "nss", requiresEncryption: false),
        ]
    }
}

struct UMFdata {
    let id: Int
    let data1: String
    let titleInt: String
    let data2: String
    let image: String
    let color: UIColor
}
