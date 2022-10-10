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
    
    public init(
        coin: CoinModel,
        hasBackground: Bool = true,
        primaryFont: Font.TextStyle,
        secondaryFont: Font.TextStyle,
        topColor: Binding<Color>,
        bottomColor: Binding<Color>
    ) {
        self.coin = coin
        self.hasBackground = hasBackground
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self._topColor = topColor
        self._bottomColor = bottomColor
    }
    
    public var body: some View {
        
        switch family {
        case .accessoryRectangular:
            RectangularWidgetView(coin: coin)
        case .accessoryCircular:
            if #available(iOS 16.0, *) {
                CircularWidgetView(coin: coin)
            }
        case .accessoryInline:
            InlineWidgetView(coin: coin)
        default:
            SmallWidgetView(
                coin: coin,
                hasBackground: hasBackground,
                topColor: $topColor,
                bottomColor: $bottomColor
            )
        }
    }
}

struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MainWidgetView(coin: CoinModel(date: Date()))
    }
}
