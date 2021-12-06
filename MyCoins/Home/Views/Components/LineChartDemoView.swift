//
//  LineChartDemoView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 03/12/21.
//

import SwiftUI
import SwiftUICharts
import Combine

struct LineChartDemoView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    let data: LineChartData = weekOfData()
    
    var body: some View {
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
            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
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
            LineChartDataPoint(value: 5.68, xAxisLabel: "M", description: "Monday"   ),
            LineChartDataPoint(value: 5.69, xAxisLabel: "T", description: "Tuesday"  ),
            LineChartDataPoint(value: 5.70 , xAxisLabel: "W", description: "Wednesday"),
            LineChartDataPoint(value: 5.68, xAxisLabel: "T", description: "Thursday" ),
            LineChartDataPoint(value: 5.30, xAxisLabel: "F", description: "Friday"   ),
            LineChartDataPoint(value: 5.45, xAxisLabel: "S", description: "Saturday" ),
            LineChartDataPoint(value: 5.75 , xAxisLabel: "S", description: "Sunday"   ),
            LineChartDataPoint(value: 5.68, xAxisLabel: "M", description: "Monday"   ),
            LineChartDataPoint(value: 5.69, xAxisLabel: "T", description: "Tuesday"  ),
            LineChartDataPoint(value: 5.70 , xAxisLabel: "W", description: "Wednesday"),
            LineChartDataPoint(value: 5.68, xAxisLabel: "T", description: "Thursday" ),
            LineChartDataPoint(value: 5.30, xAxisLabel: "F", description: "Friday"   ),
            LineChartDataPoint(value: 5.45, xAxisLabel: "S", description: "Saturday" ),
            LineChartDataPoint(value: 5.75 , xAxisLabel: "S", description: "Sunday"   ),
            LineChartDataPoint(value: 5.68, xAxisLabel: "M", description: "Monday"   ),
            LineChartDataPoint(value: 5.69, xAxisLabel: "T", description: "Tuesday"  ),
            LineChartDataPoint(value: 5.70 , xAxisLabel: "W", description: "Wednesday"),
            LineChartDataPoint(value: 5.68, xAxisLabel: "T", description: "Thursday" ),
            LineChartDataPoint(value: 5.30, xAxisLabel: "F", description: "Friday"   ),
            LineChartDataPoint(value: 5.45, xAxisLabel: "S", description: "Saturday" ),
            LineChartDataPoint(value: 5.75 , xAxisLabel: "S", description: "Sunday"   ),
            LineChartDataPoint(value: 5.68, xAxisLabel: "M", description: "Monday"   ),
            LineChartDataPoint(value: 5.69, xAxisLabel: "T", description: "Tuesday"  ),
            LineChartDataPoint(value: 5.70 , xAxisLabel: "W", description: "Wednesday"),
            LineChartDataPoint(value: 5.68, xAxisLabel: "T", description: "Thursday" ),
            LineChartDataPoint(value: 5.30, xAxisLabel: "F", description: "Friday"   ),
            LineChartDataPoint(value: 5.45, xAxisLabel: "S", description: "Saturday" ),
            LineChartDataPoint(value: 5.75 , xAxisLabel: "S", description: "Sunday"   ),
        ],
        legendTitle: "Steps",
        pointStyle: PointStyle(),
        style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .line))
        
        let gridStyle = GridStyle(numberOfLines: 7,
                                   lineColour   : Color(.lightGray).opacity(0.5),
                                   lineWidth    : 1,
                                   dash         : [8],
                                   dashPhase    : 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false),
                                        infoBoxContentAlignment: .vertical,
                                        infoBoxBorderColour : Color.black,
                                        infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                        
                                        markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        
                                        yAxisGridStyle      : gridStyle,
                                        yAxisLabelPosition  : .leading,
                                        yAxisLabelColour    : Color.gray,
                                        yAxisNumberOfLabels : 7,
                                        
                                        baseline            : .minimumWithMaximum(of: 4.50),
                                        topLine             : .maximum(of: 6.50),
                                        
                                        globalAnimation     : .easeOut(duration: 1))
        
        
        
        let chartData = LineChartData(dataSets       : data,
                                      metadata       : ChartMetadata(title: "Variação cambial", subtitle: "Referência: 1 Dólar americano (comercial)", titleFont: .headline, titleColour: .black, subtitleFont: .subheadline, subtitleColour: .gray),
                                      chartStyle     : chartStyle)
        
        return chartData
        
    }
    
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartDemoView()
    }
}
//
//extension Color {
//    public static var myBackground: Color {
//        #if os(iOS)
//        return Color(.systemBackground)
//        #elseif os(tvOS)
//        return Color(.darkGray)
//        #elseif os(macOS)
//        return Color(.windowBackgroundColor)
//        #endif
//    }
//}
