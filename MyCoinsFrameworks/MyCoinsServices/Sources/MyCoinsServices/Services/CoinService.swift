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
    func getStockPricesFrom(coin: String) -> AnyPublisher<[String: StockPriceMinutelyModel]?, Error>
}

struct CoinService: CoinServiceProtocol {
    
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
        if let url = URL(string: "https://economia.awesomeapi.com.br/USD/100") {
            return AF.request(url)
                .publishDecodable(type: [CoinModel].self, queue: .global(qos: .background))
                .value()
                .map { coins in return Array(coins) }
                .mapError { aferror in APIErrorEnum(error: aferror) }
                .eraseToAnyPublisher()
        }
        
        return CurrentValueSubject(nil).eraseToAnyPublisher()
    }
    
    func getStockPricesFrom(coin: String) -> AnyPublisher<[String: StockPriceMinutelyModel]?, Error> {
        if let url = URL(string: "https://www.alphavantage.co/query?function=FX_INTRADAY&from_symbol=EUR&to_symbol=USD&interval=5min&outputsize=full&apikey=demo") {
            return AF.request(url)
                .publishDecodable(type: StockPriceModel.self, queue: .global(qos: .background))
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
    
}
