//
//  TabBarView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 26/11/21.
//

import SwiftUI

struct TabBarView: View {
    
    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    
                Text("Widget")
                    .tabItem {
                        Label("Widget", systemImage: "square.and.pencil")
                    }
                
            }
            .navigationBarTitle("", displayMode: .inline)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .top
            )
            .accentColor(.white)
        }
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
