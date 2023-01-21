//
//  LockScreenInlineWidgetView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 07/10/22.
//

import SwiftUI
import MyCoinsCore

struct InlineWidgetView: View {
    
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    var body: some View {
        HStack {
            RateWidgetView(rate: coin.rateEnum)
            
            Text("\(coin.formattedBit)")
        }
    }
}

struct InlineWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        InlineWidgetView(coin: CoinModel(date: Date()))
    }
}
