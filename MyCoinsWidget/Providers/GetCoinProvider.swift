//
//  GetCoinProvider.swift
//  MyCoinsWidgetExtension
//
//  Created by Arthur Givigir on 07/10/22.
//

import Foundation
import SwiftUI
import MyCoinsCore
import WidgetKit
import MyCoinsServices
import MyCoinsUIComponents

struct GetCoinProvider: IntentTimelineProvider {
    
    typealias Entry = WidgetModel
    
    func placeholder(in context: Context) -> WidgetModel {
        WidgetModel(coin: CoinModel(date: Date()))
    }

    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (WidgetModel) -> ()
    ) {
        var entry = WidgetModel(coin: CoinModel(date: Date(), close: "3.40"))
        
        CoinFetcher.shared
            .getCoinValue(from: .USD, to: .BRL) { coin, error in
                
                if let error = error {
                    print("😭 Ocorreu um erro: \(error.localizedDescription)")
                    return
                }
                
                guard let coin = coin else { return }
                
                entry = WidgetModel(coin: coin)
                
                MyCoinsUserDefaults.shared.getColors { topColor, bottomColor in
                    entry.topColor = topColor
                    entry.bottomColor = bottomColor
                }
                
                completion(entry)
            }
    }

    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        var entries: [WidgetModel] = []
        
        CoinFetcher.shared
            .getCoinValue(from: .USD, to: .BRL) { coin, error in
                
                if let error = error {
                    print("😭 Ocorreu um erro: \(error.localizedDescription)")
                    return
                }
                
                guard var coin = coin else { return }
                
                let date = Date()
                let calendar = Calendar.current
                coin.date = calendar.date(
                    byAdding: .minute,
                    value: 5, to: date
                )!
                
                var widgetModel = WidgetModel(
                    date: coin.date,
                    coin: coin
                )
                
                MyCoinsUserDefaults.shared.getColors { topColor, bottomColor in
                    widgetModel.topColor = topColor
                    widgetModel.bottomColor = bottomColor
                }
                entries.append(widgetModel)
                
                let timeline = Timeline(
                    entries: entries,
                    policy: .atEnd
                )
                completion(timeline)
        }
    }
}
