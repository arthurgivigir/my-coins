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
                lineChartData: self.$homeViewModel.lineChartData
            )
            .padding(.bottom, 16)
            
            Text("Última atualização: \(self.homeViewModel.coinModel.formattedUpdatedAt ?? "")")
                .foregroundColor(.gray)
                .font(.footnote)
                .padding(.horizontal)
                .frame(
                    width: UIScreen.main.bounds.width,
                    alignment: .leading
                )
        }
        .padding(.bottom, 50)
        .frame(minHeight: 200, maxHeight: 400,alignment: .top)
    }
}

struct HomeChartView_Previews: PreviewProvider {
    static var previews: some View {
        HomeChartView()
            .environmentObject(HomeViewModel())
    }
}
