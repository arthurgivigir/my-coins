//
//  SwiftUIView.swift
//  
//
//  Created by Arthur Gradim Givigir on 18/04/21.
//

import SwiftUI
import SwiftUICharts

public struct ChartView: View {
    
    private var title: String
    private var customStyle: ChartStyle
    
    @Binding private var data: [(String, Double)]
    @Binding private var lastData: String
    
    
    public init(
        title: String,
        data: Binding<[(String, Double)]>,
        lastData: Binding<String>) {
        self.title = title
        self._data = data
        self._lastData = lastData
        
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

        BarChartView(
            data: ChartData(values: self.data),
            title: self.title,
            legend: self.lastData,
            style: customStyle,
            form: CGSize(width: UIScreen.main.bounds.size.width - 50, height: 200),
            dropShadow: false,
            animatedToBack: false
        ).preferredColorScheme(.light)
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(title: "Teste", data: .constant([("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), lastData: .constant("Teste"))
    }
}
