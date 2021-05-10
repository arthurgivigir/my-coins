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
    
    private let coin: CoinModel
    private var hasBackground: Bool = true
    private var primaryFont: Font.TextStyle = .headline
    private var secondaryFont: Font.TextStyle = .footnote
    
    private let secondGradient: Color = Color.mcPrimary.opacity(0.6)
    
    public init(
        coin: CoinModel,
        hasBackground: Bool = true
    ) {
        self.coin = coin
        self.hasBackground = hasBackground
    }
    
    public init(
        coin: CoinModel,
        hasBackground: Bool = true,
        primaryFont: Font.TextStyle,
        secondaryFont: Font.TextStyle
    ) {
        self.coin = coin
        self.hasBackground = hasBackground
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
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
                            .font(.system(self.primaryFont))
                            .foregroundColor(.white)
                        
                        RateView(rate: coin.rate)
                            .frame(width: 10, height: 10, alignment: .center)
                    }
                    
                    Divider()
                        .background(Color.white)
                        .frame(width: 100, alignment: .center)
                    
                    Text(coin.message ?? "Nada novo por aqui... Circulando! Circulando!")
                        .font(.system(self.secondaryFont))
                        .fontWeight(.light)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
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
