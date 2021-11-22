//
//  CoinResponse.swift
//  
//
//  Created by Arthur Givigir on 03/06/21.
//
import Foundation
import MyCoinsCore

internal struct CoinResponse: Codable {
    
    let metaData: MetaDataModel?
    let coinValues: [CoinModel]
}


internal struct MetaDataModel: Codable {
    
    public let information: String?
    public let fromSymbol: String?
    public let toSymbol: String?
    public let lastRefreshed: String?
    public let interval: String?
    public let ouputSize: String?
    public let timeZone: String?
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case fromSymbol = "2. From Symbol"
        case toSymbol = "3. To Symbol"
        case lastRefreshed = "4. Last Refreshed"
        case interval = "5. Interval"
        case ouputSize = "6. Output Size"
        case timeZone = "7. Time Zone"
    }
}
