//
//  CoinService.swift
//  MyCoinsServices
//
//  Created by Arthur Givigir on 3/3/21.
//

import Foundation
import MyCoinsCore
import Alamofire
import Combine

protocol CoinServiceProtocol {
    func getValueFrom(coin: String) -> AnyPublisher<CoinModel?, Error>
    func getValueFrom(coins: [String]) -> AnyPublisher<[CoinModel?]?, Error>
}

struct CoinService: CoinServiceProtocol {
    
    func getValueFrom(coin: String) -> AnyPublisher<CoinModel?, Error> {
        
        if let url = URL(string: "https://economia.awesomeapi.com.br/json/\(coin)") {
            return AF.request(url)
                .publishDecodable(type: [CoinModel].self, queue: .global(qos: .background))
                .value()
                .map { coins in return coins.first }
                .mapError { aferror in APIErrorEnum(error: aferror) }
                .eraseToAnyPublisher()
        }
        
        return CurrentValueSubject(nil).eraseToAnyPublisher()
    }
    
    func getValueFrom(coins: [String]) -> AnyPublisher<[CoinModel?]?, Error> {
        
        if let url = URL(string: "https://economia.awesomeapi.com.br/all/\(coins.joined(separator: ","))") {
            return AF.request(url)
                .publishDecodable(type: [String: CoinModel].self, queue: .global(qos: .background))
                .value()
                .map { coins in return Array(coins.values) }
                .mapError { aferror in APIErrorEnum(error: aferror) }
                .eraseToAnyPublisher()
        }
        
        return CurrentValueSubject(nil).eraseToAnyPublisher()
    }
    
}
