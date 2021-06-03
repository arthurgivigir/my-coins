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
    private var firestore: Firestore
    private var defaultMessage: String = "Todo dia um 7 a 1 diferente..."
    
    public init() {
        self.coinService = CoinService()
        self.firestore = Firestore.firestore()
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
        
        return self.coinService
            .getCoinValuesFrom(from: from, to: to)
            .map { coinsModel -> [CoinModel]? in
                
                if var coins = coinsModel,
                    var todayCoin = coins.first {
                    
                    let yesterdayCoin = coinsModel?.filter { todayCoin.updatedAt?.yesterday() == $0.updatedAt }.first
                    
                    let todayValue = Double(todayCoin.close ) ?? 0.0
                    let yesterdayValue = Double(yesterdayCoin?.close ?? "0") ?? 0.0
                    
                    todayCoin.pctChange = todayValue - yesterdayValue
                    todayCoin.message = self.defaultMessage

                    self.firestore
                         .collection(todayCoin.rate.getTableName())
                         .getDocuments() { (querySnapshot, error) in

                            self.setCoinMessage(coin: &todayCoin, documents: querySnapshot?.documents, error: error)
                    }
                    
                    coins[0] = todayCoin
                    
                    return coins
                }
 
                return coinsModel
            }
            .eraseToAnyPublisher()
    }
    
    
    private func setCoinMessage(coin: inout CoinModel, documents: [QueryDocumentSnapshot]?, error: Error?) {
        coin.message = self.defaultMessage
        
        guard let documents = documents else {
            print("Error getting documents: \(String(describing: error))")
            return
        }
        
        let maxCount = documents.count > 0 ? documents.count - 1 : 0
        let randomRange: Int = Int.random(in: 0...maxCount)
        
        if let message = documents[randomRange].data()["message"] as? String {
            coin.message = message
        }
        
    }
}
