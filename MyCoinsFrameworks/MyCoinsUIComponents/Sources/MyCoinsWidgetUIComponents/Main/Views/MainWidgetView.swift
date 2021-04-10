//
//  SwiftUIView.swift
//  
//
//  Created by Arthur Givigir on 3/28/21.
//

import SwiftUI
import MyCoinsCore
import MyCoinsUIComponents
import WidgetKit

public struct MainWidgetView : View {
    
    public let coin: CoinModel
    private var hasBackground: Bool = true
    private let secondGradient: Color = Color.mcPrimary.opacity(0.6)
    
    public init(coin: CoinModel, hasBackground: Bool = true) {
        self.coin = coin
        self.hasBackground = hasBackground
    }
    
    public var body: some View {
        ZStack {
            
            if hasBackground {
                LinearGradient(
                    gradient:
                        Gradient(
                            colors: [.mcPrimaryDarker, .mcPrimary]),
                            startPoint: .top, endPoint: .bottom
                        )
            }
            
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
        .background(self.hasBackground ? Color.white : .clear)
    }
}

struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MainWidgetView(coin: CoinModel(date: Date()))
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 mini"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
