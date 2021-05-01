//
//  HomeView.swift
//  MyCoins
//
//  Created by Arthur Gradim Givigir on 10/04/21.
//

import SwiftUI
import MyCoinsCore

struct HomeView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    init() {
        self.setNavigationColor()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Widget Space
                HomeHeaderView()
                    .padding(20)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: 220,
                       alignment: .center)
                
                // Chart and animation space
                HomeChartView()
                    .padding(30)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0.5, y: 0.5)
            }
            .onAppear() {
                self.homeViewModel.fetch()
            }
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .top
            )
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Câmbio Sincero", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Image(systemName: "ellipsis")
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(.white)
            )
            .background(
                LinearGradient(
                gradient:
                    Gradient(
                        colors: [.mcPrimaryDarker, .mcPrimary]),
                        startPoint: .top, endPoint: .bottom
                    )
                .edgesIgnoringSafeArea(.vertical)
            )
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
