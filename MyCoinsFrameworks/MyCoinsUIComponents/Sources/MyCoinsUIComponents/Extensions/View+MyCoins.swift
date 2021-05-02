//
//  View.swift
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
                        colors: [.mcPrimaryDarker, .mcPrimary]),
                        startPoint: .top, endPoint: .bottom
                    )
                .edgesIgnoringSafeArea(.vertical)
    }
    
    func setNavigationColor() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
}
