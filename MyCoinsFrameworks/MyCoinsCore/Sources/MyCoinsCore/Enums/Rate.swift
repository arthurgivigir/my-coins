//
//  File.swift
//  
//
//  Created by Arthur Gradim Givigir on 05/04/21.
//

import Foundation

public enum Rate: String {
    case up
    case down
    case stable
    
    public init?(_ stringValue: String) {
        switch stringValue {
        case "upMessage":
            self = .up
        case "downMessage":
            self = .down
        default:
            self = .stable
        }
    }
    
    public func getTableName() -> String {
        switch self {
        case .up:
            return "upMessage"
        case .down:
            return "downMessage"
        default:
            return "stableMessage"
        }
    }
}
