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
    @Published var chartValues = [CoinModel]()
    @Published var chartCategories = [String]()
    @Published var showToast: Bool = false
    @Published var messageToast: String = ""
    @Published var subtitleToast: String = ""
    @Published var showToastError: Bool = true
    @Published var lineChartData: LineChartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
    @Published var loadingState: LoadingState = .loading
    
    private var timer: AnyCancellable?
    private var lastUpdate: Date = Date()
    private var minValue = "0.0"
    private var maxValue = "0.0"
    private var chartMetaData = ChartMetadata(
        title: "Variação cambial",
        subtitle: "Referência: 1 Dólar americano (comercial)",
        titleFont: .headline,
        titleColour: .black,
        subtitleFont: .subheadline,
        subtitleColour: .gray
    )
    
    public func fetch() {
        self.timer?.cancel()
        self.loadingState = .loading
        self.refreshValues()
        self.getCoinValues()
        
        timer = Timer.publish(every: 30, on: .main, in: .default)
                    .autoconnect()
                    .sink { time in
                        self.getCoinValues()
                    }
    }
    
    public func reload() {
        self.loadingState = .loading
        self.refreshValues()
        self.getCoinValues()
        self.lastUpdate = Date()
    }
    
    private func getCoinValues() {
        
        CoinFetcher
            .shared
            .getCoinValues(from: "USD", to: "BRL") { [weak self] coinModel, chartValues, error in
                if let error = error as? APIErrorEnum {
                    self?.errorCheck(error)
                    return
                }
                
                if let coinModel = coinModel {
                    self?.coinModel = coinModel
                }
                
                if let chartValues = chartValues {
                    self?.chartValues = chartValues
                    self?.setChartData()
                        
                    self?.maxValue = chartValues.max { $0.close > $1.close }?.close ?? "0.0"
                    self?.minValue = chartValues.min { $0.close > $1.close }?.close ?? "0.0"
                }
                
                self?.loadingState = .loaded
            }
    }
    
    
    public func setChartData() {
        
        var color: Color = Color.mcQuaternary
        if self.coinModel.rateEnum == .down {
            color = .mcTertiary
        } else if self.coinModel.rateEnum == .up {
            color = .mcSecondary
        }
        
        let dataPoints = self.chartValues.enumerated().map { offset, coinModel -> LineChartDataPoint in
            
            let value = Double(coinModel.close) ?? 0.0
            
            return LineChartDataPoint(
                value: value,
                xAxisLabel: "R$ \(value)",
                description: coinModel.updatedAt?.formattedDate() ?? "",
                pointColour: PointColour(border: color, fill: color)
            )
        }
        
        let data = LineDataSet(dataPoints: dataPoints,
        style: LineStyle(lineColour: ColourStyle(colour: color), lineType: .line))
        
        let gridStyle = GridStyle(numberOfLines: 7,
                                   lineColour: Color(.lightGray).opacity(0.5),
                                   lineWidth: 1,
                                   dash: [8],
                                   dashPhase: 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement: .infoBox(isStatic: false),
                                        infoBoxContentAlignment: .vertical,
                                        infoBoxBorderColour: Color.black,
                                        infoBoxBorderStyle: StrokeStyle(lineWidth: 1),
                                        markerType: .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        yAxisGridStyle: gridStyle,
                                        yAxisLabelPosition: .leading,
                                        yAxisLabelColour: Color.gray,
                                        yAxisNumberOfLabels: 7,
                                        baseline: .minimumWithMaximum(of: Double(maxValue) ?? 0.0),
                                        topLine: .maximum(of: Double(minValue) ?? 0.0),
                                        globalAnimation: .easeOut(duration: 1.0))
        
        self.lineChartData = LineChartData(dataSets: data,
                                           metadata: chartMetaData,
                                           chartStyle: chartStyle)
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
        
        self.loadingState = .error
        
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
