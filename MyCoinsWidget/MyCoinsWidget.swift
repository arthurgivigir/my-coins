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

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> CoinModel {
        CoinModel(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CoinModel) -> ()) {
        let entry = CoinModel(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CoinModel] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for entryHour in 0..<5 {
//            if let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) {
//
//                CoinFetcher.shared
//                    .getValueFrom(coin: "USD-BRL") { coin in
//                        guard var coin = coin else { return }
//                        coin.date = entryDate
//                        entries.append(coin)
//                }
//            }
//        }
        CoinFetcher.shared
            .getValueFrom(coin: "USD-BRL") { coin in
                guard var coin = coin else { return }
                
                let date = Date()
                let calendar = Calendar.current
                coin.date = calendar.date(byAdding: .minute, value: 5, to: date)!

                entries.append(coin)
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
        }
    }
}

struct MyCoinsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.green
            
            VStack {
                Text(self.entry.date, style: .time)
                
                Text("\(entry.bid ?? "0.00")")
                    .bold()
                    .font(.headline)
            }
            
        }
    }
}

@main
struct MyCoinsWidget: Widget {
    let kind: String = "MyCoinsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MyCoinsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Coins Widget")
        .description("This is an example widget.")
    }
}

struct MyCoinsWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyCoinsWidgetEntryView(entry: CoinModel(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
