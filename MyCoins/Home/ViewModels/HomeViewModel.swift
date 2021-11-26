//
//  HomeViewModel.swift
//  MyCoins
//
//  Created by Arthur Gradim Givigir on 18/04/21.
//

import Foundation
import Combine
import MyCoinsCore
import MyCoinsServices
import SwiftUICharts
import SwiftUI

final class HomeViewModel: ObservableObject {
    
    @Published private (set) var coinModel = CoinModel(date: Date())
    @Published var chartValues = [Double]()
    @Published var chartCategories = [String]()
    @Published var showToast: Bool = false
    @Published var messageToast: String = ""
    @Published var subtitleToast: String = ""
    @Published var showToastError: Bool = true
    @Published var lineChartData: LineChartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
    
    private var lastUpdate: Date = Date()
    private var cancellables: Set<AnyCancellable> = []
    
    public func fetch() {
        
        self.refreshValues()
        self.getCoinValues()
        
        Timer.publish(every: 600, on: .main, in: .default)
            .autoconnect()
            .sink { time in
                self.getCoinValues()
            }
            .store(in: &cancellables)
    }
    
    public func reload() {
        self.refreshValues()
        self.getCoinValues()
        self.lastUpdate = Date()
    }
    
    private func getCoinValues() {
        
        CoinFetcher
            .shared
            .getCoinValues(from: "USD", to: "BRL") { [weak self] coinModel, chartCategories, chartValues, error in
                if let error = error as? APIErrorEnum {
                    self?.errorCheck(error)
                    return
                }
                
                if let coinModel = coinModel {
                    self?.coinModel = coinModel
                }
                
                if let chartCategories = chartCategories,
                   let chartValues = chartValues {
                    self?.chartCategories = chartCategories
                    self?.chartValues = chartValues
                    self?.setChartData()
                }
            }
    }
    
    
    public func setChartData() {
        
        
        let gridStyle = GridStyle(numberOfLines: 7,
                                           lineColour   : Color(.lightGray).opacity(0.5),
                                           lineWidth    : 1,
                                           dash         : [8],
                                           dashPhase    : 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false),
                                                infoBoxContentAlignment: .vertical,
                                                infoBoxBorderColour : Color.primary,
                                                infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                                
                                                markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                                
                                                xAxisGridStyle      : gridStyle,
                                                xAxisLabelPosition  : .bottom,
                                                xAxisLabelColour    : Color.primary,
                                                xAxisLabelsFrom     : .dataPoint(rotation: .degrees(0)),
                                                xAxisTitle          : "xAxisTitle",
                                                
                                                yAxisGridStyle      : gridStyle,
                                                yAxisLabelPosition  : .leading,
                                                yAxisLabelColour    : Color.primary,
                                                yAxisNumberOfLabels : 10,
                                                globalAnimation     : .easeOut(duration: 1))
        
        
        let dataPoints = self.chartValues.enumerated().map { offset, value -> LineChartDataPoint in
            LineChartDataPoint(value: value, xAxisLabel: self.chartCategories[offset], description: "\(value)", pointColour: PointColour(border: .purple, fill: .red))
        }
        
        let data = LineDataSet(dataPoints: dataPoints,
                legendTitle: "Steps",
                pointStyle: PointStyle(),
                style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine))
        
        lineChartData = LineChartData(dataSets       : data,
                                      chartStyle     : chartStyle)
    }
    
    public func showWidgetConfig() {
        self.showToast = true
        self.showToastError = false
        self.messageToast = "Aguarde mais um pouco!"
        self.subtitleToast = "Em breve teremos novidades por aqui!"
    }
    
    private func refreshValues() {
        self.chartValues = []
        self.chartCategories = []
    }
    
    private func errorCheck(_ error: APIErrorEnum?) {
        switch error {
        case .network:
            print("😭 Ocorreu um erro: \(String(describing: error?.localizedDescription))")
            self.showToast = true
            self.showToastError = true
            self.messageToast = "Ocorreu um erro!"
            self.subtitleToast = "Verifique sua conexão e tente novamente!"
            return
            
        default:
            print("😭 Ocorreu um erro: \(String(describing: error?.localizedDescription))")
            self.showToast = true
            self.showToastError = true
            self.messageToast = "Ocorreu um erro!"
            self.subtitleToast = "Tente novamente!"
            return
        }
    }
    
    
}
