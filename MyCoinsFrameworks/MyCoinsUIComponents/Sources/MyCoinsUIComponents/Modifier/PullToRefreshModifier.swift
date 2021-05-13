//
//  File.swift
//  
//
//  Created by Arthur Givigir on 13/05/21.
//

import SwiftUI

public struct PullToRefreshModifier: ViewModifier {

    public typealias Target = () -> Void
    
    public enum Direction {
        case vertical
        case horizontal
    }
    
    @State private var offset: CGFloat = 0.0
    @State private var draggedOffset: CGSize = .zero
    @State private var startPos : CGPoint = .zero
    @State private var isSwipping = true

    private let direction: Direction
    private let target: Target?
    private var maxDistance: CGFloat = 0
    
    public init(direction: Direction, maxDistance: CGFloat = 0, target: Target?) {
        self.direction = direction
        self.target = target
        self.maxDistance = maxDistance
    }
    
    public init(direction: Direction, target: Target?) {
        self.direction = direction
        self.target = target
    }

    public func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            Text("Carregando...")
                .offset(y: 100)
            
            content
                .offset(
                    CGSize(width: direction == .vertical ? 0 : draggedOffset.width,
                           height: direction == .horizontal ? 0 : draggedOffset.height)
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            
                            /// Identify when user swipe up
                            if self.isSwipping {
                                self.startPos = value.location
                                self.isSwipping.toggle()
                            }

                            if maxDistance > 0, value.translation.height >= maxDistance {
                                return
                            }
                            
                            if value.translation.height > 0 {
                                self.draggedOffset = value.translation
                            }
                        }
                        .onEnded { value in
                            
                            let xDist =  abs(value.location.x - self.startPos.x)
                            let yDist =  abs(value.location.y - self.startPos.y)
                            
                            /// Identify when user swipe up
                            if self.startPos.y > value.location.y && yDist > xDist {
                                return
                            }
                            
                            withAnimation {
                                self.draggedOffset = .zero
                                self.target?()
                            }
                        }
            )
        }
    }

}
