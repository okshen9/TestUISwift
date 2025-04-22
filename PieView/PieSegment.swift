//
//  PieSegment.swift
//  TestUISwift
//
//  Created by artem on 22.04.2025.
//

import SwiftUI

struct PieSegment: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()
        path.addArc(center: center, 
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        return path
    }
}

struct RoundedPieChart: View {
    let segments: [(value: Double, color: Color)]
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    
    private var total: Double {
        segments.reduce(0) { $0 + $1.value }
    }
    
    private func angle(for index: Int) -> Angle {
        .degrees(segments[0..<index].reduce(0) { $0 + $1.value / total * 360 })
    }
    
    var body: some View {
        ZStack {
            ForEach(segments.indices, id: \.self) { index in
                PieSegment(
                    startAngle: angle(for: index),
                    endAngle: angle(for: index + 1),
                    radius: (innerRadius + outerRadius) / 2
                )
                .stroke(
                    segments[index].color,
                    style: StrokeStyle(
                        lineWidth: outerRadius - innerRadius,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            }
        }
        .frame(width: outerRadius * 2, height: outerRadius * 2)
    }
}

// Пример использования
#Preview {
    let segments = [
        (100, Color.blue),
        (200, Color.green),
        (150, Color.orange),
        (50, Color.red)
    ]
    Path { path in
        path.move(to: CGPoint(x: 100, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 150))
        path.addLine(to: CGPoint(x: 0, y: 150))
        path.closeSubpath()
    }
    .stroke(Color.blue, style: StrokeStyle(
        lineWidth: 30,
        lineJoin: .round // Закругляет соединения линий
    ))
    .frame(width: 200, height: 150)

        RoundedPieChart(
            segments: segments.map { (value: Double($0.0), color: $0.1) },
            innerRadius: 30,
            outerRadius: 100
        )
        .padding()

}
