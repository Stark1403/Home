import Foundation
import UPAXNetworking

public struct ResponsePermissionsMenu: UNCodable {
    var menus: [CategoryMenuModel]
}

public struct CategoryMenuModel: UNCodable {
    var typeMenu: Int
    var label: String
    var list: [PermissionMenuModel]
    
    init(typeMenu: Int, label: String, list: [PermissionMenuModel]) {
        self.typeMenu = typeMenu
        self.label = label
        self.list = list
    }
    
    enum CodingKeys: String, CodingKey {
        case label
        case typeMenu = "type_menu"
        case list
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "typeMenu", serializedName: "type_menu")
        ]
    }
}

public class PermissionMenuModel: UNCodable {
    var idPermission: Int
    var name: String?
    var categoryColor: String?
    var order: Int
    var showChilds: Int
    var childs: [PermissionMenuModel]
    var moduleNewFeature: String?
    var badgePriority: Int = 0
    
    init(idPermission: Int, name: String?, categoryColor: String?, order: Int, showChilds:Int, childs: [PermissionMenuModel], badgePriority: Int) {
        self.idPermission = idPermission
        self.name = name
        self.categoryColor = categoryColor
        self.order = order
        self.showChilds = showChilds
        self.childs = childs
        self.badgePriority = badgePriority
    }
    
    enum CodingKeys: String, CodingKey {
        case idPermission = "permission_id"
        case name
        case categoryColor = "category_color"
        case order
        case showChilds = "show_childs"
        case childs
        case moduleNewFeature = "module_new_feature"
    }
    
    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "idPermission", serializedName: "permission_id"),
            .init(property: "categoryColor", serializedName: "category_color"),
            .init(property: "showChilds", serializedName: "show_childs"),
            .init(property: "moduleNewFeature", serializedName: "module_new_feature")
        ]
    }
    
    func extractVersionCreate() -> String? {
           guard let featureString = self.moduleNewFeature,
                 let data = featureString.data(using: .utf8) else {
               return nil
           }

           do {
               let feature = try JSONDecoder().decode(ModuleNewFeatureModel.self, from: data)
               return feature.versionCreate
           } catch {
               print("❌ Error parsing moduleNewFeature: \(error)")
               return nil
           }
       }
}


public class ModuleNewFeatureModel: UNCodable {
    var versionCreate: String?

    enum CodingKeys: String, CodingKey {
        case versionCreate = "version_create"
    }

    public func getUNCodingKeys() -> [UNCodingKey] {
        return [
            .init(property: "versionCreate", serializedName: "version_create")
        ]
    }
}

extension PermissionMenuModel {
    /**
     Busca en el arbol de menus el menu que se selecciono
     - Parameter id: Recibe el paramétro id del menú
     */
    func search(id: Int) -> PermissionMenuModel? {
        
        if id == self.idPermission {
            return self
        }
        
        for child in childs {
            if let found = child.search(id: id) {
                return found
            }
        }
        return nil
    }
    
    /**
    Determina si tiene algun padre el modulo seleccionado y devuelve el padre
    - Parameter id: Recibe el paramétro id del menú
    */
    func getParentId(id: Int) -> Int {
        
        if id == self.idPermission {
            return id
        }
        
        for child in childs {
            if child.search(id: id) != nil {
                return self.idPermission
            }
        }
        return -1
    }
    
    /**
    Determina si ha llegado al nivel más alto
    - Parameter id: Recibe el paramétro id del menú
    */
    func isParentInit(id: Int) -> Bool {
        
        if id == self.idPermission {
            return true
        }
        
        return false
    }
}
