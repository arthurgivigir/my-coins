//
//  WidgetView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 10/12/21.
//

import SwiftUI
import MyCoinsCore
import MyCoinsUIComponents
import MyCoinsWidgetUIComponents

struct WidgetView: View {
    
    @EnvironmentObject var widgetViewModel: WidgetViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                MainWidgetView(
                    coin: CoinModel(date: Date())
                )
                .cornerRadius(25)
                .frame(width: 180, height: 180)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.purple.opacity(0.7), radius: 10, x: -5, y: -5)
                
                VStack {
                    ScrollView {
                        Text("Color Picker")
                    }
                }
                .padding(20)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(
                    color: .mcPrimaryDarker.opacity(0.5),
                    radius: 20,
                    x: 0.5,
                    y: 0.5)
            }
            .frame(
                minWidth: 0,
                maxWidth: UIScreen.main.bounds.width,
                minHeight: 0,
                maxHeight: UIScreen.main.bounds.height,
                alignment: .top
            )
            .background(self.background)
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}
