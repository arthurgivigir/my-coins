//
//  MyCoinsUserDefaults.swift
//  
//
//  Created by Arthur Givigir on 17/12/21.
//

import SwiftUI
import MyCoinsCore

public class MyCoinsUserDefaults {

    public static var shared = MyCoinsUserDefaults()
    
    private var userDefaults = UserDefaults(suiteName: MyCoinsUserDefaultsValues.suiteName.rawValue)
    
    public func setColor(_ newColor: Color, key: MyCoinsUserDefaultsValues.Colors, completion: (() -> Void?)? = nil) {
        if let userDefaults = userDefaults {
            userDefaults.setColor(color: UIColor(newColor), forKey: key.rawValue)
            completion?()
        }
    }
    
    public func getColors(completion: ((_ topColor: Color, _ bottomColor: Color) -> ())) {
        if let userDefaults = userDefaults {
            
            let topColor = Color(userDefaults.colorForKey(key: MyCoinsUserDefaultsValues.Colors.topColor.rawValue) ?? UIColor(.mcPrimaryDarker))
            let bottomColor = Color(userDefaults.colorForKey(key: MyCoinsUserDefaultsValues.Colors.bottomColor.rawValue) ?? UIColor(.mcPrimary))
            
            completion(topColor, bottomColor)
        }
        
    }
    
}
