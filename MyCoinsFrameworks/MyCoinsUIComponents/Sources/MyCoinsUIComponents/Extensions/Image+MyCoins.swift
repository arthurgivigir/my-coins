//
//  Image+MyCoins.swift
//  
//
//  Created by Arthur Gradim Givigir on 10/04/21.
//

import SwiftUI

public extension Image {
    
    init(_ name: Images) {
        self.init(name.rawValue, bundle: .module)
    }
    
}

public enum Images: String {
    case charts = "charts"
}
