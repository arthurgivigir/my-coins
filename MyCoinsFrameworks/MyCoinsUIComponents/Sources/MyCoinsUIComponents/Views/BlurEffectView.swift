//
//  BlurEffectView.swift
//  
//
//  Created by Arthur Gradim Givigir on 01/05/21.
//

import Foundation
import SwiftUI

public struct BlurEffectView: UIViewRepresentable {
    
    private let effect: UIBlurEffect.Style
    
    public init(effect: UIBlurEffect.Style) {
        self.effect = effect
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: self.effect)
        return UIVisualEffectView(effect: blurEffect)
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
