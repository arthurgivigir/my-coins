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
    
    public typealias RETURNED_METHOD = (CoinModel?, Error?) -> Void
    private var cancellables = Set<AnyCancellable>()
    private let service: CoinService
    
    public static let shared: CoinFetcher = CoinFetcher()
    
    private init() {
        self.service = CoinService()
    }
    
    public func getValueFrom(coin: String, completion: @escaping RETURNED_METHOD) {
        self.service
            .getValueFrom(coin: coin)
            .receive(on: RunLoop.main)
            .sink { receivedCompletition in
                
                switch receivedCompletition {
                case .failure(let error):
                    completion(nil, error)
                case .finished:
                    print("😃Finished publisher from getValueFrom")
                }
                
            } receiveValue: { coinModel in
                print("\(coinModel?.varBid ?? "Empty")")
                completion(coinModel, nil)
            }
            .store(in: &cancellables)
    }
    
}
