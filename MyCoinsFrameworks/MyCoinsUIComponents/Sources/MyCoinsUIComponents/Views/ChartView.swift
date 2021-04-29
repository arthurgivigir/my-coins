//
//  SwiftUIView.swift
//  
//
//  Created by Arthur Gradim Givigir on 18/04/21.
//

import SwiftUI
import SwiftUICharts
import AAInfographics

public struct ChartView: View {
    
    private var title: String
    private var subtitle: String
    
    @Binding private var chartData: [Double]
    @Binding private var chartCategories: [String]
    
    public init(
        title: String,
        subtitle: String,
        chartData: Binding<[Double]>,
        chartCategories: Binding<[String]>) {
        self.title = title
        self.subtitle = subtitle
        self._chartData = chartData
        self._chartCategories = chartCategories
    }
    
    public var body: some View {
        ChartViewReprentable(
            title: self.title,
            subtitle: self.subtitle,
            chartData: self.$chartData,
            chartCategories: self.$chartCategories
        )
        .frame(width: UIScreen.main.bounds.width, height: 220, alignment: .center)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(
            title: "Teste",
            subtitle: "Testando",
            chartData: .constant([1,2,3,4,5,3,2,4]),
            chartCategories: .constant(["1", "2", "3", "4", "5", "3", "2", "4"])
        )
    }
}

private struct ChartViewReprentable: UIViewRepresentable {

    private var title: String
    private var subtitle: String

    @Binding private var chartData: [Double]
    @Binding private var chartCategories: [String]
    
    internal init(
        title: String,
        subtitle: String,
        chartData: Binding<[Double]>,
        chartCategories: Binding<[String]>
    ) {
        self.title = title
        self.subtitle = subtitle
        self._chartData = chartData
        self._chartCategories = chartCategories
    }
    
    func makeUIView(context: Context) -> AAChartView {
        AAChartView()
    }

    func updateUIView(_ uiView: AAChartView, context: Context) {
        let aaChartModel = AAChartModel()
            .chartType(.line)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title(self.title)//The chart title
            .subtitle(self.subtitle)//The chart subtitle
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("USD")//the value suffix of the chart tooltip
            .categories(self.chartCategories)
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .series([
                AASeriesElement()
                    .name("")
                    .data(self.chartData),
                ])
        
        uiView.aa_drawChartWithChartModel(aaChartModel)
        uiView.scrollView.bounces = false
    }
}
