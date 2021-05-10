//
//  HomeHeaderView.swift
//  MyCoins
//
//  Created by Arthur Gradim Givigir on 01/05/21.
//

import SwiftUI
import MyCoinsWidgetUIComponents
import MyCoinsUIComponents

struct HomeHeaderView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
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
            .background(BlurEffectView(effect: .regular))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.5), radius: 20, x: 0.5, y: 0.5)
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
            .environmentObject(HomeViewModel())
            .frame(minWidth: 0,
                   maxWidth: 400,
                   minHeight: 0,
                   maxHeight: 280,
               alignment: .center)
    }
}
