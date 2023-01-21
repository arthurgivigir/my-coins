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
    func getCoinValuesFrom(from: String, to: String, isFrom: String) -> AnyPublisher<[CoinModel]?, Error>
    func subscribeToCloud(_ onFinish: @escaping (Result<Void, Error>) -> Void)
    func getServicesInformation(with id: CKRecord.ID?, _ onFinish: @escaping ((Result<ServiceData, Error>) -> ()))
}

extension ServiceData {
    public static var identifier = "ServiceData"
}

extension CKContainer {
    static var appContainer = "iCloud.givigir.MercadoMaluco"
}

extension CKSubscription {
    static var alertBody = "A new service data was defined"
}

class CoinService: CoinServiceProtocol {

    private let record = CKRecord(recordType: ServiceData.identifier)
    private let appContainer = CKContainer(identifier: CKContainer.appContainer)

    private let newSubscription = CKQuerySubscription(recordType: ServiceData.identifier, predicate: NSPredicate(value: true), options: [.firesOnRecordUpdate])
    
    private var hasSub = false
    
    func getCoinValuesFrom(from: String, to: String, isFrom: String) -> AnyPublisher<[CoinModel]?, Error> {
        
        if let url = KeychainHelper.shared.getServiceData?.requestURL(isFrom),
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
        let subscription = CKQuerySubscription(recordType: ServiceData.identifier,
                                  predicate: predicate,
                                  options: .firesOnRecordUpdate)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = CKSubscription.alertBody
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
        let query = CKQuery(recordType: ServiceData.identifier, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        
        if let id = id {
            appContainer.publicCloudDatabase.fetch(withRecordID: id) { record, error in
                if let error = error {
                    print("🚧 Failure \(error)")
                    onFinish(.failure(error))
                    return
                }
                
                let id = record?[.id]
                let jwtToken = record?[.jwtToken]
                let api = record?[.apiGetCoins]
                let host = record?[.host]
                
                onFinish(
                    .success(
                        ServiceData(
                            id: id,
                            jwtToken: jwtToken,
                            host: host,
                            apiGetCoins: api
                        )
                    )
                )
            }
            
            appContainer.publicCloudDatabase.add(operation)
            
        } else {
            operation.recordMatchedBlock = { _, result in
                switch result {
                case .success(let record):
                    let id = record[.id]
                    let jwtToken = record[.jwtToken]
                    let api = record[.apiGetCoins]
                    let host = record[.host]
                    
                    onFinish(
                        .success(
                            ServiceData(
                                id: id,
                                jwtToken: jwtToken,
                                host: host,
                                apiGetCoins: api
                            )
                        )
                    )
                case .failure(let error):
                    print("🚧 Failure \(error)")
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
