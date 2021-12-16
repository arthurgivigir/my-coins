//
//  WidgetViewModel.swift
//  MyCoins
//
//  Created by Arthur Givigir on 13/12/21.
//

import SwiftUI
import MyCoinsUIComponents

final class WidgetViewModel: ObservableObject {
    
    @Published var topColor: Color = .mcPrimaryDarker
    @Published var bottomColor: Color = .mcPrimary
}
