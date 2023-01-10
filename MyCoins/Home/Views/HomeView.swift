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
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        // Widget Space
                        HomeHeaderView()
                            .redacted(reason: self.homeViewModel.loadingState == .loading ? .placeholder : [])
                        
                        // Chart and animation space
                        VStack {
                            HomeChartView()
                                .padding(.vertical, 30)
                                .frame(
                                    minWidth: 0,
                                    maxWidth: .infinity,
                                    minHeight: 400,
                                    maxHeight: .infinity,
                                    alignment: .center)
                                .background(Color.black)
                                .cornerRadius(20)
                                .shadow(
                                    color: .mcPrimaryDarker.opacity(0.5),
                                    radius: 20,
                                    x: 0.5,
                                    y: 0.5)
                                .redacted(reason: self.homeViewModel.loadingState == .loading ? .placeholder : [])
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
                        .shadow(color: .mcPrimaryDarker.opacity(0.5), radius: 20, x: 0.5, y: 0.5)
                    }
                    .frame(minHeight: geometry.size.height - 20)
                }
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
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.homeViewModel.reload()
                    }, label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                        }
                    })
                    .foregroundColor(.white)
                }
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
