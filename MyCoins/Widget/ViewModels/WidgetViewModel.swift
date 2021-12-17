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
        
        if let userDefaults = UserDefaults(suiteName: UserDefaultsEnum.suiteName.rawValue) {
            self.topColor = Color(userDefaults.colorForKey(key: UserDefaultsEnum.topColor.rawValue) ?? UIColor(.mcPrimaryDarker))
            self.bottomColor = Color(userDefaults.colorForKey(key: UserDefaultsEnum.bottomColor.rawValue) ?? UIColor(.mcPrimary))
        }
        
        $topColor
            .sink { newColor in
                if let userDefaults = UserDefaults(suiteName: UserDefaultsEnum.suiteName.rawValue) {
                    userDefaults.setColor(color: UIColor(newColor), forKey: UserDefaultsEnum.topColor.rawValue)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .store(in: &cancellables)
        
        $bottomColor
            .sink { newColor in
                if let userDefaults = UserDefaults(suiteName: UserDefaultsEnum.suiteName.rawValue) {
                    userDefaults.setColor(color: UIColor(newColor), forKey: UserDefaultsEnum.bottomColor.rawValue)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .store(in: &cancellables)
    }
}
