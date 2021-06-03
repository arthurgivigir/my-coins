//
//  File.swift
//  
//
//  Created by Arthur Givigir on 3/21/21.
//

import Combine
import MyCoinsCore
import Foundation
import Firebase

public class CoinFetcher {
    
    public static let shared: CoinFetcher = CoinFetcher()
    
    public typealias RETURNED_STOCK_REALTIME = (CoinModel?, Error?) -> Void
    public typealias RETURNED_ARRAY_METHOD = (CoinModel?, [String]?, [Double]?, Error?) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    private let interactor: CoinInteractor
    private var firestore: Firestore
    private var defaultMessage: String = "Todo dia um 7 a 1 diferente..."
    
    private init() {
        self.interactor = CoinInteractor()
        
        self.firestore = Firestore.firestore()
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
                
                if var todayCoin = coinModel {
                    todayCoin.message = self.defaultMessage

                    self.firestore
                         .collection(todayCoin.rate.getTableName())
                         .getDocuments() { (querySnapshot, error) in

                            self.setCoinMessage(coin: &todayCoin, documents: querySnapshot?.documents, error: error)
                            completion(todayCoin, nil)
                    }
                    
                    
                }
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
                    completion(nil, nil, nil, error)
                case .finished:
                    print("😃Finished publisher from getValueFrom")
                }

            } receiveValue: { coinsModel in
                
                var categories: [String] = []
                var values: [Double] = []
                
                if let coinsModel = coinsModel {
                    _ = coinsModel.enumerated().map { offset, coinModel in
                        
                        if offset >= 25 {
                            return
                        }
                        
                        let coinValue = Double(coinModel.close)
                        values.append(coinValue ?? 0.0)
                        categories.append(coinModel.formattedUpdatedAt ?? "")
                    }
                    
                    if var todayCoin = coinsModel.first {
                        todayCoin.message = self.defaultMessage

                        self.firestore
                             .collection(todayCoin.rate.getTableName())
                             .getDocuments() { (querySnapshot, error) in

                                self.setCoinMessage(coin: &todayCoin, documents: querySnapshot?.documents, error: error)
                                completion(todayCoin, categories.reversed(), values.reversed(), nil)
                        }
                    }
                }
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


extension String {
    
    public func formattedDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let date = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = "dd MMMM HH:mm"
        dateFormatter.locale = Locale(identifier: "pt-BR")
        
        return dateFormatter.string(from: date)
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func yesterday() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
}
