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
                return coinModels?.first(where: { coinModel in
                    if let _ = coinModel.message {
                        return true
                    }
                    
                    return false
                })
            }
            .eraseToAnyPublisher()
    }
    
    public func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error> {
        
        return self.coinService
            .getCoinValuesFrom(from: from, to: to)
            .map { coinsModel -> [CoinModel]? in
                return coinsModel
            }
            .eraseToAnyPublisher()
    }
}
