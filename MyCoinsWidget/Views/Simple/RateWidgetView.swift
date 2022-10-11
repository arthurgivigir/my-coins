//
//  RateWidgetView.swift
//  MyCoins
//
//  Created by Arthur Givigir on 10/10/22.
//

import SwiftUI
import MyCoinsCore

struct RateWidgetView: View {
    
    private let rate: Rate
    
    public init(rate: Rate) {
        self.rate = rate
    }
    
    var body: some View {
        
        switch rate {
        case .up:
            Image(systemName: "arrow.up.circle.fill")
        case .down:
            Image(systemName: "arrow.down.circle.fill")
        default:
            Image(systemName: "square.fill")
        }
    }
}

struct RateWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        RateWidgetView(rate: .stable)
    }
}
