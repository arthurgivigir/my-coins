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
            VStack {
                // Widget Space
                HStack {
                    MainWidgetView(
                        coin: self.homeViewModel.coinModel,
                        hasBackground: false,
                        primaryFont: .largeTitle,
                        secondaryFont: .callout)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 180,
                           alignment: .center)
                        .background(BlurEffectView())
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.5), radius: 20, x: 0.5, y: 0.5)
                        
                }
                .padding(20)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: 220,
                   alignment: .center)
                
                // Chart and animation space
                VStack {
                    ChartView(
                        title: "Variação cambial",
                        subtitle: "Dólar hoje",
                        chartData: self.$homeViewModel.chartValues,
                        chartCategories: self.$homeViewModel.chartCategories
                    )
                    .frame(width: UIScreen.main.bounds.width, height: 220, alignment: .top)
                    
                    MCLottieView(name: LottieNames.capitalInvestiment.rawValue, loopMode: .loop)
                        .scaledToFit()
                        .opacity(0.8)
                        .frame(minWidth: 0,
                               maxWidth: 250,
                               minHeight: 0,
                               maxHeight: .infinity,
                           alignment: .bottom)
                }
                .padding(30)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0.5, y: 0.5)
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


struct BlurEffectView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        return UIVisualEffectView(effect: blurEffect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
