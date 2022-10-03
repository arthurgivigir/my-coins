//
//  File.swift
//  
//
//  Created by Arthur Givigir on 16/12/21.
//

import Foundation
import WidgetKit
import SwiftUI
import SwiftUICharts

public struct WidgetModel: TimelineEntry {
    
    public var date: Date = Date()
    public var coin: CoinModel
    public var lineChartData: LineChartData?
    public var topColor: Color?
    public var bottomColor: Color?
    
    public init(
        date: Date = Date(),
        coin: CoinModel,
        lineChartData: LineChartData? = nil
    ) {
        self.date = date
        self.coin = coin
        self.lineChartData = lineChartData
    }

}
