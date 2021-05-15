//
//  File.swift
//  
//
//  Created by Arthur Givigir on 3/21/21.
//

import Combine
import MyCoinsCore
import Foundation
import FirebaseFirestore

public class CoinFetcher {
    
    public typealias RETURNED_METHOD = (CoinModel?, Error?) -> Void
    public typealias RETURNED_ARRAY_METHOD = ([(String, Double)], Error?) -> Void
    private var cancellables = Set<AnyCancellable>()
    private let service: CoinInteractor
    private var firestore: Firestore
    
    public static let shared: CoinFetcher = CoinFetcher()
    private var defaultMessage: String = "Todo dia um 7 a 1 diferente..."
    
    private init() {
        self.service = CoinInteractor()
        self.firestore = Firestore.firestore()
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
                
            } receiveValue: { [weak self] coinModel in
                
                if var coin = coinModel {
                    coin.message = self?.defaultMessage
                    
                    self?.firestore
                        .collection(coin.rate.getTableName())
                        .getDocuments() { (querySnapshot, error) in
                            
                        self?.setCoinMessage(coin: &coin, documents: querySnapshot?.documents, error: error)
                        completion(coin, nil)
                    }
                    
                    return
                }
                
                completion(coinModel, nil)
            }
            .store(in: &cancellables)
    }
    
    public func getRangeFrom(coin: String, range: Int, completion: @escaping RETURNED_ARRAY_METHOD) {
        self.service
            .getValuesFrom(coin: coin, range: range)
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
                    if let hour1 = coin1?.timestamp, let hour2 = coin2?.timestamp {
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
