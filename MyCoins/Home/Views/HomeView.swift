//
//  HomeView.swift
//  MyCoins
//
//  Created by Arthur Gradim Givigir on 10/04/21.
//

import SwiftUI
import MyCoinsCore
import AlertToast
import MyCoinsUIComponents

struct HomeView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var showingAlert: Bool = false
    @State private var showingSheet = false
    
    init() {
        self.setNavigationColor()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    // Widget Space
                    HomeHeaderView()
                    
                    // Chart and animation space
                    VStack {
                        
                        VStack(alignment: .leading) {
                            Text("Última atualização: \(self.homeViewModel.coinModel.formattedUpdatedAt ?? "")")
                                .font(.caption2)
                                .foregroundColor(.black.opacity(0.8))
                            Text("Referência: 1 Dólar americano (comercial)")
                                .font(.caption2)
                                .foregroundColor(.black.opacity(0.8))
                        }
                        .padding(20)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: 60,
                            alignment: .topLeading
                        )
                        
                        HomeChartView()
                            .padding(.vertical, 30)
                            .frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                minHeight: 400,
                                maxHeight: .infinity,
                                alignment: .center)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(
                                color: .black.opacity(0.5),
                                radius: 20,
                                x: 0.5,
                                y: 0.5)

                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .top
                    )
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0.5, y: 0.5)
                }
                .frame(minHeight: geometry.size.height)
            }
    //            .modifier(PullToRefreshModifier(direction: .vertical, target: self.homeViewModel.reload))
            .background(self.background)
            .onAppear() {
                self.homeViewModel.fetch()
            }
            .toast(isPresenting: self.$homeViewModel.showToast){
                AlertToast(
                    displayMode: .hud,
                    type: self.homeViewModel.showToastError ? .error(.red) : .regular,
                    title: self.homeViewModel.messageToast,
                    subTitle: self.homeViewModel.subtitleToast
                )
            }
            .sheet(isPresented: $showingSheet) {
                SheetView()
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}


struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Press to dismiss") {
            presentationMode.wrappedValue.dismiss()
        }
        .font(.title)
        .padding()
        .background(self.background)
    }
}
