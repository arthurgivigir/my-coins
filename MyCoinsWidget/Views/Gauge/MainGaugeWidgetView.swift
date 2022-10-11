//
//  MainGaugeWidgetView.swift
//  MyCoinsWidgetExtension
//
//  Created by Arthur Givigir on 11/10/22.
//

import SwiftUI
import MyCoinsCore

struct MainGaugeWidgetView: View {
    
    @Environment(\.widgetFamily) private var family
    
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            switch family {
            case .accessoryRectangular:
                GaugeRectangularWidgetView(coin: coin)
            default:
                GaugeCircularWidgetView(coin: coin)
            }
        } else {
            EmptyView()
        }
    }
}

struct MainGaugeWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MainGaugeWidgetView(coin: CoinModel(date: Date()))
    }
}
