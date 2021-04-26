//
//  CoinInteractor.swift
//  MyCoinsServices
//
//  Created by Arthur Givigir on 3/3/21.
//

import Foundation
import MyCoinsCore
import Combine

public protocol CoinInteractorProtocol {
    func getValueFrom(coin: String) -> AnyPublisher<CoinModel?, Error>
    func getValueFrom(coins: [String]) -> AnyPublisher<[CoinModel?]?, Error>
    func getValuesFrom(coin: String, range: Int) -> AnyPublisher<[CoinModel?]?, Error>
    func getStockPricesFrom(coin: String) -> AnyPublisher<[String: StockPriceMinutelyModel]?, Error>
}

public struct CoinInteractor: CoinInteractorProtocol {
    
    private var coinService: CoinServiceProtocol
    
    public init() {
        self.coinService = CoinService()
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
    
    public func getStockPricesFrom(coin: String) -> AnyPublisher<[String: StockPriceMinutelyModel]?, Error> {
        return coinService.getStockPricesFrom(coin: coin)
    }
}
