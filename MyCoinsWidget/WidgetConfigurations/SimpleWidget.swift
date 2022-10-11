//
//  SimpleWidget.swift
//  MyCoinsWidgetExtension
//
//  Created by Arthur Givigir on 11/10/22.
//

import Foundation
import SwiftUI
import WidgetKit
import MyCoinsCore

struct SimpleWidget: Widget {
    let kind: String = "MyCoinsWidget"
    
    private var supportedFamilies: [WidgetFamily] {
        if #available(iOSApplicationExtension 16.0, *) {
            return [
                .systemSmall,
                .systemMedium,
                .accessoryCircular,
                .accessoryRectangular,
                .accessoryInline
            ]
        } else {
            return [
                .systemSmall,
                .systemMedium
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
        .description("Mostra a alta ou a queda do dólar de forma simples e rápida")
        .supportedFamilies(supportedFamilies)
    }
}

struct SimpleWidget_Previews: PreviewProvider {
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
