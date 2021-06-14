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
    @State private var opacity = 0.0

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

            ProgressView()
                .opacity(opacity)
                .foregroundColor(.white)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: 100,
                   alignment: .center)
            
            content
                .offset(
                    CGSize(width: direction == .vertical ? 0 : draggedOffset.width,
                           height: direction == .horizontal ? 0 : draggedOffset.height)
                )
                .gesture(
                    DragGesture(minimumDistance: 25)
                        .onChanged { value in
                            
                            /// Identify when user swipe up
                            if self.isSwipping {
                                self.startPos = value.location
                                self.isSwipping.toggle()
                            }

                            /// Solution based on asymptotic curve
                            /// https://stackoverflow.com/questions/62268937/swiftui-how-to-change-the-speed-of-drag-based-on-distance-already-dragged
                            if value.translation.height > 0 {
                                let limit: CGFloat = 300 // the less the faster resistance
                                let xOff = value.translation.width
                                let yOff = value.translation.height
                                let dist = sqrt(xOff*xOff + yOff*yOff);
                                let factor = 1 / (dist / limit + 1)
                                self.draggedOffset = CGSize(width: value.translation.width * factor,
                                                    height: value.translation.height * factor)
                                
                                if maxDistance > 0, value.translation.height >= maxDistance {
                                    return
                                }
                                
                                withAnimation {
                                    self.opacity = 1.0
                                }
                            }
                        }
                        .onEnded { value in
                            
                            let xDist =  abs(value.location.x - self.startPos.x)
                            let yDist =  abs(value.location.y - self.startPos.y)
                            
                            /// Identify when user swipe up
                            if self.startPos.y > value.location.y && yDist > xDist {
                                withAnimation {
                                    self.opacity = 0.0
                                }
                                return
                            }
                            
                            if direction == .vertical, value.translation.height > 100  {
                                
                                withAnimation(.spring().delay(0.2)) {
                                    self.draggedOffset = .zero
                                    self.opacity = .zero
                                    self.target?()
                                }
                                
                            } else if direction == .vertical, value.translation.height > 0  {
                                
                                withAnimation(.spring().delay(0.2)) {
                                    self.draggedOffset = .zero
                                    self.opacity = .zero
                                }
                            }
                        }
            )
        }
    }

}
