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
    
    init() {
        UIApplication.shared.clearLaunchScreenCache()
        MyCoinsServices.shared.setupFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(self.homeViewModel)
                .preferredColorScheme(.dark)
        }
    }
}


public extension UIApplication {

    func clearLaunchScreenCache() {
        do {
            try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
        } catch {
            print("Failed to delete launch screen cache: \(error)")
        }
    }

}
