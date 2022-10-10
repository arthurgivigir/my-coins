//
//  MyCoinsWidget.swift
//  MyCoinsWidget
//
//  Created by Arthur Givigir on 2/20/21.
//

import WidgetKit
import SwiftUI
import Intents
import Combine
import MyCoinsCore
import MyCoinsServices
import MyCoinsWidgetUIComponents
import MyCoinsUIComponents

@main
struct MyCoinsWidget: Widget {
    let kind: String = "MyCoinsWidget"
    
    private var supportedFamilies: [WidgetFamily] {
        if #available(iOSApplicationExtension 16.0, *) {
            return [
                .systemSmall,
                .systemMedium,
                .systemLarge,
                .accessoryCircular,
                .accessoryRectangular,
                .accessoryInline
            ]
        } else {
            return [
                .systemSmall,
                .systemMedium,
                .systemLarge
            ]
        }
    }

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: GetCoinProvider()
        ) { entry in
            MainWidgetView(
                coin: entry.coin,
                topColor: .constant(entry.topColor ?? .mcPrimaryDarker),
                bottomColor: .constant(entry.bottomColor ?? .mcPrimary)
            )
        }
        .configurationDisplayName("Zooin")
        .description("Mostra a alta ou a queda do dólar, acompanhado de algumas frases engraçadas e bem divertidas.")
        .supportedFamilies(supportedFamilies)
    }
}

struct MyCoinsWidget_Previews: PreviewProvider {
    static var previews: some View {
        MainWidgetView(
            coin: CoinModel(date: Date())
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        if #available(iOSApplicationExtension 16.0, *) {
            MainWidgetView(
                coin: CoinModel(date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            
            MainWidgetView(
                coin: CoinModel(date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            
            MainWidgetView(
                coin: CoinModel(date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        }
    }
}
