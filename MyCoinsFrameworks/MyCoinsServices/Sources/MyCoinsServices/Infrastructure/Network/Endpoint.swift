//
//  Endpoint.swift
//  
//
//  Created by Arthur Givigir on 10/01/23.
//

import Foundation

let bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHAiOiJjb20uZ2l2aWdpci5NeUNvaW5zIiwiYXBwbmFtZSI6Inpvb2luIiwiYXBwaWQiOiJIN0VEVjU1MjRLIiwicGFzc3dvcmQiOiJiZk1LQkRCbm1OdlRxTWF3NFFrM2d0XzkyOSJ9.5nB7kg_8aRMh-XE56N1F0L8R50PIbDaat56STpjuZus"

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum Endpoint: Equatable {
    case zooin
    
    var url: String { scheme + "://" + host + "/" + path }
    var scheme: String { API.scheme }
    var host: String { API.URL }
    
    var path: String {
        switch self {
        case .zooin:
            return "getCoinValues"
        }
    }
    
    var header:  [String: String]  {
        switch self {
        case .zooin:
            return ["application/json": "Content-Type",
                    "Authorization":        "Bearer \(bearerToken)"]
        }
    }
    
    var method: String {
        switch self {
        case .zooin:
            return HTTPMethodType.get.rawValue
        }
    }
}

struct API {
    static var schemeURL: String { scheme + "://" + URL}
    static var scheme: String { "https" }
    static var URL: String {
        "zooin.herokuapp.com"
    }
}

