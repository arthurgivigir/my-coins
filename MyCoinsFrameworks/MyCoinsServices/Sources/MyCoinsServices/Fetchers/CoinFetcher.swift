//
//  File.swift
//  
//
//  Created by Arthur Givigir on 3/21/21.
//

import Combine
import MyCoinsCore
import Foundation
import CloudKit

public class CoinFetcher {
    
    public static let shared: CoinFetcher = CoinFetcher()
    
    public typealias RETURNED_STOCK_REALTIME = (CoinModel?, Error?) -> Void
    public typealias RETURNED_ARRAY_METHOD = (CoinModel?, [CoinModel]?, Error?) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    private let interactor: CoinInteractor
    
    private init() {
        self.interactor = CoinInteractor()     
    }
    
    public func getCoinValue(from: Coins, to: Coins, completion: @escaping RETURNED_STOCK_REALTIME) {
        subscribeToCloud { [weak self] result in
            switch result {
            case .success(_):
                self?.getEarlierCoinValue(from: from, to: to, completion: completion)
                
            case .failure(let failure):
                print("😃Finished publisher from getValueFrom getCoinValue \(failure)")
            }
        }
    }
    
    private func getEarlierCoinValue(from: Coins, to: Coins, completion: @escaping RETURNED_STOCK_REALTIME) {
        interactor
            .getCoinValueFrom(from: from.rawValue, to: to.rawValue)
            .receive(on: RunLoop.main)
            .sink { receivedCompletition in

                switch receivedCompletition {
                case .failure(let error):
                    completion(nil, error)
                case .finished:
                    print("😃Finished publisher from getValueFrom getEarlierCoinValue")
                }

            } receiveValue: { coinModel in
                completion(coinModel, nil)
            }
            .store(in: &cancellables)
    }
    
    public func getCoinValues(from: Coins, to: Coins, completion: @escaping RETURNED_ARRAY_METHOD) {
        
        self.interactor
            .getCoinValuesFrom(from: from.rawValue, to: to.rawValue)
            .receive(on: RunLoop.main)
            .sink { receivedCompletition in

                switch receivedCompletition {
                case .failure(let error):
                    completion(nil, nil, error)
                case .finished:
                    print("😃Finished publisher from getValueFrom getCoinValues")
                }

            } receiveValue: { coinsModel in
                
                let newCoinsModel = coinsModel?.prefix(25)
                let todayCoin = newCoinsModel?.first(where: { $0.message != nil })
                
                completion(todayCoin, newCoinsModel?.reversed(), nil)
                
            }
            .store(in: &cancellables)
    }
    
    public func subscribeToCloud(_ onFinish: @escaping (Result<Void, Error>) -> Void) {
        self.interactor.subscribeToCloud(onFinish)
    }
    
    public func getServicesInformation(with id: CKRecord.ID?) {
        self.interactor.getServicesInformation(with: id) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print("🚧 Failure: \(failure)")
            }
        }
    }
}
