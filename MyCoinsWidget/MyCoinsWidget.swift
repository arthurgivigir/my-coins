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
    
    func placeholder(in context: Context) -> CoinModel {
        CoinModel(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CoinModel) -> ()) {
        let entry = CoinModel(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CoinModel] = []

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

struct TextWidgetView : View {
    
    public let coin: CoinModel
    private let secondGradient: Color = Color.mcPrimary.opacity(0.6)
    
    public init(coin: CoinModel) {
        self.coin = coin
    }
    
    public var body: some View {
        ZStack {
            LinearGradient(
                gradient:
                    Gradient(
                        colors: [.mcPrimary, secondGradient]),
                        startPoint: .top, endPoint: .bottom
                    )

            GeometryReader { geometry in
                VStack {
                    HStack {
                        Text(coin.formattedBit)
                            .bold()
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        RateView(rate: coin.rate)
                            .frame(width: 10, height: 10, alignment: .center)
                    }
                    
                    Divider()
                        .background(Color.white)
                        .frame(width: 100, alignment: .center)
                    
                    Text("E você ai pensando em viajar né minha filha?")
                        .font(.system(.footnote))
                        .fontWeight(.light)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .padding(10)
                .frame(width: geometry.size.width,
                       height: geometry.size.height,
                       alignment: .center)
            }

        }
        .background(Color.white)
    }
}

@main
struct MyCoinsWidget: Widget {
    let kind: String = "MyCoinsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MainWidgetView(coin: entry)
//            TextWidgetView(coin: entry)
        }
        .configurationDisplayName("My Coins Widget")
        .description("This is an example widget.")
    }
}

struct MyCoinsWidget_Previews: PreviewProvider {
    static var previews: some View {
        TextWidgetView(coin: CoinModel(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
