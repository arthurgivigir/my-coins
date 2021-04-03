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

public struct MainWidgetView: View {
    
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
                    Text("\(coin.bid ?? "0.00")")
                        .bold()
                        .font(.headline)
                        .foregroundColor(.white)
                    
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

struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MainWidgetView(coin: CoinModel(date: Date()))
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 mini"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
