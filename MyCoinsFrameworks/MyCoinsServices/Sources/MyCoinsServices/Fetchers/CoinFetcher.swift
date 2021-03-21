//
//  File.swift
//  
//
//  Created by Arthur Givigir on 3/21/21.
//

import Combine
import MyCoinsCore

public class CoinFetcher {
    
    public typealias RETURNED_METHOD = (CoinModel?) -> Void
    private var cancellables = Set<AnyCancellable>()
    private let service: CoinService
    
    public static let shared: CoinFetcher = CoinFetcher()
    
    private init() {
        self.service = CoinService()
    }
    
    public func getValueFrom(coin: String, completion: @escaping RETURNED_METHOD) {
        self.service
            .getValueFrom(coin: coin)
            .sink { _ in
                print("returned")
            } receiveValue: { coinModel in
                print("\(coinModel?.varBid ?? "Empty")")
                completion(coinModel)
            }
            .store(in: &cancellables)
    }
    
}
