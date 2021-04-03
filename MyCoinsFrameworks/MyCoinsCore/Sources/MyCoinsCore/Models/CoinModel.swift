//
//  CoinModel.swift
//  MyCoinsCore
//
//  Created by Arthur Givigir on 2/20/21.
//
import Foundation
import WidgetKit
import SwiftUI
import Intents

public struct CoinModel: TimelineEntry, Codable {
    public var date: Date = Date()
    public var code: String?
    public var codein: String?
    public var name, high, low, varBid: String?
    public var pctChange, bid, ask, timestamp: String?
    public var createDate: String?
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }
    
    public var formattedBit: String {
        let defaultValue = "R$ 0,00"
        
        if let bid = self.bid, let value = Double(bid) {
            return formatter.string(from: NSNumber(value: value)) ?? defaultValue
        }
        
        return defaultValue
    }

    public init(date: Date) {
        self.date = date
    }

    enum CodingKeys: String, CodingKey {
        case code, codein, name, high, low, varBid, pctChange, bid, ask, timestamp
        case createDate = "create_date"
    }
}
