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
    func getCoinValueFrom(from: String, to: String) -> AnyPublisher<CoinModel?, Error>
    func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error>
}

public struct CoinInteractor: CoinInteractorProtocol {
    
    private var coinService: CoinServiceProtocol
    
    public init() {
        self.coinService = CoinService()
    }
    
    public func getCoinValueFrom(from: String, to: String) -> AnyPublisher<CoinModel?, Error> {
        
        return self.coinService
            .getCoinValuesFrom(from: from, to: to)
            .map { coinModels -> CoinModel? in
                var todayCoin = coinModels?.first
                let yesterdayCoin = coinModels?.filter { todayCoin?.updatedAt?.yesterday() == $0.updatedAt }.first
                
                let todayValue = Double(todayCoin?.close ?? "0") ?? 0.0
                let yesterdayValue = Double(yesterdayCoin?.close ?? "0") ?? 0.0
                
                todayCoin?.pctChange = todayValue - yesterdayValue
                
                return todayCoin
            }
            .eraseToAnyPublisher()
    }
    
    public func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error> {
        return self.coinService.getCoinValuesFrom(from: from, to: to)
    }
    
    
}
