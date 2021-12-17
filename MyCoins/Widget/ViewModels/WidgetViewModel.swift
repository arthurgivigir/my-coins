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

final class WidgetViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var topColor: Color = .mcPrimaryDarker
    @Published var bottomColor: Color = .mcPrimary
    
    init() {
        
        if let userDefaults = UserDefaults(suiteName: "group.com.givigir.MyCoins") {
            self.topColor = Color(userDefaults.colorForKey(key: "topColor") ?? UIColor(.mcPrimaryDarker))
            self.bottomColor = Color(userDefaults.colorForKey(key: "bottomColor") ?? UIColor(.mcPrimary))
        }
        
        $topColor
            .sink { newColor in
                if let userDefaults = UserDefaults(suiteName: "group.com.givigir.MyCoins") {
                    userDefaults.setColor(color: UIColor(newColor), forKey: "topColor")
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .store(in: &cancellables)
        
        $bottomColor
            .sink { newColor in
                if let userDefaults = UserDefaults(suiteName: "group.com.givigir.MyCoins") {
                    userDefaults.setColor(color: UIColor(newColor), forKey: "bottomColor")
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .store(in: &cancellables)
    }
}

extension UserDefaults {
  func colorForKey(key: String) -> UIColor? {
    var colorReturnded: UIColor?
    if let colorData = data(forKey: key) {
      do {
        if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
          colorReturnded = color
        }
      } catch {
        print("Error UserDefaults")
      }
    }
    return colorReturnded
  }
  
  func setColor(color: UIColor?, forKey key: String) {
    var colorData: NSData?
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
        colorData = data
      } catch {
        print("Error UserDefaults")
      }
    }
    set(colorData, forKey: key)
  }
}
