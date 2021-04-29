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
    public typealias RETURNED_ARRAY_METHOD = ([(String, Double)], Error?) -> Void
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
    
    public func getRangeFrom(coin: String, completion: @escaping RETURNED_ARRAY_METHOD) {
        self.service
            .getValuesFrom(coin: coin, range: 15)
            .receive(on: RunLoop.main)
            .sink { receivedCompletition in
                
                switch receivedCompletition {
                case .failure(let error):
                    completion([], error)
                case .finished:
                    print("😃Finished publisher from getValueFrom")
                }
                
            } receiveValue: { coinModel in
                print("\(String(describing: coinModel))")
                
                let coins = coinModel?.sorted(by: { coin1, coin2 in
                    if let hour1 = coin1?.formattedHour, let hour2 = coin2?.formattedHour {
                        return hour1 < hour2
                    }
                    
                    return false
                })
                
                if let coins = coins {
                    let valuesRange: [(String, Double)] = coins.map { coin in
                        return (coin!.formattedHour, Double(coin!.bid!)!)
                    }
                    
                    completion(valuesRange, nil)
                    return
                }
                
                completion([], nil)
            }
            .store(in: &cancellables)
    }
    
    public func getStockFrom(coin: String, completion: @escaping RETURNED_ARRAY_METHOD) {
        self.service
            .getStockPricesFrom(coin: coin)
            .receive(on: RunLoop.main)
            .sink {  receivedCompletition in
                
                switch receivedCompletition {
                case .failure(let error):
                    completion([], error)
                case .finished:
                    print("😃Finished publisher from getStockFrom")
                }
            
            } receiveValue: { stockValues in
                let valuesRange: [(String, Double)] = stockValues!.map { stock in
                    return (stock.key, Double(stock.value.close)!)
                }
                
                completion(valuesRange, nil)
            }
            .store(in: &cancellables)

    }
    
}
