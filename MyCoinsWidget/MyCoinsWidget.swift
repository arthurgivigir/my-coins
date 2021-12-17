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

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> WidgetModel {
        WidgetModel(coin: CoinModel(date: Date()))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WidgetModel) -> ()) {
        var entry = WidgetModel(coin: CoinModel(date: Date(), close: "3.40"))
        
        
        CoinFetcher.shared
            .getCoinValue(from: "USD", to: "BRL") { coin, error in
                
                if let error = error {
                    print("😭 Ocorreu um erro: \(error.localizedDescription)")
                    return
                }
                
                guard let coin = coin else { return }
                
                entry = WidgetModel(coin: coin)
                
                if let userDefaults = UserDefaults(suiteName: UserDefaultsEnum.suiteName.rawValue) {
                    entry.topColor = Color(userDefaults.colorForKey(key: UserDefaultsEnum.topColor.rawValue) ?? UIColor(.mcPrimaryDarker))
                    entry.bottomColor = Color(userDefaults.colorForKey(key: UserDefaultsEnum.bottomColor.rawValue) ?? UIColor(.mcPrimary))
                }
                
                completion(entry)
            }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetModel] = []
        
        CoinFetcher.shared
            .getCoinValue(from: "USD", to: "BRL") { coin, error in
                
                if let error = error {
                    print("😭 Ocorreu um erro: \(error.localizedDescription)")
                    return
                }
                
                guard var coin = coin else { return }
                
                let date = Date()
                let calendar = Calendar.current
                coin.date = calendar.date(byAdding: .minute, value: 5, to: date)!
                
                var widgetModel = WidgetModel(date: coin.date, coin: coin)
                
                if let userDefaults = UserDefaults(suiteName: UserDefaultsEnum.suiteName.rawValue) {
                    widgetModel.topColor = Color(userDefaults.colorForKey(key: UserDefaultsEnum.topColor.rawValue) ?? UIColor(.mcPrimaryDarker))
                    widgetModel.bottomColor = Color(userDefaults.colorForKey(key: UserDefaultsEnum.bottomColor.rawValue) ?? UIColor(.mcPrimary))
                }

                entries.append(widgetModel)
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
        }
    }
}

@main
struct MyCoinsWidget: Widget {
    let kind: String = "MyCoinsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MainWidgetView(coin: entry.coin, topColor: .constant(entry.topColor ?? .mcPrimaryDarker), bottomColor: .constant(entry.bottomColor ?? .mcPrimary))
        }
        .configurationDisplayName("Zooin Widget")
        .description("Este é widget do Zooin!")
    }
}

struct MyCoinsWidget_Previews: PreviewProvider {
    static var previews: some View {
        MainWidgetView(coin: CoinModel(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
