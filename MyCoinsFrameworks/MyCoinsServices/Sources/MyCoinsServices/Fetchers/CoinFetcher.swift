//
//  File.swift
//  
//
//  Created by Arthur Givigir on 3/21/21.
//

import Combine
import MyCoinsCore
import Foundation

public class CoinFetcher {
    
    public static let shared: CoinFetcher = CoinFetcher()
    
    public typealias RETURNED_STOCK_REALTIME = (CoinModel?, Error?) -> Void
    public typealias RETURNED_ARRAY_METHOD = (CoinModel?, [CoinModel]?, Error?) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    private let interactor: CoinInteractor
    
    private init() {
        self.interactor = CoinInteractor()
        
    }
    
    public func getCoinValue(from: String, to: String, completion: @escaping RETURNED_STOCK_REALTIME) {
        
        self.interactor
            .getCoinValueFrom(from: from, to: to)
            .receive(on: RunLoop.main)
            .sink { receivedCompletition in

                switch receivedCompletition {
                case .failure(let error):
                    completion(nil, error)
                case .finished:
                    print("😃Finished publisher from getValueFrom")
                }

            } receiveValue: { coinModel in
                completion(coinModel, nil)
            }
            .store(in: &cancellables)
        
    }
    
    public func getCoinValues(from: String, to: String, completion: @escaping RETURNED_ARRAY_METHOD) {
        
        self.interactor
            .getCoinValuesFrom(from: from, to: to)
            .receive(on: RunLoop.main)
            .sink { receivedCompletition in

                switch receivedCompletition {
                case .failure(let error):
                    completion(nil, nil, error)
                case .finished:
                    print("😃Finished publisher from getValueFrom")
                }

            } receiveValue: { coinsModel in
                
                let newCoinsModel = coinsModel?.prefix(25)
                let todayCoin = newCoinsModel?.first(where: { $0.message != nil })
                
                completion(todayCoin, newCoinsModel?.reversed(), nil)
                
            }
            .store(in: &cancellables)
    }

}
