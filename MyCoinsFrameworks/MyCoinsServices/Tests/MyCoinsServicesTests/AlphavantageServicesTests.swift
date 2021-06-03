//
//  AlphavantageServicesTests.swift
//  
//
//  Created by Arthur Givigir on 15/05/21.
//
import XCTest
import Foundation

import Combine
@testable import MyCoinsServices

class AlphavantageServicesTests: XCTestCase {
    
    private let interactor = CoinInteractor()
    private let service = CoinService()
    private var disposables: Set<AnyCancellable> = []
    
    
    func testReturnCoinInteractorValue() throws {
        let promise = expectation(description: "Result coin from service")
        
        interactor
            .getCoinValueFrom(from: "USD", to: "BRL")
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("😭\(error.localizedDescription)")
                case .finished:
                    print("Finished testReturnCoinsByDays")
                }
                
            } receiveValue: { coinModel in
                
                if let coinModel = coinModel {
                    print("---------------------------------------------------------------------")
                    print("Coin Value: \(String(describing: coinModel.formattedUpdatedAt))")
                    print("Coin Value: \(String(describing: coinModel.close))")
                    print("Coin Value: \(String(describing: coinModel.pctChange))")
                    print("Coin Value: \(String(describing: coinModel.rate))")
                    print("---------------------------------------------------------------------")
                
                } else {
                    XCTFail("Returned empty hotels from service")
                }
                
                promise.fulfill()
            }
            .store(in: &disposables)

        wait(for: [promise], timeout: 10)
    }
    
    func testReturnCoinServiceValues() throws {
        let promise = expectation(description: "Result coin from service")
        
        service
            .getCoinValuesFrom(from: "USD", to: "BRL")
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("😭\(error.localizedDescription)")
                case .finished:
                    print("Finished testReturnCoinsByDays")
                }
                
            } receiveValue: { coinsModel in
                
                if let coinsModel = coinsModel {
                    
                    _ = coinsModel.map { coinModel in
                        print("---------------------------------------------------------------------")
                        print("Coin Value: \(String(describing: coinModel.formattedUpdatedAt))")
                        print("Coin Value: \(String(describing: coinModel.close))")
                        print("---------------------------------------------------------------------")
                    }
//                    
                } else {
                    XCTFail("Returned empty hotels from service")
                }
                
                promise.fulfill()
            }
            .store(in: &disposables)

        wait(for: [promise], timeout: 10)
    }

}
