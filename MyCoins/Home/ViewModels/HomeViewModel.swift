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
    @Published var chartCategories = [(String)]()
    @Published var showToast: Bool = false
    @Published var messageToast: String = ""
    @Published var subtitleToast: String = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    public func fetch() {
        self.getValueFromCoin()
        self.getRangeFromCoin()
        
        Timer.publish(every: 600, on: .main, in: .default)
            .autoconnect()
            .sink { time in
                self.getValueFromCoin()
                self.getRangeFromCoin()
                print(time)
            }
            .store(in: &cancellables)
    }
    
    private func getValueFromCoin() {
        CoinFetcher
            .shared
            .getValueFrom(coin: "USD-BRL") { [weak self] coinModel, error in
                
                if let error = error as? APIErrorEnum {
                    self?.errorCheck(error)
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
            
            if let error = error as? APIErrorEnum {
                self?.errorCheck(error)
                return
            }
            
            self?.rangeValues = values
            
            _ = values.map { name, value in
                self?.chartValues.append(value)
                self?.chartCategories.append(name)
            }
        
            return
        }
    }
    
    private func errorCheck(_ error: APIErrorEnum?) {
        switch error {
        case .network:
            print("😭 Ocorreu um erro: \(String(describing: error?.localizedDescription))")
            self.showToast = true
            self.messageToast = "Ocorreu um erro!"
            self.subtitleToast = "Verifique sua conexão e tente novamente!"
            return
            
        default:
            print("😭 Ocorreu um erro: \(String(describing: error?.localizedDescription))")
            self.showToast = true
            self.messageToast = "Ocorreu um erro!"
            self.subtitleToast = "Tente novamente!"
            return
        }
    }
    
}
