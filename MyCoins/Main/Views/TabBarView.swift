//
//  TabBarView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 26/11/21.
//

import SwiftUI

struct TabBarView: View {
    
    private var homeViewModel = HomeViewModel()
    private var widgetViewMode = WidgetViewModel()
    
    var body: some View {
        
        TabView {
            HomeView()
                .environmentObject(self.homeViewModel)
                .tabItem {
                    Label("Cotação", systemImage: "dollarsign.circle")
                }
                
            WidgetView()
                .environmentObject(self.widgetViewMode)
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
