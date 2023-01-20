//
//  ServiceData.swift
//  
//
//  Created by Arthur Givigir on 19/01/23.
//

import Foundation
import CloudKit

public struct ServiceData: Hashable, Codable, Identifiable {
    public let id: String?
    public let jwtToken: String?
    
    public init(id: String?, jwtToken: String?) {
        self.id = id
        self.jwtToken = jwtToken
    }
    
    public enum ServiceDataKey: String {
        case id
        case jwtToken
    }
}

public extension CKRecord {
    subscript(key: ServiceData.ServiceDataKey) -> String? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
}
