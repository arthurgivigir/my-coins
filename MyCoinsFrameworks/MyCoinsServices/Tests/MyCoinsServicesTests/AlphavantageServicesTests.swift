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
    private var disposables: Set<AnyCancellable> = []
    
    func testReturnByOneCoin() throws {
        let promise = expectation(description: "Result coin from service")
        
        interactor
            .getStockPriceFrom(from: "USD", to: "BRL")
            .sink { completion in
                
            } receiveValue: { coinModel in
                
                if let coinModel = coinModel {
                    print("Coin Value: \(String(describing: coinModel.askPrice))")
                } else {
                    XCTFail("Returned empty hotels from service")
                }
                
                promise.fulfill()
            }
            .store(in: &disposables)

        wait(for: [promise], timeout: 5)
    }
    
    func testReturnStockPrices() throws {
        let promise = expectation(description: "Result coin from service")
        
        interactor
            .getStockPricesFrom(from: "USD", to: "BRL")
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
                        print("Coin Value: \(String(describing: coinModel.value.close))")
                        print("Coin Value: \(String(describing: coinModel.key))")
//                        print("Coin timestamp: \(String(describing: coinModel?.))")
                    }
                    
                } else {
                    XCTFail("Returned empty hotels from service")
                }
                
                promise.fulfill()
            }
            .store(in: &disposables)

        wait(for: [promise], timeout: 10)
    }

}
