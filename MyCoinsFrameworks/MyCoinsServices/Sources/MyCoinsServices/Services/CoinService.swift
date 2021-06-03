//
//  CoinService.swift
//  MyCoinsServices
//
//  Created by Arthur Givigir on 3/3/21.
//

import Foundation
import MyCoinsCore
import Alamofire
import Combine

protocol CoinServiceProtocol {
    func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error>
}

struct CoinService: CoinServiceProtocol {

    private let apiKey = "4HI32LN6NHWCD8TH"
    private let alphavantageUrl = "https://www.alphavantage.co/"
    
    func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error> {
        if let url = URL(string: "\(alphavantageUrl)query?function=FX_INTRADAY&from_symbol=\(from)&to_symbol=\(to)&interval=\(TimeInterval.fifteen.rawValue)&outputsize=\(OutputSize.compact)&apikey=\(apiKey)") {
            return AF.request(url)
                .publishDecodable(type: CoinResponse.self, queue: .global(qos: .background))
                .value()
                .map { coinResponse in
                    return coinResponse.coinValues
                }
                .mapError { aferror in
                    APIErrorEnum(error: aferror)
                }
                .eraseToAnyPublisher()
        }
        
        return CurrentValueSubject(nil).eraseToAnyPublisher()
    }
    
    /// Enum of outputsize parameter from alphavantage
    internal enum OutputSize {
        case compact
        case full
    }
    
    /// Enum of outputsize parameter from alphavantage
    internal enum TimeInterval: String {
        case one = "1min"
        case five = "5min"
        case fifteen = "15min"
        case thirty = "30min"
        case sixty = "60min"
    }
}
