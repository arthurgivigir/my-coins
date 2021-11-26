//
//  TabBarView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 26/11/21.
//

import SwiftUI

struct TabBarView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "list.dash")
                }
            
            Text("Widget")
                .tabItem {
                    Label("Widget", systemImage: "list.dash")
                }
            
        }
        .onAppear {
            UITabBar.appearance().barTintColor = .white
        }
    }
    
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
