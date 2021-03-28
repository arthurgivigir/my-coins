//
//  SwiftUIView.swift
//  
//
//  Created by Arthur Givigir on 3/28/21.
//

import SwiftUI
import WidgetKit

public struct MainWidgetView: View {
    
    public init() {
        
    }
    
    public var body: some View {
        Text("Hello, World!")
    }
}

struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MainWidgetView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 mini"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
