//
//  CoinModel.swift
//  
//
//  Created by Arthur Givigir on 03/06/21.
//
import Foundation
import WidgetKit

public struct CoinModel: Codable {
    
    public var date: Date = Date()
    public let open: String
    public let high: String
    public let low: String
    public let close: String
    public var message: String?
    public var updatedAt: Date?
    public var pctChange: Double?
    public var formattedUpdatedAt: String?
    
    public var rate: RateEnum {
        if let pctChange = self.pctChange {
            switch pctChange {
            case _ where pctChange < 0:
                return .down
            case _ where pctChange > 0:
                return .up
            default:
                return .stable
            }
        }
        
        return .stable
    }
    
    public init(
        open: String = "",
        high: String = "",
        low: String = "",
        close: String = "",
        message: String?,
        updatedAt: Date?,
        pctChange: Double?
    ) {
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.message = message
        self.updatedAt = updatedAt
        self.pctChange = pctChange
    }
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
    }

}
