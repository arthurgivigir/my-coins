//
//  GaugeWidget.swift
//  MyCoins
//
//  Created by Arthur Givigir on 11/10/22.
//

import Foundation
import SwiftUI
import WidgetKit
import MyCoinsCore

struct GaugeWidget: Widget {
    let kind: String = "GaugeWidget"
    
    private var supportedFamilies: [WidgetFamily] {
        if #available(iOSApplicationExtension 16.0, *) {
            return [
                .accessoryCircular,
                .accessoryRectangular
            ]
        } else {
            return []
        }
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: GetCoinProvider()
        ) { entry in
            MainGaugeWidgetView(coin: entry.coin)
        }
        .configurationDisplayName("Zooin")
        .description("Mostra a alta ou a queda do dólar, através de um gráfico circular, o valor atual dentre o mínimo e a máximo do dia.")
        .supportedFamilies(supportedFamilies)
    }
}

struct GaugeWidget_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            MainGaugeWidgetView(
                coin: CoinModel(date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            
            MainGaugeWidgetView(
                coin: CoinModel(date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        }
    }
}
