//
//  RateView.swift
//
//
//  Created by Arthur Gradim Givigir on 05/04/21.
//

import SwiftUI
import MyCoinsCore
import MyCoinsUIComponents

public struct RateView: View {
    
    private let rate: RateEnum
    
    public init(rate: RateEnum) {
        self.rate = rate
    }
    
    public var body: some View {
        if rate == .stable  {
            SquareShape()
                .stroke(self.color,
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                )
                .background(
                    SquareShape()
                        .foregroundColor(self.color)
                )
        } else {
            TriangleShape()
                .rotation(self.rotation)
                .stroke(self.color,
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                )
                .background(
                    TriangleShape()
                        .rotation(self.rotation)
                        .foregroundColor(self.color)
                )
        }
    }
    
    private var color: Color {
        get {
            switch rate {
            case .up:
                return .green
            
            case .down:
                return .red
            
            default:
                return .yellow
            }
        }
    }
    
    private var rotation: Angle {
        get {
            switch rate {
            case .up:
                return .degrees(0.0)
            
            case .down:
                return .degrees(180.0)
            
            default:
                return .degrees(0.0)
            }
        }
    }
    
    private struct TriangleShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()

            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

            return path
        }
    }
    
    private struct SquareShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()

            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

            return path
        }
    }
}


struct RateView_Previews: PreviewProvider {
    static var previews: some View {
//        TextWidgetView(coin: CoinModel(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
        RateView(rate: RateEnum.stable)
            .padding(20)
    }
}
