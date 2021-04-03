//
//  File.swift
//  
//
//  Created by Arthur Gradim Givigir on 03/04/21.
//

import SwiftUI

public extension Color {
    
    static var mcPrimary: Color {
        return Color("Primary", bundle: Bundle.module)
    }
    
    static var mcSecondary: Color {
        return Color("Secondary", bundle: Bundle.module)
    }
    
    static var mcTertiary: Color {
        return Color("Tertiary", bundle: Bundle.module)
    }
    
    static var mcMainBackground: Color {
        return Color("MainBackground", bundle: Bundle.module)
    }
    
}
