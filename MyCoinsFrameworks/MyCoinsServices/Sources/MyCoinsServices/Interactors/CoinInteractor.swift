//
//  CoinInteractor.swift
//  MyCoinsServices
//
//  Created by Arthur Givigir on 3/3/21.
//

import Foundation
import MyCoinsCore
import Combine
import CloudKit

public protocol CoinInteractorProtocol {
    func getCoinValueFrom(from: String, to: String) -> AnyPublisher<CoinModel?, Error>
    func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error>
    
    func subscribeToCloud(_ onFinish: @escaping (Result<Void, Error>) -> Void)
    func getServicesInformation(with id: CKRecord.ID?, onFinish: @escaping (Result<Void, Error>) -> Void)
}

public struct CoinInteractor: CoinInteractorProtocol {
    private var coinService: CoinServiceProtocol
    public typealias Void = ()
    
    public init() {
        self.coinService = CoinService()
    }
    
    public func getCoinValueFrom(from: String, to: String) -> AnyPublisher<CoinModel?, Error> {
        
        return self.coinService
            .getCoinValuesFrom(from: from, to: to)
            .map { coinModels -> CoinModel? in
                return coinModels?.first(where: { coinModel in
                    if let _ = coinModel.message {
                        return true
                    }
                    
                    return false
                })
            }
            .eraseToAnyPublisher()
    }
    
    public func getCoinValuesFrom(from: String, to: String) -> AnyPublisher<[CoinModel]?, Error> {
        
        return self.coinService
            .getCoinValuesFrom(from: from, to: to)
            .map { coinsModel -> [CoinModel]? in
                return coinsModel
            }
            .eraseToAnyPublisher()
    }
    
    public func subscribeToCloud(_ onFinish: @escaping (Result<Void, Error>) -> Void) {
        if let _ = KeychainHelper.shared.getServiceData {
            self.coinService.subscribeToCloud(onFinish)
            return
        }
        
        getServicesInformation(onFinish: onFinish)
    }
    
    public func getServicesInformation(with id: CKRecord.ID? = nil, onFinish: @escaping (Result<Void, Error>) -> Void) {
        self.coinService.getServicesInformation(with: id) { result in
            switch result {
            case .success(let data):
                KeychainHelper.shared.save(data)
                onFinish(.success(()))
            case .failure(let failure):
                onFinish(.failure(failure))
            }
            
        }
    }
}

final class KeychainHelper {
    static let shared = KeychainHelper()
    static let SEC_SERVICE = "mercado-maluco-service-infos"
    static let SEC_ACCOUNT = "mercadomaluco"
    
    private init() {}
    
    var getServiceData: ServiceData? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: KeychainHelper.SEC_SERVICE,
            kSecAttrAccount: KeychainHelper.SEC_ACCOUNT,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        guard let data = result as? Data else {
            return nil
        }
        
        return try? JSONDecoder().decode(ServiceData.self, from: data)
    }
    
    func save(_ serviceData: ServiceData) {
        guard let serviceDataJson = serviceData.toJson() else { return }
        
        let query = [
            kSecValueData: Data(serviceDataJson.utf8),
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: KeychainHelper.SEC_SERVICE,
            kSecAttrAccount: KeychainHelper.SEC_ACCOUNT
        ] as CFDictionary
        print("🚧 Query: \(String(describing: query))")
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            if status == errSecDuplicateItem {
                let query = [
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrService: KeychainHelper.SEC_SERVICE,
                    kSecAttrAccount: KeychainHelper.SEC_ACCOUNT
                ] as CFDictionary
                
                let attributedToUpdate = [kSecValueData: Data(serviceDataJson.utf8)] as CFDictionary
                let status = SecItemUpdate(query, attributedToUpdate)
                print("🚧 Failure: \(String(describing: KeychainError(error: status)))")
                
                return
            }
            
            print("🚧 Failure: \(String(describing: KeychainError(error: status)))")
        }
    }
}

enum KeychainError {
    case FunctionNotImplemented
    case InvalidParameters
    case MemoryAllocationError
    case KeychainNotAvailable
    case DuplicateItem
    case ItemNotFound
    case InteractionNotAllowed
    case DecodingError
    case AuthenticationFailed
    
    init?(error: OSStatus) {
        switch error {
        case errSecUnimplemented:
            self = .FunctionNotImplemented
        case errSecParam:
            self = .InvalidParameters
        case errSecAllocate:
            self = .MemoryAllocationError
        case errSecNotAvailable:
            self = .KeychainNotAvailable
        case errSecDuplicateItem:
            self = .DuplicateItem
        case errSecItemNotFound:
            self = .ItemNotFound
        case errSecInteractionNotAllowed:
            self = .InteractionNotAllowed
        case errSecDecode:
            self = .DecodingError
        case errSecAuthFailed:
            self = .AuthenticationFailed
        default:
            return nil
        }
    }
    
    /// A description of the error. Not localized.
    var errorDescription: String {
        switch self {
        case .FunctionNotImplemented:
            return "Function or operation not implemented."
        case .InvalidParameters:
            return "One or more parameters passed to a function were not valid."
        case .MemoryAllocationError:
            return "Failed to allocate memory."
        case .KeychainNotAvailable:
            return "No keychain is available. You may need to restart your computer."
        case .DuplicateItem:
            return "The specified item already exists in the keychain."
        case .ItemNotFound:
            return "The specified item could not be found in the keychain."
        case .InteractionNotAllowed:
            return "User interaction is not allowed."
        case .DecodingError:
            return "Unable to decode the provided data."
        case .AuthenticationFailed:
            return "The user name or passphrase you entered is not correct."
        }
    }
}
