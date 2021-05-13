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
                VStack {
                    
                    VStack(alignment: .leading) {
                        Text("Última atualização: \(self.homeViewModel.coinModel.formattedDate)")
                            .font(.caption2)
                            .foregroundColor(.black.opacity(0.8))
                        Text("Referência: 1 Dólar americano (turismo)")
                            .font(.caption2)
                            .foregroundColor(.black.opacity(0.8))
                    }
                    .padding(20)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60, alignment: .topLeading)
                    
                    HomeChartView()
                        .padding(30)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.5), radius: 20, x: 0.5, y: 0.5)
                        .modifier(PullToRefreshModifier(direction: .vertical, target: self.homeViewModel.fetch))
                    
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                .background(Color.white.opacity(0.6))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0.5, y: 0.5)
            }
            .modifier(PullToRefreshModifier(direction: .vertical, target: self.homeViewModel.fetch))
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
            .background(self.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Configuração do Widget") {
                            self.showingAlert = true
                        }
                        
                        Button("Sobre") {
                            self.showingSheet = true
                        }
                    }
                    label: {
                        Label("menu", systemImage: "ellipsis")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
            }
            
        }
        .toast(isPresenting: self.$homeViewModel.showToast){
            AlertToast(
                displayMode: .hud,
                type: .error(.red),
                title: self.homeViewModel.messageToast,
                subTitle: self.homeViewModel.subtitleToast
            )
        }
        .sheet(isPresented: $showingSheet) {
            SheetView()
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
