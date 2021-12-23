//
//  WidgetViewModel.swift
//  MyCoins
//
//  Created by Arthur Givigir on 13/12/21.
//

import SwiftUI
import MyCoinsUIComponents
import Combine
import WidgetKit
import MyCoinsCore

final class WidgetViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var topColor: Color = .mcPrimaryDarker
    @Published var bottomColor: Color = .mcPrimary
    
    init() {
        
        MyCoinsUserDefaults.shared.getColors { topColor, bottomColor in
            self.topColor = topColor
            self.bottomColor = bottomColor
        }
        
        $topColor
            .sink { newColor in
                MyCoinsUserDefaults.shared.setColor(newColor, key: .topColor) {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .store(in: &cancellables)
        
        $bottomColor
            .sink { newColor in
                MyCoinsUserDefaults.shared.setColor(newColor, key: .bottomColor) {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .store(in: &cancellables)
    }
}
