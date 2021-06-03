//
//  CoinModel.swift
//  
//
//  Created by Arthur Givigir on 03/06/21.
//
import Foundation
import WidgetKit

public struct CoinModel: TimelineEntry, Codable {
    
    public var date: Date = Date()
    public let open: String
    public let high: String
    public let low: String
    public let close: String
    public var message: String?
    public var updatedAt: Date?
    public var pctChange: Double?
    public var formattedUpdatedAt: String?
    
    public var formattedBit: String {
        let defaultValue = "R$ 0,00"
        
        if let value = Double(self.close) {
            return formatter.string(from: NSNumber(value: value)) ?? defaultValue
        }
        
        return defaultValue
    }
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }
    
    public var rate: RateEnum {
        
        if let pctChange = self.pctChange {
            
            let pctChangeRounded = Double(round(100 * pctChange)/100)
            
            switch pctChangeRounded {
            case _ where pctChangeRounded < 0:
                return .down
            case _ where pctChangeRounded > 0:
                return .up
            default:
                return .stable
            }
        }
        
        return .stable
    }
    
    public init(
        date: Date,
        open: String = "",
        high: String = "",
        low: String = "",
        close: String = "",
        message: String? = nil,
        updatedAt: Date? = nil,
        pctChange: Double? = nil
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
