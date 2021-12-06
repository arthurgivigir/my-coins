//
//  SwiftUIView.swift
//  
//
//  Created by Arthur Gradim Givigir on 18/04/21.
//

import SwiftUI
import SwiftUICharts
import Charts
import StockCharts

public struct ChartView: View {
    
    @Binding private var data: LineChartData
    
    public init(lineChartData: Binding<LineChartData>) {
        self._data = lineChartData
    }
    
    public var body: some View {
        
        LineChart(chartData: data)
            .pointMarkers(chartData: data)
            .touchOverlay(chartData: data,
                          formatter: numberFormatter)
            .xAxisGrid(chartData: data)
            .yAxisGrid(chartData: data)
            .yAxisLabels(chartData: data,
                         formatter: numberFormatter,
                         colourIndicator: .style(size: 12))
            .infoBox(chartData: data)
            .headerBox(chartData: data)
            .id(data.id)
            .frame(
                minWidth: 150,
                maxWidth: 900,
                minHeight: 150,
                idealHeight: 500,
                maxHeight: 600,
                alignment: .center
            )
            .padding(.horizontal)
        
    }

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(
            lineChartData: .constant(LineChartData(dataSets: LineDataSet(dataPoints: [LineChartDataPoint(value: 1.0), LineChartDataPoint(value: 2.0), LineChartDataPoint(value: 0.5)])))
        )
    }
}

//private struct ChartViewReprentable: UIViewRepresentable {
//
//    private var title: String
//    private var subtitle: String
//
//    @Binding private var chartData: [Double]
//    @Binding private var chartCategories: [String]
//
//    internal init(
//        title: String,
//        subtitle: String,
//        chartData: Binding<[Double]>,
//        chartCategories: Binding<[String]>
//    ) {
//        self.title = title
//        self.subtitle = subtitle
//        self._chartData = chartData
//        self._chartCategories = chartCategories
//    }
//
//    func makeUIView(context: Context) -> AAChartView {
//        AAChartView()
//    }
//
//    func updateUIView(_ uiView: AAChartView, context: Context) {
//        let aaChartModel = AAChartModel()
//            .chartType(.line)//Can be any of the chart types listed under `AAChartType`.
//            .animationType(.bounce)
//            .title(self.title)//The chart title
////            .subtitle(self.subtitle)//The chart subtitle
//            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
//            .tooltipValueSuffix("USD")//the value suffix of the chart tooltip
//            .categories(self.chartCategories)
//            .colorsTheme(["#9019EB"])
//            .dataLabelsStyle(AAStyle(color: "#310F42", fontSize: 17.0, weight: .bold))
//            .series([
//                AASeriesElement()
//                    .name("")
//                    .data(self.chartData),
//                ])
//
//        uiView.aa_drawChartWithChartModel(aaChartModel)
//        uiView.scrollView.bounces = false
//    }
//}
