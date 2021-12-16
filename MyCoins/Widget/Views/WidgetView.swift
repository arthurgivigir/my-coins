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
                    coin: CoinModel(date: Date()),
                    topColor: self.$widgetViewModel.topColor,
                    bottomColor: self.$widgetViewModel.bottomColor
                )
                .cornerRadius(25)
                .frame(width: 180, height: 180)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.purple.opacity(0.7), radius: 10, x: -5, y: -5)
                
                VStack {
                    List {
                        Section(header: Text("Configurações")) {
                            WidgetTopColorCell(bgColor: self.$widgetViewModel.topColor)
                            WidgetBottomColorCell(bgColor: self.$widgetViewModel.bottomColor)
                            WidgetResetColorCell(
                                topColor: self.$widgetViewModel.topColor,
                                bottomColor: self.$widgetViewModel.bottomColor
                            )
                        }
                        .listRowBackground(Color.gray.opacity(0.1))
                    }
                    .listStyle(.insetGrouped)
                    
                }
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
            .onAppear {
                UITableView.appearance().backgroundColor = .white
                UITableView.appearance().overrideUserInterfaceStyle = .light
            }
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}

struct WidgetTopColorCell: View {
    @Binding var bgColor: Color

    var body: some View {
        HStack {
            ColorPicker("Cor do topo", selection: $bgColor, supportsOpacity: false)
        }
    }
}

struct WidgetBottomColorCell: View {
    @Binding var bgColor: Color
    
    var body: some View {
        HStack {
            ColorPicker("Cor da base", selection: $bgColor, supportsOpacity: false)
        }
    }
}

struct WidgetResetColorCell: View {
    
    @Binding var topColor: Color
    @Binding var bottomColor: Color
    
    var body: some View {
        HStack {
            Text("Voltar a configuração inicial")
        }
        .onTapGesture {
            self.topColor = .mcPrimaryDarker
            self.bottomColor = .mcPrimary
        }
    }
}


