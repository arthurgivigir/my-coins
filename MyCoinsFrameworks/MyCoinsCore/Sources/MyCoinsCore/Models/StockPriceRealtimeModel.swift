//
//  StockPriceRealtimeModel.swift
//  
//
//  Created by Arthur Givigir on 15/05/21.
//

import Foundation

// MARK: - StockPriceRealtimeModel
public struct StockPriceRealtimeModel: Codable {
    public let realtimeCurrencyExchangeRate: RealtimeCurrencyExchangeRate

    enum CodingKeys: String, CodingKey {
        case realtimeCurrencyExchangeRate = "Realtime Currency Exchange Rate"
    }
}

// MARK: - RealtimeCurrencyExchangeRate
public struct RealtimeCurrencyExchangeRate: Codable {
    public let fromCurrencyCode, fromCurrencyName, currencyCode, toCurrencyName: String
    public let exchangeRate, lastRefreshed, timeZone, bidPrice: String
    public let askPrice: String

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
