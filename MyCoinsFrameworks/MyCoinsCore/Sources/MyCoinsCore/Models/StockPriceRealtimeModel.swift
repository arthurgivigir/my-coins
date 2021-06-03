//
//  StockPriceRealtimeModel.swift
//  
//
//  Created by Arthur Givigir on 15/05/21.
//

import Foundation
import WidgetKit

// MARK: - StockPriceRealtimeModel
public struct StockPriceRealtimeModel: Codable {
    public let realtimeCurrencyExchangeRate: RealtimeCurrencyExchangeRate

    enum CodingKeys: String, CodingKey {
        case realtimeCurrencyExchangeRate = "Realtime Currency Exchange Rate"
    }
}

// MARK: - RealtimeCurrencyExchangeRate
public struct RealtimeCurrencyExchangeRate: TimelineEntry, Codable {
    public var date: Date = Date()
    public var fromCurrencyCode, fromCurrencyName, currencyCode, toCurrencyName: String?
    public var exchangeRate, lastRefreshed, timeZone, bidPrice: String?
    public var askPrice: String?
    public var message: String?
    
    public init(date: Date) {
        self.date = date
    }
    
    public var rate: RateEnum {
        if let exchangeRate = self.exchangeRate, let value = Double(exchangeRate) {
            switch value {
            case _ where value < 0:
                return .down
            case _ where value > 0:
                return .up
            default:
                return .stable
            }
        }
        
        return .stable
    }
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }
    
    public var formattedBit: String {
        let defaultValue = "R$ 0,00"
        
        if let bid = self.bidPrice, let value = Double(bid) {
            return formatter.string(from: NSNumber(value: value)) ?? defaultValue
        }
        
        return defaultValue
    }
    
    public var formattedHour: String {
        let date = Date(timeIntervalSince1970: Double(self.lastRefreshed ?? "") ?? 0.0)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = .current
        
        return dateFormatter.string(from: date)
    }
    
    public var formattedDate: String {
        let dateFormatter = DateFormatter()
        
        if let lastRefreshed = self.lastRefreshed {
            let date = dateFormatter.date(from: lastRefreshed) ?? Date()
            
            dateFormatter.dateFormat = "dd MMMM HH:mm"
            dateFormatter.locale = Locale(identifier: "pt-BR")
            
            return dateFormatter.string(from: date)
        }
        
        return ""
    }

    enum CodingKeys: String, CodingKey {
        case fromCurrencyCode = "1. From_Currency Code"
        case fromCurrencyName = "2. From_Currency Name"
        case currencyCode = "3. To_Currency Code"
        case toCurrencyName = "4. To_Currency Name"
        case exchangeRate = "5. Exchange Rate"
        case lastRefreshed = "6. Last Refreshed"
        case timeZone = "7. Time Zone"
        case bidPrice = "8. Bid Price"
        case askPrice = "9. Ask Price"
    }
}
