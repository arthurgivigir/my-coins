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
    var body: some View {
        NavigationView {
            ZStack {
                Color.mcPrimary
                MainWidgetView(
                    coin: CoinModel(date: Date())
                )
                .cornerRadius(25)
                .frame(width: 180, height: 180)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.purple.opacity(0.7), radius: 10, x: -5, y: -5)
            }
            .edgesIgnoringSafeArea(.all)
            .frame(
                minWidth: 0,
                maxWidth: UIScreen.main.bounds.width,
                minHeight: 0,
                maxHeight: UIScreen.main.bounds.height,
                alignment: .top
            )
            .navigationBarTitle("", displayMode: .inline)
//            .background(self.background)
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}
