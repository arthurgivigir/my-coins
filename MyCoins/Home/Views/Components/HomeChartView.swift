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
                chartCategories: self.$homeViewModel.chartCategories,
                lineChartData: self.$homeViewModel.lineChartData
            )
            .frame(minWidth: UIScreen.main.bounds.width, minHeight: 200, maxHeight: 400,alignment: .top)
            .padding(.bottom, 50)
        }
    }
}

struct HomeChartView_Previews: PreviewProvider {
    static var previews: some View {
        HomeChartView()
            .environmentObject(HomeViewModel())
    }
}
