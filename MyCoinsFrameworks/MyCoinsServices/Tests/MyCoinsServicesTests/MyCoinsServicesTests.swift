//
//  MyCoinsServicesTests.swift
//  MyCoinsServicesTests
//
//  Created by Arthur Givigir on 3/3/21.
//

import XCTest
import Combine
@testable import MyCoinsServices

class MyCoinsServicesTests: XCTestCase {
    
    private let interactor = CoinInteractor()
    private var disposables: Set<AnyCancellable> = []
    
    func testReturnByOneCoin() throws {
        let promise = expectation(description: "Result coin from service")
        
        interactor
            .getValueFrom(coin: "USD-BRL")
            .sink { completion in
                
            } receiveValue: { coinModel in
                
                if let coinModel = coinModel {
                    print("Coin Value: \(String(describing: coinModel.rate))")
                } else {
                    XCTFail("Returned empty hotels from service")
                }
                
                promise.fulfill()
            }
            .store(in: &disposables)

        wait(for: [promise], timeout: 5)
    }
    
    
    func testReturnCoins() throws {
        let promise = expectation(description: "Result coin from service")
        
        interactor
            .getValueFrom(coins: ["USD-BRL", "EUR-BRL"])
            .sink { completion in
                
            } receiveValue: { coinsModel in
                
                if let coinsModel = coinsModel {
                    
                    _ = coinsModel.map { coinModel in
                        print("Coin Value: \(String(describing: coinModel?.bid))")
                    }
                    
                } else {
                    XCTFail("Returned empty hotels from service")
                }
                
                promise.fulfill()
            }
            .store(in: &disposables)

        wait(for: [promise], timeout: 5)
    }

}
