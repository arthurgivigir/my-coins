//
//  SmallWidgetView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 07/10/22.
//

import SwiftUI
import MyCoinsCore

struct SmallWidgetView: View {
    
    private let coin: CoinModel
    private var hasBackground: Bool = true
    private var primaryFont: Font.TextStyle = .headline
    private var secondaryFont: Font.TextStyle = .footnote
    
    @Binding var topColor: Color
    @Binding var bottomColor: Color
    @Environment(\.widgetFamily) private var family
    
    private let secondGradient: Color = Color.mcPrimary.opacity(0.6)
    
    public init(
        coin: CoinModel,
        hasBackground: Bool = true,
        topColor: Binding<Color> = .constant(.mcPrimaryDarker),
        bottomColor: Binding<Color> = .constant(.mcPrimary)
    ) {
        self.coin = coin
        self.hasBackground = hasBackground
        self._topColor = topColor
        self._bottomColor = bottomColor
    }
    
    var body: some View {
        ZStack {
            
            if hasBackground {
                LinearGradient(
                    gradient:
                        Gradient(
                            colors: [topColor, bottomColor]),
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
                        
                        RateView(rate: coin.rateEnum)
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

struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView(coin: CoinModel(date: Date()))
    }
}
