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
//        MainWidgetView(
//            coin: self.homeViewModel.coinModel,
//            hasBackground: false,
//            primaryFont: .largeTitle,
//            secondaryFont: .callout)
//            .frame(minWidth: 0,
//                   maxWidth: .infinity,
//                   minHeight: 0,
//                   maxHeight: 180,
//               alignment: .center)
//            .background(BlurEffectView(effect: .regular).opacity(0.2))
//            .cornerRadius(20)
//            .shadow(color: .black.opacity(0.5), radius: 20, x: 0.5, y: 0.5)
        
        VStack(alignment: .leading, spacing: 15) {
            Text("Olá, Tudo bem? 👋🏽")
                .font(.system(.footnote))
                .foregroundColor(.white)
                .fontWeight(.light)
            
            HStack {
                Text(self.homeViewModel.coinModel.formattedBit)
                    .bold()
                    .font(.system(.largeTitle))
                    .foregroundColor(.white)
                
                RateView(rate: self.homeViewModel.coinModel.rateEnum)
                    .frame(width: 10, height: 10, alignment: .center)
            }
            
            Divider()
                .background(Color.white)
                .frame(width: 150, alignment: .center)
            
            Text(self.homeViewModel.coinModel.message ?? "Nada novo por aqui... Circulando! Circulando! Circulando!")
                .font(.system(.body))
                .minimumScaleFactor(0.5)
                .foregroundColor(.white)
            
        }
        .padding(20)
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: 220,
           alignment: .leading)
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
            .environmentObject(HomeViewModel())
            .frame(minWidth: 0,
                   maxWidth: .infinity
            )
            .background(Color.purple)
    }
}
