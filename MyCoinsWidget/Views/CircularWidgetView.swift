//
//  CircularWidgetView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 10/10/22.
//

import SwiftUI
import MyCoinsCore
import WidgetKit

@available(iOS 16.0, *)
struct CircularWidgetView: View {
    
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
                .background(Color.mcPrimary.opacity(0.3))
            
            ViewThatFits {
                VStack(spacing: 2.0) {
                    RateWidgetView(rate: coin.rateEnum)
                        .font(.caption2)
                    
                    Text("\(coin.formattedBit)")
                        .font(.system(size: 14.0))
                        .fontWeight(.regular)
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct CircularWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CircularWidgetView(coin: CoinModel(date: Date()))
    }
}
