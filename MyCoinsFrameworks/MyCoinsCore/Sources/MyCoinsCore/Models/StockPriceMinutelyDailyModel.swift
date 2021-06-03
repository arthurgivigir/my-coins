//
//  StockPriceModel.swift
//
//
//  Created by Arthur Gradim Givigir on 26/04/21.
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






















// MARK: - StockPriceModel
public struct StockPriceMinutelyDailyModel: Codable {
    public let stockPriceDailyModel: StockPriceDailyModel
    public let stockPriceMinutelyModel: [String: StockPriceMinutelyModel]

    enum CodingKeys: String, CodingKey {
        case stockPriceDailyModel = "Meta Data"
        case stockPriceMinutelyModel = "Time Series FX (15min)"
    }
}

// MARK: - MetaData
public struct StockPriceDailyModel: Codable {
    
    public let information: String
    public let fromSymbol: String
    public let toSymbol: String
    public let lastRefreshed: String
    public let interval: String
    public let outputSize: String
    public let timeZone: String
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case fromSymbol = "2. From Symbol"
        case toSymbol = "3. To Symbol"
        case lastRefreshed = "4. Last Refreshed"
        case interval = "5. Interval"
        case outputSize = "6. Output Size"
        case timeZone = "7. Time Zone"
    }
}

// MARK: - TimeSeriesFX5Min
public struct StockPriceMinutelyModel: TimelineEntry, Codable {
    public var date: Date = Date()
    public let open: String
    public let high: String
    public let low: String
    public let close: String
    public var message: String?
    public var updatedAt: Date?
    public var pctChange: Double?
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }
    
    public var formattedBit: String {
        let defaultValue = "R$ 0,00"
        
        if let value = Double(self.close) {
            return formatter.string(from: NSNumber(value: value)) ?? defaultValue
        }
        
        return defaultValue
    }
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
    }
}
