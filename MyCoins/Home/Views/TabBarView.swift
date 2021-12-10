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
                    Label("Cotação", systemImage: "dollarsign.circle")
                }
                
            WidgetView()
                .tabItem {
                    Label("Widget", systemImage: "pencil.circle.fill")
                }
            
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .top
        )
        .accentColor(.white)
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color.mcPrimary)
            UITabBar.appearance().barTintColor = UIColor(Color.mcPrimary)
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.purple)
        }
    }
    
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
