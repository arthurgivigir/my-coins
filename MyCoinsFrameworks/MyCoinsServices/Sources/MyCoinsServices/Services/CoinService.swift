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
    func getValueFrom(coin: String) -> AnyPublisher<CoinModel?, Error>
    func getValueFrom(coins: [String]) -> AnyPublisher<[CoinModel?]?, Error>
    func getValuesFrom(coin: String, range: Int) -> AnyPublisher<[CoinModel?]?, Error>
    
    func getStockPriceFrom(from: String, to: String) -> AnyPublisher<RealtimeCurrencyExchangeRate?, Error>
    func getStockPricesFrom(from: String, to: String) -> AnyPublisher<[String: StockPriceMinutelyModel]?, Error>
}

struct CoinService: CoinServiceProtocol {
    
    private let apiKey = "4HI32LN6NHWCD8TH"
    private let alphavantageUrl = "https://www.alphavantage.co/"
    
    func getStockPriceFrom(from: String, to: String) -> AnyPublisher<RealtimeCurrencyExchangeRate?, Error> {
        if let url = URL(string: "\(alphavantageUrl)query?function=CURRENCY_EXCHANGE_RATE&from_currency=\(from)&to_currency=\(to)&apikey=\(apiKey)") {
            return AF.request(url)
                .publishDecodable(type: StockPriceRealtimeModel.self, queue: .global(qos: .background))
                .value()
                .map { coins in return coins.realtimeCurrencyExchangeRate }
                .mapError { aferror in APIErrorEnum(error: aferror) }
                .eraseToAnyPublisher()
        }
        
        return CurrentValueSubject(nil).eraseToAnyPublisher()
    }
    
    
    func getValueFrom(coin: String) -> AnyPublisher<CoinModel?, Error> {
        
        if let url = URL(string: "https://economia.awesomeapi.com.br/json/\(coin)") {
            return AF.request(url)
                .publishDecodable(type: [CoinModel].self, queue: .global(qos: .background))
                .value()
                .map { coins in return coins.first }
                .mapError { aferror in APIErrorEnum(error: aferror) }
                .eraseToAnyPublisher()
        }
        
        return CurrentValueSubject(nil).eraseToAnyPublisher()
    }
    
    func getValueFrom(coins: [String]) -> AnyPublisher<[CoinModel?]?, Error> {
        
        if let url = URL(string: "https://economia.awesomeapi.com.br/all/\(coins.joined(separator: ","))") {
            return AF.request(url)
                .publishDecodable(type: [String: CoinModel].self, queue: .global(qos: .background))
                .value()
                .map { coins in return Array(coins.values) }
                .mapError { aferror in APIErrorEnum(error: aferror) }
                .eraseToAnyPublisher()
        }
        
        return CurrentValueSubject(nil).eraseToAnyPublisher()
    }
    
    func getValuesFrom(coin: String, range: Int) -> AnyPublisher<[CoinModel?]?, Error> {
        if let url = URL(string: "https://economia.awesomeapi.com.br/\(coin)/\(range)") {
            return AF.request(url)
                .publishDecodable(type: [CoinModel].self, queue: .global(qos: .background))
                .value()
                .map { coins in return Array(coins) }
                .mapError { aferror in APIErrorEnum(error: aferror) }
                .eraseToAnyPublisher()
        }
        
        return CurrentValueSubject(nil).eraseToAnyPublisher()
    }
    
    func getStockPricesFrom(from: String, to: String) -> AnyPublisher<[String: StockPriceMinutelyModel]?, Error> {
        if let url = URL(string: "\(alphavantageUrl)query?function=FX_INTRADAY&from_symbol=\(from)&to_symbol=\(to)&interval=\(TimeInterval.fifteen.rawValue)&outputsize=\(OutputSize.compact)&apikey=\(apiKey)") {
            return AF.request(url)
                .publishDecodable(type: StockPriceMinutelyDailyModel.self, queue: .global(qos: .background))
                .value()
                .map { coins in
                    return coins.stockPriceMinutelyModel
                    
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
