//
//  GaugeWidgetView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 11/10/22.
//

import SwiftUI
import MyCoinsCore

struct GaugeCircularWidgetView: View {
    
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    var body: some View {
        
        let current: Double = Double(coin.close) ?? 0
        let minValue: Double = Double(coin.low) ?? 0
        let maxValue: Double = Double(coin.high) ?? 0
        
        
        if #available(iOS 16.0, *) {
            Gauge(value: current, in: minValue...maxValue) {
                RateWidgetView(rate: coin.rateEnum)
            } currentValueLabel: {
                Text("\(coin.formattedBit)")
                    .font(.system(size: 14.0))
                    .fontWeight(.bold)
                    .monospacedDigit()
                .widgetAccentable(true)        }
            .gaugeStyle(.accessoryCircular)
        } else {
            EmptyView()
        }
    }
}

@available(iOS 16.0, *)
struct GaugeWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        GaugeCircularWidgetView(coin: CoinModel(date: Date()))
    }
}
