//
//  File.swift
//  
//
//  Created by Arthur Gradim Givigir on 13/04/21.
//

import SwiftUI
import Lottie

public struct LottieView: UIViewRepresentable {
    private var name: String
    private var loopMode: LottieLoopMode = .playOnce
    
    private var animationView = AnimationView()
    
    public init(name: String, loopMode: LottieLoopMode) {
        self.name = name
        self.loopMode = loopMode
    }
    
    public func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        animationView.animation = Animation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}
