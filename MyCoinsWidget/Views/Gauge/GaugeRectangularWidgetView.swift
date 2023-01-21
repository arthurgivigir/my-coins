//
//  GaugeRectangularWidgetView.swift
//  MyCoinsWidgetExtension
//
//  Created by Arthur Givigir on 11/10/22.
//

import SwiftUI
import MyCoinsCore

struct GaugeRectangularWidgetView: View {
    
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    var body: some View {
        
        let current: Double = Double(coin.close) ?? 0
        let minValue: Double = Double(coin.low) ?? 0
        let maxValue: Double = Double(coin.high) ?? 0
        
        if #available(iOS 16.0, *) {
            HStack(alignment: .center, spacing: 5) {
                Gauge(value: current, in: minValue...maxValue) {
                    RateWidgetView(rate: coin.rateEnum)
                } currentValueLabel: {
                    Text("\(coin.formattedBit)")
                        .font(.system(size: 14.0))
                        .fontWeight(.bold)
                        .monospacedDigit()
                    .widgetAccentable(true)
                }
                .gaugeStyle(.accessoryCircular)
                
                Divider()
                    .background(Color.white)
                    .frame(maxHeight: .infinity, alignment: .center)
                
                ViewThatFits {
                    Text(coin.message ?? "Nada novo por aqui... Circulando! Circulando!")
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            
        } else {
            EmptyView()
        }
    }
}

struct GaugeRectangularWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        GaugeRectangularWidgetView(coin: CoinModel(date: Date()))
    }
}
