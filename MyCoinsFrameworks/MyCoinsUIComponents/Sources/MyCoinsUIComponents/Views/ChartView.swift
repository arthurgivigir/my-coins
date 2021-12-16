//
//  SwiftUIView.swift
//  
//
//  Created by Arthur Gradim Givigir on 18/04/21.
//

import SwiftUI
import SwiftUICharts

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
