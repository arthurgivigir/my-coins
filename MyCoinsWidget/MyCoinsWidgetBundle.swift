//
//  MyCoinsWidget.swift
//  MyCoinsWidget
//
//  Created by Arthur Givigir on 2/20/21.
//

import WidgetKit
import SwiftUI
import Intents
import Combine
import MyCoinsCore
import MyCoinsServices
import MyCoinsWidgetUIComponents
import MyCoinsUIComponents

@main
struct MyCoinsWidgetBundle: WidgetBundle {

    var body: some Widget {
        SimpleWidget()
        GaugeWidget()
    }
}

