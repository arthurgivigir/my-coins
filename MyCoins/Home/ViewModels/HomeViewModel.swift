//
//  HomeViewModel.swift
//  MyCoins
//
//  Created by Arthur Gradim Givigir on 18/04/21.
//

import Foundation
import Combine
import MyCoinsCore
import MyCoinsServices

final class HomeViewModel: ObservableObject {
    
    @Published private (set) var coinModel = CoinModel(date: Date())
    @Published var rangeValues = [(String, Double)]()
    @Published var chartValues = [(Double)]()
    
    private var cancellables: Set<AnyCancellable> = []
    
    public func fetch() {
        self.getValueFromCoin()
        self.getRangeFromCoin()
        
        Timer.publish(every: 60, on: .main, in: .default)
            .autoconnect()
            .sink { time in
                self.getValueFromCoin()
                print(time)
            }
            .store(in: &cancellables)
    }
    
    private func getValueFromCoin() {
        CoinFetcher
            .shared
            .getValueFrom(coin: "USD-BRL") { [weak self] coinModel, error in
                
                if let error = error {
                    print("😭 Ocorreu um erro: \(error.localizedDescription)")
                    return
                }
                
                if let coinModel = coinModel {
                    self?.coinModel = coinModel
                    return
                }
            }
    }
    
    private func getRangeFromCoin() {
        CoinFetcher.shared.getRangeFrom(coin: "USD-BRL") { [weak self] values, error in
            
            if let error = error {
                print("😭 Ocorreu um erro: \(error.localizedDescription)")
                return
            }
            
//            if let values = values {
            print(values)
            self?.rangeValues = values
            
            self?.chartValues = values.map { _, value in
                return value
            }
        
            return
//            }
        }
        
//        CoinFetcher.shared.getStockFrom(coin: "USD-BRL") { [weak self] values, error in
//            
//            if let error = error {
//                print("😭 Ocorreu um erro: \(error.localizedDescription)")
//                return
//            }
//            
////            if let values = values {
//            print(values)
//            self?.rangeValues = values
//            
//            self?.chartValues = values.map { _, value in
//                return value
//            }
//        
//            return
////            }
//        }
    }
    
}
