//
//  HomeView.swift
//  MyCoins
//
//  Created by Arthur Gradim Givigir on 10/04/21.
//

import SwiftUI
import MyCoinsCore
import MyCoinsWidgetUIComponents
import MyCoinsUIComponents

struct HomeView: View {
    
    @ObservedObject private var homeViewModel = HomeViewModel()
    
    init() {
        self.setNavigationColor()
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                MainWidgetView(
                    coin: self.homeViewModel.coinModel,
                    hasBackground: false,
                    primaryFont: .title2,
                    secondaryFont: .title3)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: 200,
                       alignment: .center)
                HStack {
                    ChartView(
                        title: "Variação cambial",
                        subtitle: "Dólar hoje",
                        chartData: self.$homeViewModel.chartValues,
                        chartCategories: self.$homeViewModel.chartCategories
                    )
                }
            }
            .onAppear() {
                self.homeViewModel.fetch()
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
                MCLottieView(name: LottieNames.capitalInvestiment.rawValue, loopMode: .loop)
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
