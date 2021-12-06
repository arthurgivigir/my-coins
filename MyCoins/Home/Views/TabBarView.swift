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
                        Label("Home", systemImage: "list.dash")
                    }
                    
                Text("Widget")
                    .tabItem {
                        Label("Widget", systemImage: "list.dash")
                    }
                
            }
            .navigationBarTitle("", displayMode: .inline)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .top
            )
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .white
            UITabBar.appearance().barTintColor = .white
        }
    }
    
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
