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
    private var customStyle: ChartStyle
    @Binding private var chartData: [Double]
    
    @Binding private var data: [(String, Double)]
    
    @Binding private var lastData: String
    
    
    public init(
        title: String,
        data: Binding<[(String, Double)]>,
        lastData: Binding<String>,
        chartData: Binding<[Double]>) {
        self.title = title
        self._data = data
        self._lastData = lastData
        self._chartData = chartData
        
        customStyle = ChartStyle(
            backgroundColor: .purple,
            accentColor: Color.mcSecondary,
            secondGradientColor: Color.mcSecondary,
            textColor: .white,
            legendTextColor: Color.mcPrimaryDarker,
            dropShadowColor: .white
        )
    }
    
    public var body: some View {

        ChartTestView(chartData: self.$chartData)
            .frame(width: UIScreen.main.bounds.width, height: 220, alignment: .center)
        
//        LineView(data: self.chartData, title: self.title, price: "4.50")
//        LineChartView(
//            data: self.chartData,
//            title: self.title,
//            legend: "",
//            style: customStyle,
//            form: CGSize(width: UIScreen.main.bounds.size.width - 50, height: 240),
//            dropShadow: false
//        ).preferredColorScheme(.light)
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(title: "Teste", data: .constant([("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), lastData: .constant("Teste"), chartData: .constant([Double]()))
    }
}

struct LineView: View {
    var data: [(Double)]
    var title: String?
    var price: String?

    public init(data: [Double],
                title: String? = nil,
                price: String? = nil) {
        
        self.data = data
        self.title = title
        self.price = price
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                Group{
                    if (self.title != nil){
                        Text(self.title!)
                            .font(.title)
                    }
                    if (self.price != nil){
                        Text(self.price!)
                            .font(.body)
                        .offset(x: 5, y: 0)
                    }
                }.offset(x: 0, y: 0)
                ZStack{
                    GeometryReader{ reader in
                        Line(data: self.data,
                             frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height))
                        )
                            .offset(x: 0, y: 0)
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 200)
                    .offset(x: 0, y: -100)

                }
                .frame(width: geometry.frame(in: .local).size.width, height: 200)
        
            }
        }
    }
}

struct Line: View {
    var data: [(Double)]
    @Binding var frame: CGRect

    let padding:CGFloat = 30
    
    var stepWidth: CGFloat {
        if data.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.count-1)
    }
    var stepHeight: CGFloat {
        var min: Double?
        var max: Double?
        let points = self.data
        if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        }else {
            return 0
        }
        if let min = min, let max = max, min != max {
            if (min <= 0){
                return (frame.size.height-padding) / CGFloat(max - min)
            } else {
                return (frame.size.height-padding) / CGFloat(max + min)
            }
        }
        
        return 0
    }
    
    var path: Path {
        let points = self.data
        return Path.lineChart(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    public var body: some View {
        
        ZStack {

            self.path
                .stroke(Color.green ,style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .drawingGroup()
        }
    }
}


extension Path {
    
    static func lineChart(points:[Double], step:CGPoint) -> Path {
        var path = Path()
        if (points.count < 2){
            return path
        }
        guard let offset = points.min() else { return path }
        let p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset)*step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y*CGFloat(points[pointIndex]-offset))
            path.addLine(to: p2)
        }
        return path
    }
}

struct ChartTestView: UIViewRepresentable {
    @Binding var chartData: [Double]
    
    func makeUIView(context: Context) -> AAChartView {
        AAChartView()
    }

    func updateUIView(_ uiView: AAChartView, context: Context) {
        let aaChartModel = AAChartModel()
                    .chartType(.line)//Can be any of the chart types listed under `AAChartType`.
                    .animationType(.bounce)
                    .title("TITLE")//The chart title
                    .subtitle("subtitle")//The chart subtitle
                    .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
                    .tooltipValueSuffix("USD")//the value suffix of the chart tooltip
//                    .categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun",
//                                 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
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
