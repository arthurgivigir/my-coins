//
//  HomeView.swift
//  MyCoins
//
//  Created by Arthur Gradim Givigir on 10/04/21.
//

import SwiftUI
import MyCoinsCore
import MyCoinsWidgetUIComponents

struct HomeView: View {
    
    init() {
        self.setNavigationColor()
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                
                VStack {
                    MainWidgetView(coin: CoinModel(date: Date()), hasBackground: false)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 200,
                           alignment: .center)
                }
            }
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .top
            )
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("FunCoin", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Image(systemName: "ellipsis")
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(.white)
            )
            .background(
                Image(.charts)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
                    .frame(minWidth: 0,
                           maxWidth: 250,
                           minHeight: 0,
                           maxHeight: .infinity,
                       alignment: .bottom)
            )
            .background(
                LinearGradient(
                gradient:
                    Gradient(
                        colors: [.mcPrimaryDarker, .mcPrimary]),
                        startPoint: .top, endPoint: .bottom
                    )
                .edgesIgnoringSafeArea(.vertical)
            )
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
