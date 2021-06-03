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
    public typealias RETURNED_ARRAY_METHOD = (CoinModel?, [String]?, [Double]?, Error?) -> Void
    
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
                    
                    completion(coinsModel.first, categories.reversed(), values.reversed(), nil)
                }
            }
            .store(in: &cancellables)
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
