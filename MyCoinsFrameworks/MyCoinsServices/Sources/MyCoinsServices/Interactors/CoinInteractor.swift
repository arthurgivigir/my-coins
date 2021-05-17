//
//  CoinInteractor.swift
//  MyCoinsServices
//
//  Created by Arthur Givigir on 3/3/21.
//

import Foundation
import MyCoinsCore
import Combine
import Firebase

public protocol CoinInteractorProtocol {
    func getValueFrom(coin: String) -> AnyPublisher<CoinModel?, Error>
    func getValueFrom(coins: [String]) -> AnyPublisher<[CoinModel?]?, Error>
    func getValuesFrom(coin: String, range: Int) -> AnyPublisher<[CoinModel?]?, Error>
    
    func getStockPriceFrom(from: String, to: String) -> AnyPublisher<RealtimeCurrencyExchangeRate?, Error>
    func getStockPricesFrom(from: String, to: String) -> AnyPublisher<[String: StockPriceMinutelyModel]?, Error>
}

public struct CoinInteractor: CoinInteractorProtocol {
    
    private var coinService: CoinServiceProtocol
    
    public init() {
        self.coinService = CoinService()
    }
    
    public func getStockPriceFrom(from: String, to: String) -> AnyPublisher<RealtimeCurrencyExchangeRate?, Error> {
        return coinService.getStockPriceFrom(from: from, to: to).eraseToAnyPublisher()
    }
    
    public func getValueFrom(coin: String) -> AnyPublisher<CoinModel?, Error> {
        return coinService.getValueFrom(coin: coin).eraseToAnyPublisher()
    }
    
    public func getValueFrom(coins: [String]) -> AnyPublisher<[CoinModel?]?, Error> {
        return coinService.getValueFrom(coins: coins).eraseToAnyPublisher()
    }
    
    public func getValuesFrom(coin: String, range: Int) -> AnyPublisher<[CoinModel?]?, Error> {
        return coinService.getValuesFrom(coin: coin, range: range).eraseToAnyPublisher()
    }
    
    public func getStockPricesFrom(from: String, to: String) -> AnyPublisher<[String : StockPriceMinutelyModel]?, Error> {
        return coinService.getStockPricesFrom(from: from, to: to).eraseToAnyPublisher()
    }
    
}
