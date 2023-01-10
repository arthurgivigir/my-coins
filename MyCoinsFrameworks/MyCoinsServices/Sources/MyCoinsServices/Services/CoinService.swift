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

//
//  TopRedditsService.swift
//  https://github.com/arthurgivigir
//
//  Created by Arthur Givigir on 19/11/22.
//

import Foundation

//protocol TopRedditsService {
//    func fetchTopReddits(_ afterPage: String?, completion: @escaping((Result<TopRedditsModel, NetworkError>) -> Void))
//}
//
//class DefaultTopRedditsService: TopRedditsService {
//    private let networkManager: NetworkManager
//    
//    init(networkManager: NetworkManager = NetworkManager()) {
//        self.networkManager = networkManager
//    }
//    
//    func fetchTopReddits(_ afterPage: String?, completion: @escaping ((Result<TopRedditsModel, NetworkError>) -> Void)) {
//        guard let url = TopRedditsAPIEndpoints.topReddits(afterPage).url else {
//            completion(.failure(.badlyFormattedUrl))
//            return
//        }
//        
//        networkManager.makeRequest(with: url, decode: TopRedditsModel.self) { result in
//            completion(result)
//        }
//    }
//}


protocol CoinServiceProtocol {
    func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error>
}

struct CoinService: CoinServiceProtocol {

    private let jwtToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHAiOiJjb20uZ2l2aWdpci5NeUNvaW5zIiwiYXBwbmFtZSI6Inpvb2luIiwiYXBwaWQiOiJIN0VEVjU1MjRLIiwicGFzc3dvcmQiOiJiZk1LQkRCbm1OdlRxTWF3NFFrM2d0XzkyOSJ9.5nB7kg_8aRMh-XE56N1F0L8R50PIbDaat56STpjuZus"
    private let alphavantageUrl = "https://zooin.herokuapp.com"
    
    func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error> {
        
        if let url = URL(string: "\(alphavantageUrl)/getCoinValues") {
            
            let httpHeader: HTTPHeaders = [
                .authorization(bearerToken: jwtToken)
            ]
            
            return AF.request(url, headers: httpHeader)
                .publishDecodable(type: CoinResponse.self, queue: .global(qos: .background))
                .value()
                .map { coinResponse in
                    return coinResponse.coinValues
                }
                .mapError { aferror in
                    APIErrorEnum(error: aferror)
                }
                .eraseToAnyPublisher()
        }
        
        return CurrentValueSubject(nil).eraseToAnyPublisher()
    }
    
    /// Enum of outputsize parameter from alphavantage
    internal enum OutputSize {
        case compact
        case full
    }
    
    /// Enum of outputsize parameter from alphavantage
    internal enum TimeInterval: String {
        case one = "1min"
        case five = "5min"
        case fifteen = "15min"
        case thirty = "30min"
        case sixty = "60min"
    }
}
