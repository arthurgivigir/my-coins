//
//  CoinResponse.swift
//  
//
//  Created by Arthur Givigir on 03/06/21.
//
import Foundation
import MyCoinsCore

internal struct CoinResponse: Codable {
    
    let coinValues: [CoinModel]
    
    enum StockPriceMinutelyDailyKeys: String, CodingKey {
        case stockPriceDailyModel = "Meta Data"
        case stockPriceMinutelyModel = "Time Series FX (15min)"
    }
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: StockPriceMinutelyDailyKeys.self)
        let stockPriceMinutely = try values.decode([String: CoinModel].self, forKey: .stockPriceMinutelyModel)
        
        let stockPriceMinutelyArray = Array(stockPriceMinutely)
            .sorted { $0.key > $1.key }
            .map { stock -> CoinModel in
            
                var stockOrganized = stock.value
                stockOrganized.updatedAt = stock.key.toDate()
                stockOrganized.formattedUpdatedAt = stock.key.formattedDate()
                
                return stockOrganized
            }
        
        self.coinValues = stockPriceMinutelyArray
    }
}
