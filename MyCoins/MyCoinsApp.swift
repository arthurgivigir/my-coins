//
//  MyCoinsApp.swift
//  MyCoins
//
//  Created by Arthur Givigir on 2/20/21.
//

import SwiftUI
import MyCoinsServices

@main
struct MyCoinsApp: App {
    
    private var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(self.homeViewModel)
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: Tests with launch screen
//public extension UIApplication {
//
//    func clearLaunchScreenCache() {
//        do {
//            try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
//        } catch {
//            print("Failed to delete launch screen cache: \(error)")
//        }
//    }
//
//}
