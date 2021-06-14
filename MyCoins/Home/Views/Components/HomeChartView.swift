//
//  HomeChartView.swift
//  MyCoins
//
//  Created by Arthur Gradim Givigir on 01/05/21.
//

import SwiftUI
import MyCoinsUIComponents

struct HomeChartView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            ChartView(
                title: "Variação cambial",
                subtitle: "Dólar hoje",
                chartData: self.$homeViewModel.chartValues,
                chartCategories: self.$homeViewModel.chartCategories
            )
            .frame(width: UIScreen.main.bounds.width, height: 220, alignment: .top)
        }
    }
}

struct HomeChartView_Previews: PreviewProvider {
    static var previews: some View {
        HomeChartView()
            .environmentObject(HomeViewModel())
    }
}
