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
    @Published var chartValues = [Double]()
    @Published var chartCategories = [String]()
    @Published var showToast: Bool = false
    @Published var messageToast: String = ""
    @Published var subtitleToast: String = ""
    
    private var lastUpdate: Date = Date()
    private var cancellables: Set<AnyCancellable> = []
    
    public func fetch() {
        
        self.refreshValues()
        self.getCoinValues()
        
        Timer.publish(every: 600, on: .main, in: .default)
            .autoconnect()
            .sink { time in
                self.getCoinValues()
            }
            .store(in: &cancellables)
    }
    
    public func reload() {
        if !Date().timeIntervalSince(lastUpdate).isLess(than: 60) {
            self.refreshValues()
            self.getCoinValues()
            self.lastUpdate = Date()
            return
        }
        
        self.showToast = true
        self.messageToast = "Aguarde mais um pouco!"
        self.subtitleToast = "Espere um minuto para tentar atualizar novamente!"
        
    }
    
    private func getCoinValues() {
        
        CoinFetcher
            .shared
            .getCoinValues(from: "USD", to: "BRL") { [weak self] coinModel, chartCategories, chartValues, error in
                if let error = error as? APIErrorEnum {
                    self?.errorCheck(error)
                    return
                }
                
                if let coinModel = coinModel {
                    self?.coinModel = coinModel
                }
                
                if let chartCategories = chartCategories,
                   let chartValues = chartValues {
                    self?.chartCategories = chartCategories
                    self?.chartValues = chartValues
                }
            }
    }
    
    private func refreshValues() {
        self.chartValues = []
        self.chartCategories = []
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
