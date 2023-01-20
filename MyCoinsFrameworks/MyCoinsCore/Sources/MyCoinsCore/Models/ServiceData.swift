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
    public let host: String?
    public let apiGetCoins: String?
    public var url: URL? {
        guard let host = host,
              let apiGetCoins = apiGetCoins else { return nil }
        
        return URL(string: "\(host)/\(apiGetCoins)")
    }
    
    public init(id: String?, jwtToken: String?, host: String?, apiGetCoins: String?) {
        self.id = id
        self.jwtToken = jwtToken
        self.host = host
        self.apiGetCoins = apiGetCoins
    }
    
    public enum ServiceDataKey: String {
        case id
        case jwtToken
        case host
        case apiGetCoins
    }
    
    public func toJson() -> String? {
        guard let encodedData = try? JSONEncoder().encode(self) else { return nil }
        let jsonString = String(data: encodedData,
                                encoding: .utf8)
        
        return jsonString
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
