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
    
    public typealias RETURNED_STOCK_REALTIME = (RealtimeCurrencyExchangeRate?, Error?) -> Void
    public typealias RETURNED_ARRAY_METHOD = ([String : StockPriceMinutelyModel], Error?) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    private let service: CoinInteractor
    private var firestore: Firestore
    
    public static let shared: CoinFetcher = CoinFetcher()
    private var defaultMessage: String = "Todo dia um 7 a 1 diferente..."
    
    private init() {
        self.service = CoinInteractor()
        self.firestore = Firestore.firestore()
    }
    
    public func getStockValue(from: String, to: String, completion: @escaping RETURNED_STOCK_REALTIME) {
        self.service
            .getStockPriceFrom(from: from, to: to)
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
    
    public func getStockValues(from coin: String, to: String, completion: @escaping RETURNED_ARRAY_METHOD) {
        self.service
            .getStockPricesFrom(from: coin, to: to)
            .receive(on: RunLoop.main)
            .sink { receivedCompletition in
                
                switch receivedCompletition {
                case .failure(let error):
                    completion([:], error)
                case .finished:
                    print("😃Finished publisher from getValueFrom")
                }
                
            } receiveValue: { coins in
                
                print("\(String(describing: coins))")
                
                if let coins = coins {
                    
                    var sortedCoins = coins
                        .sorted { $0.key > $1.key }
                        .map { stocks in
                        return (stocks.key.formattedDate(), stocks.value)
                    }
                    
                    print("🚧 \(sortedCoins)")
                    
                    completion(coins, nil)
                    return
                }
                
                completion([:], nil)
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
    
    
    private func setCoinMessage(coin: inout RealtimeCurrencyExchangeRate, documents: [QueryDocumentSnapshot]?, error: Error?) {
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
    
//
//    public var rate: RateEnum {
//        if let exchangeRate = self.exchangeRate, let value = Double(exchangeRate) {
//            switch value {
//            case _ where value < 0:
//                return .down
//            case _ where value > 0:
//                return .up
//            default:
//                return .stable
//            }
//        }
//
//        return .stable
//    }
//
//
//    public var formattedHour: String {
//        let date = Date(timeIntervalSince1970: Double(self.lastRefreshed ?? "") ?? 0.0)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.locale = .current
//
//        return dateFormatter.string(from: date)
//    }
//
//    public var formattedDate: String {
//        let dateFormatter = DateFormatter()
//
//        if let lastRefreshed = self.lastRefreshed {
//            let date = dateFormatter.date(from: lastRefreshed) ?? Date()
//
//            dateFormatter.dateFormat = "dd MMMM HH:mm"
//            dateFormatter.locale = Locale(identifier: "pt-BR")
//
//            return dateFormatter.string(from: date)
//        }
//
//        return ""
//    }

}


extension String {
    
    public func formattedDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let date = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = "dd MMMM HH:mm"
        dateFormatter.locale = Locale(identifier: "pt-BR")
        
        dateFormatter.string(from: date)
    
    }
    
}
