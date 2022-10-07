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
    public var updatedAt: String?
    public var pctChange: Double?
    public var formattedUpdatedAt: String? {
        self.updatedAt?.formattedDate()
    }
    internal var rate: String?
    
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
    
    public var rateEnum: Rate {
        if let rate = rate {
            return Rate(rate) ?? .stable
        }
        
        return .stable
    }
    
    public init(
        date: Date,
        open: String = "",
        high: String = "",
        low: String = "",
        rate: String = "",
        close: String = "",
        message: String? = nil,
        updatedAt: String? = nil,
        pctChange: Double? = nil
    ) {
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.rate = rate
        self.message = message
        self.updatedAt = updatedAt
        self.pctChange = pctChange
    }
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case updatedAt = "updatedAt"
        case message = "message"
        case pctChange = "pctChange"
        case rate = "rate"
    }

}
