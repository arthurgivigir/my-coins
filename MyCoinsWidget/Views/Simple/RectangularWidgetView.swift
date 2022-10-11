//
//  LockScreenRectangularWidgetView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 07/10/22.
//

import SwiftUI
import MyCoinsCore

struct RectangularWidgetView: View {
    
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 3) {
                    RateWidgetView(rate: coin.rateEnum)
                        .font(.caption2)
                    
                    Divider()
                        .background(Color.white)
                        .frame(height: 10, alignment: .center)
                    
                    Text(coin.formattedBit)
                        .bold()
                        .font(.primaryFont)
                }
                
                if #available(iOS 16.0, *) {
                    ViewThatFits {
                        Text(coin.message ?? "Nada novo por aqui... Circulando! Circulando!")
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .widgetAccentable()
                    }
                }
            }
        }
    }
}

struct RectangularWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        RectangularWidgetView(coin: CoinModel(date: Date()))
    }
}
