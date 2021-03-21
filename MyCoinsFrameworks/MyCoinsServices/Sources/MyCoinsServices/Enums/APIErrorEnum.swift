//
//  ApiErrorEnum.swift
//  MyCoinsCore
//
//  Created by Arthur Givigir on 3/3/21.
//

import Foundation
import Alamofire

public enum APIErrorEnum: Error {
    
    public init(error: AFError) {
        self = .network
    }
    
    case network
    case custom(Int, String, String)
    
    public var message: String {
        switch self {
        case .network:
            return "Network Error"
        case .custom(let code, let message, let status):
            return "Custom error info are: \(code) -- \(message) -- \(status)"
        }
    }
}
