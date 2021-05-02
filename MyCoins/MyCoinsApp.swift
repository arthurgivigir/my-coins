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
