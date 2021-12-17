//
//  View+MyCoins.swift
//  
//
//  Created by Arthur Gradim Givigir on 10/04/21.
//
import SwiftUI

public extension View {
    
    var background: some View {
        return LinearGradient(
                gradient:
                    Gradient(
                        colors: [.mcPrimary, .mcPrimary]),
                        startPoint: .top, endPoint: .bottom
                    )
                .edgesIgnoringSafeArea(.vertical)
    }
    
    func setNavigationColor() {
        
        let purpleColor = UIColor(Color.mcPrimary)
        UINavigationBar.appearance().barTintColor = purpleColor
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
}
