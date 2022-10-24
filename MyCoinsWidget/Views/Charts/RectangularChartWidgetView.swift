//
//  RectangularChartWidgetView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 13/10/22.
//

import SwiftUI
import SwiftUICharts
import Combine

struct RectangularChartWidgetView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                LineChartDemoView()
                    .padding(10)
//                    .opacity(0.5)
            }.frame(
                maxWidth: geometry.size.width,
                maxHeight: geometry.size.height,
                alignment: .center
            )
        }
    }
}

struct RectangularChartWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        RectangularChartWidgetView()
    }
}

struct LineChartDemoView: View {
    
    let data: LineChartData = weekOfData()
    
    var body: some View {
        LineChart(chartData: data)
//            .pointMarkers(chartData: data)
//            .touchOverlay(chartData: data,
//                          formatter: numberFormatter)
//            .xAxisGrid(chartData: data)
//            .yAxisGrid(chartData: data)
            .yAxisLabels(chartData: data,
                         formatter: numberFormatter,
                         colourIndicator: .custom(colour: ColourStyle.init(colour: .red), size: 5))
//            .infoBox(chartData: data)
//            .headerBox(chartData: data)
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
    
    static func weekOfData() -> LineChartData {
        let data = LineDataSet(dataPoints: [
            LineChartDataPoint(value: 1, xAxisLabel: "M", description: "Monday"   ),
            LineChartDataPoint(value: 2, xAxisLabel: "T", description: "Tuesday"  ),
            LineChartDataPoint(value: 3 , xAxisLabel: "W", description: "Wednesday"),
            LineChartDataPoint(value: 5, xAxisLabel: "T", description: "Thursday" ),
            LineChartDataPoint(value: 4, xAxisLabel: "F", description: "Friday"   ),
            LineChartDataPoint(value: 2, xAxisLabel: "S", description: "Saturday" ),
            LineChartDataPoint(value: 1 , xAxisLabel: "S", description: "Sunday"   ),
        ],
        legendTitle: "Steps",
        pointStyle: PointStyle(borderColour: .clear),
        style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
        
        let gridStyle = GridStyle(numberOfLines: 7,
                                   lineColour: Color(.lightGray).opacity(0.5),
                                   lineWidth: 0,
                                   dash: [8],
                                   dashPhase: 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement: .infoBox(isStatic: false),
                                        infoBoxContentAlignment: .vertical,
                                        markerType: .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        xAxisGridStyle: gridStyle,
                                        yAxisGridStyle: gridStyle,
                                        yAxisLabelPosition: .trailing,
                                        yAxisLabelColour: Color.red,
                                        yAxisNumberOfLabels: 3,
                                        baseline: .minimumWithMaximum(of: Double(1) ?? 0.0),
                                        topLine: .maximum(of: Double(5) ?? 0.0),
                                        globalAnimation: .easeOut(duration: 1.0))
        
        let chartData = LineChartData(dataSets       : data,
                                      chartStyle     : chartStyle)
    
        return chartData
        
    }
    
}
