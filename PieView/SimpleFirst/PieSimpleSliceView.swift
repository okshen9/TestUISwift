//
//  PieSimpleSliceView.swift
//  TestUISwift
//
//  Created by artem on 21.04.2025.
//

import SwiftUI

struct PieSimpleSliceView: View {
    let simpleSliceModel: SimpleSliceModel
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            Path { path in
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: simpleSliceModel.startAngle,
                    endAngle: simpleSliceModel.endAngle,
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(simpleSliceModel.color)
        }
    }
    
    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
        let x = center.x + radius * cos(angle.radians)
        let y = center.y + radius * sin(angle.radians)
        return CGPoint(x: x, y: y)
    }

    struct SimpleSliceModel {
        var color: Color
        var value: Double
        var startAngle: Angle
        var endAngle: Angle
        var cornerRadius: CGFloat
    }

    enum Constants {
        static let zeroDiferent = 90.0
    }
}

#Preview() {
    PieSimpleSliceView(simpleSliceModel: .init(
        color: .red,
        value: 0.25,
        startAngle: .degrees(0),
        endAngle: .degrees(90),
        cornerRadius: 0
    ))
}
