//
//  File.swift
//  
//
//  Created by Arthur Gradim Givigir on 05/04/21.
//

import Foundation

public enum RateEnum {
    case up
    case down
    case stable
    
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
