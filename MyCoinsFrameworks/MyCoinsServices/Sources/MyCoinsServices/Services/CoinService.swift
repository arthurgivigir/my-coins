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
import CloudKit
import UserNotifications

protocol CoinServiceProtocol {
    func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error>
    func subscribeToCloud(_ onFinish: @escaping (Result<Void, Error>) -> Void)
    func getServicesInformation(with id: CKRecord.ID?, _ onFinish: @escaping ((Result<ServiceData, Error>) -> ()))
}

class CoinService: CoinServiceProtocol {

    private let record = CKRecord(recordType: "ServiceData")
    private let appContainer = CKContainer(identifier:  "iCloud.givigir.MercadoMaluco")

    private let alphavantageUrl = "https://mercado-maluco.vercel.app"
    private let newSubscription = CKQuerySubscription(recordType: "ServiceData", predicate: NSPredicate(value: true), options: [.firesOnRecordUpdate])
    
    private var hasSub = false
    
    func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error> {
        if let url = URL(string: "\(alphavantageUrl)/api/v1/coins"),
           let jwtToken = KeychainHelper.shared.getServiceData?.jwtToken {
            
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
    
    func subscribeToCloud(_ onFinish: @escaping (Result<Void, Error>) -> Void) {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "ServiceData",
                                  predicate: predicate,
                                  options: .firesOnRecordUpdate)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "A new service data was defined"
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        let operation = CKModifySubscriptionsOperation(
                subscriptionsToSave: [subscription],
                subscriptionIDsToDelete: []
            )
        
        operation.modifySubscriptionsResultBlock = { result in
            switch result {
            case .success:
                onFinish(.success(()))
            case .failure(let error):
                onFinish(.failure(error))
            }
            
        }
        operation.qualityOfService = .utility
        appContainer.publicCloudDatabase.add(operation)
    }
    
    func getServicesInformation(with id: CKRecord.ID?, _ onFinish: @escaping ((Result<ServiceData, Error>) -> ())) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ServiceData", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        
        if let id = id {
            appContainer.publicCloudDatabase.fetch(withRecordID: id) { record, error in
                if let error = error {
                    print("🚧 failure \(error)")
                    onFinish(.failure(error))
                    return
                }
                
                let id = record?[.id]
                let jwtToken = record?[.jwtToken]
                
                onFinish(.success(ServiceData(id: id, jwtToken: jwtToken)))
            }
            
            appContainer.publicCloudDatabase.add(operation)
            
        } else {
            operation.recordMatchedBlock = { _, result in
                switch result {
                case .success(let record):
                    let id = record[.id]
                    let jwtToken = record[.jwtToken]
                    
                    onFinish(.success(ServiceData(id: id, jwtToken: jwtToken)))
                case .failure(let error):
                    print("🚧 failure \(error)")
                    onFinish(.failure(error))
                }
            }
            
            appContainer.publicCloudDatabase.add(operation)
        }
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
