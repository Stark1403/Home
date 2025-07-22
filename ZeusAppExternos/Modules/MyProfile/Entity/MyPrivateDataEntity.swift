//
//  MyPrivateDataEntity.swift
//  ZeusAppExternos
//
//  Created by Satori Tech 209 on 11/7/24.
//

import Foundation
import ZeusServiceCoordinator
import UPAXNetworking

//MARK: DATOS PRIVADOS
struct PersonalDataResponse: Codable {
    let personalInformation: PersonalInformation?
}
struct PersonalInformation: Codable {
    let employment: EmploymentData?
//    let emergencyData: String?
    let privateDate: PrivateDate?
    var address: AddressData?
}

struct EmploymentData: Codable {
    let stateWork: GenericID?
    let office: GenericID?
    let area: String?
    let position: String?
    let cell_phone_number: String?
    let vacation_days: Int?
    let identifier: String?
    let email: String?
    let low: GenericID?
    let id_chief: String?
    let discharge_date: String?
    let sucursal: String?
    let name:String
    let maternal_surname:String?
    let paternal_surname:String
    let idApp:String?
    
    
}

struct PrivateDate: Codable {
    let gender: GenericID?
    let nss: String?
    let marital_status: GenericID?
    let curp: String?
    let place_birth: GenericID?
    let birthdate: String?
    let ine: String?
    let rfc: String?
}

struct AddressData: Codable {
    var id: Int?
    var street: String?
    var out_number: String?
    var interior_number: String?
    var colony: GenericID?
    var zip: String?
    var municipality: GenericID?
    var state: GenericID?
}

struct GenericID: Codable {
    var id: Int?
    var description: String?
}

//MARK: ACTUALIZAR DIRECCION
struct AddressRequest: UNCodable {
    let id_collaborator: String
    let street: String
    let out_number: String
    let interior_number: String?
    let colony: String
    let zip: String
    let municipality: String
    let name_state: String
    let alias: String
    let id_address: Int
    let id_state:Int
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "id_collaborator", requiresEncryption: true),
            .init(property: "street", requiresEncryption: false),
            .init(property: "out_number", requiresEncryption: false),
            .init(property: "interior_number", requiresEncryption: false),
            .init(property: "colony", requiresEncryption: false),
            .init(property: "zip", requiresEncryption: false),
            .init(property: "municipality", requiresEncryption: false),
            .init(property: "name_state", requiresEncryption: false),
            .init(property: "id_address", requiresEncryption: false),
            .init(property: "id_state", requiresEncryption: false),
        ]
    }
}

struct AddressResponse: UNCodable {
    let address: AddressInformationResponse?
}

struct AddressInformationResponse: Codable {
    let street: String?
    let colony: GenericID?
    let municipality: GenericID?
    let out_number: String?
    let zip: String?
    let interior_number: String?
    let state: GenericID?
}

//MARK: OBTENER CP

struct CPResponse: UNCodable {
    let mensaje: String?
    
    let postalcode: CPInformation?
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "mensaje", requiresEncryption: false),
            .init(property: "postalcode", requiresEncryption: false),
        ]
    }
}

struct StateDataResponse: UNCodable {
    let stateDataResponse: [StateData]?
    
    private enum CodingKeys: String, CodingKey {
        case stateDataResponse = "state"
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "stateDataResponse", serializedName: "state",requiresEncryption: false),
        ]
    }
    
}

struct StateData: UNCodable {
    let id: Int?
    let name: String?
    let description: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "id", serializedName: "id",requiresEncryption: false),
            .init(property: "name", serializedName: "name",requiresEncryption: false),
            .init(property: "description", serializedName: "description",requiresEncryption: false),
        ]
    }
    
}
    
struct CPInformation: UNCodable {
    let postalCode: String?
    let countryCode: String?
    let countryName: String?
    var stateId: Int?
    let cityId : Int?
    let cityName: String?
    var stateName: String?
    var colonies : [GenericIDCP]
    
    private enum CodingKeys: String, CodingKey {
        case postalCode = "postal_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case stateName = "state_name"
        case stateId = "state_id"
        case cityId = "city_id"
        case cityName = "city_name"
        case colonies = "colonies"
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "postalCode", serializedName: "postal_code",requiresEncryption: false),
            .init(property: "countryCode", serializedName: "country_code",requiresEncryption: false),
            .init(property: "countryName", serializedName: "country_name",requiresEncryption: false),
            .init(property: "stateName", serializedName: "state_name",requiresEncryption: false),
            .init(property: "stateId", serializedName: "state_id",requiresEncryption: false),
            .init(property: "cityId", serializedName: "city_id",requiresEncryption: false),
            .init(property: "cityName", serializedName: "city_name",requiresEncryption: false),
            .init(property: "colonies", serializedName: "colonies",requiresEncryption: false),
        ]
    }
    
}

struct GenericIDCP: UNCodable {
    let id: Int?
    let name: String?
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "id", requiresEncryption: false),
            .init(property: "name", requiresEncryption: false),
        ]
    }
}
