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
        var entry = WidgetModel(coin: CoinModel(date: Date()))
        
        if let userDefaults = UserDefaults(suiteName: "group.com.givigir.MyCoins") {
            entry.topColor = Color(userDefaults.colorForKey(key: "topColor") ?? .clear)
            entry.bottomColor = Color(userDefaults.colorForKey(key: "bottomColor") ?? .clear)
        }
        
        completion(entry)
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
                
                if let userDefaults = UserDefaults(suiteName: "group.com.givigir.MyCoins") {
                    widgetModel.topColor = Color(userDefaults.colorForKey(key: "topColor") ?? .clear)
                    widgetModel.bottomColor = Color(userDefaults.colorForKey(key: "bottomColor") ?? .clear)
                }

                entries.append(widgetModel)
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
        }
    }
}

//struct TextWidgetView : View {
//
//    public let coin: CoinModel
//    private let secondGradient: Color = Color.mcPrimary.opacity(0.6)
//
//    public init(coin: CoinModel) {
//        self.coin = coin
//    }
//
//    public var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient:
//                    Gradient(
//                        colors: [.mcPrimaryDarker, .mcPrimary]),
//                        startPoint: .top, endPoint: .bottom
//                    )
//
//            GeometryReader { geometry in
//                VStack {
//                    HStack {
//                        Text(coin.formattedBit)
//                            .bold()
//                            .font(.headline)
//                            .foregroundColor(.white)
//
//                        RateView(rate: coin.rate)
//                            .frame(width: 10, height: 10, alignment: .center)
//                    }
//
//                    Divider()
//                        .background(Color.white)
//                        .frame(width: 100, alignment: .center)
//
//                    Text("E você ai pensando em viajar né minha filha?")
//                        .font(.system(.footnote))
//                        .fontWeight(.light)
//                        .minimumScaleFactor(0.5)
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.white)
//                }
//                .padding(10)
//                .frame(width: geometry.size.width,
//                       height: geometry.size.height,
//                       alignment: .center)
//            }
//
//        }
//        .background(Color.white)
//    }
//}

@main
struct MyCoinsWidget: Widget {
    let kind: String = "MyCoinsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MainWidgetView(coin: entry.coin, topColor: .constant(entry.topColor ?? .mcPrimaryDarker), bottomColor: .constant(entry.bottomColor ?? .mcPrimary))
//            TextWidgetView(coin: entry)
        }
        .configurationDisplayName("Zooin Widget")
        .description("Este é widget do Zooin!")
    }
}

struct MyCoinsWidget_Previews: PreviewProvider {
    static var previews: some View {
//        RateView(rate: .stable)
//            .padding(20)
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
        MainWidgetView(coin: CoinModel(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
//        TextWidgetView(coin: CoinModel(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


extension UserDefaults {
  func colorForKey(key: String) -> UIColor? {
    var colorReturnded: UIColor?
    if let colorData = data(forKey: key) {
      do {
        if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
          colorReturnded = color
        }
      } catch {
        print("Error UserDefaults")
      }
    }
    return colorReturnded
  }
  
  func setColor(color: UIColor?, forKey key: String) {
    var colorData: NSData?
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
        colorData = data
      } catch {
        print("Error UserDefaults")
      }
    }
    set(colorData, forKey: key)
  }
}
