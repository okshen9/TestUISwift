////
////  PieChart.swift
////  TestUISwift
////
////  Created by artem on 21.04.2025.
////
//
//import SwiftUI
//
//
//struct PieChart: View {
//    let items: [any ChartItem]
//    let centerText: String
//    let currentPercentage: Double
//    let onSegmentTap: (any ChartItem) -> Void
//    let onCenterTap: () -> Void
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                ForEach(items.indices, id: \.self) { index in
//                    PieSegment(
//                        item: items[index],
//                        startAngle: angle(for: index),
//                        endAngle: angle(for: index + 1)
//                    )
//                    .onTapGesture {
//                        onSegmentTap(items[index])
//                    }
//                }
//                
//                Circle()
//                    .fill(Color.white)
//                    .frame(width: geometry.size.width/2)
//                
//                VStack {
//                    Text(centerText)
//                    Text("\(currentPercentage, specifier: "%.1f")%")
//                        .font(.headline)
//                }
//                .contentShape(Circle())
//                .onTapGesture {
//                    onCenterTap()
//                }
//            }
//        }
//    }
//    
//    private func angle(for index: Int) -> Angle {
//        let total = items.reduce(0) { $0 + $1.totalValue }
//        let percent = items[0..<index].reduce(0) { $0 + $1.totalValue } / total
//        return .degrees(percent * 360)
//    }
//}
//
//struct PieSegment: Shape {
//    let item: any ChartItem
//    var startAngle: Angle
//    var endAngle: Angle
//    
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        let center = CGPoint(x: rect.midX, y: rect.midY)
//        let radius = min(rect.width, rect.height) / 2
//        
//        path.move(to: center)
//        path.addArc(
//            center: center,
//            radius: radius,
//            startAngle: startAngle,
//            endAngle: endAngle,
//            clockwise: false
//        )
//        path.closeSubpath()
//        
//        return path
//    }
//}
