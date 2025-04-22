import SwiftUI

// Основной View для нескольких сегментов
struct SimpleFirst: View {
    let slices: [PieModel]
    let segmentSpacing: Double
    let cornerRadius: CGFloat

    init(slices: [PieModel], segmentSpacing: Double = 0.03, cornerRadius: CGFloat = 10) {
        self.slices = slices
        self.segmentSpacing = segmentSpacing
        self.cornerRadius = cornerRadius
    }

    private var normalizedSlices: [(model: PieModel, normalizedValue: Double)] {
        let total = slices.map(\ .totalValue).reduce(0, +)
        let totalSpacing = segmentSpacing * Double(slices.count)
        let available = 1 - totalSpacing
        return slices.map { slice in
            let nv = (slice.totalValue / total) * available
            return (slice, nv)
        }
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    ForEach(Array(normalizedSlices.enumerated()), id: \ .element.model.id) { idx, entry in
                        let start = calculateStartAngle(index: idx)
                        let norm = entry.normalizedValue
                        let bgEnd = start + .degrees(360 * norm)
                        let fgPortion = entry.model.currentValue * norm
                        let fgEnd = start + .degrees(360 * fgPortion)

                        PieSimpleSliceView(
                            model: .init(
                                color: entry.model.color.lighten(),
                                startAngle: start,
                                endAngle: bgEnd,
                                cornerRadius: cornerRadius
                            )
                        )

                        PieSimpleSliceView(
                            model: .init(
                                color: entry.model.color,
                                startAngle: start,
                                endAngle: fgEnd,
                                cornerRadius: cornerRadius
                            )
                        )
                    }
                    .animation(.easeInOut(duration: 0.7), value: slices)

                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 1.5)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: 300, height: 300)
            .padding()

            // Легенда
            VStack(alignment: .leading, spacing: 10) {
                ForEach(slices) { slice in
                    HStack {
                        Circle()
                            .fill(slice.color)
                            .frame(width: 20, height: 20)
                        Text(slice.title)
                        Text("(\(Int(slice.totalValue * 100))%)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
    }

    private func calculateStartAngle(index: Int) -> Angle {
        let previousTotal = normalizedSlices.prefix(index).reduce(0) { $0 + $1.normalizedValue }
        let offset = previousTotal + Double(index) * segmentSpacing
        return .degrees(360 * offset)
    }

    private func offset(for start: Angle, end: Angle, radius: CGFloat) -> CGSize {
        let mid = Angle.degrees((start.degrees + end.degrees) / 2)
        let baseOffset: CGFloat = 20
        let effectiveRadius = radius * 0.0

        let dx = cos(mid.radians) * baseOffset + (cos(mid.radians) * effectiveRadius)
        let dy = sin(mid.radians) * baseOffset + (sin(mid.radians) * effectiveRadius)

        return CGSize(width: dx, height: dy)
    }
}



#Preview {
    @Previewable @State var value = PieModel(totalValue: 0.3, currentValue: 0.2, color: .red, title: "Категория 1")

    @Previewable @State var value2 =         [
        PieModel(totalValue: 0.3, currentValue: 0.2, color: .red, title: "Категория 1"),
                    PieModel(totalValue: 0.4, currentValue: 0.3, color: .green, title: "Категория 2"),
                    PieModel(totalValue: 0.3, currentValue: 1.0, color: .blue, title: "Категория 3"),
                    PieModel(totalValue: 0.3, currentValue: 0.9, color: .yellow, title: "Категория 4")
                ]

    SimpleFirst(
        slices: value2
//            [
////            PieModel(totalValue: 0.3, currentValue: value, color: .red, title: "Категория 1"),
//            value,
//            PieModel(totalValue: 0.4, currentValue: 0.3, color: .green, title: "Категория 2"),
//            PieModel(totalValue: 0.3, currentValue: 1.0, color: .blue, title: "Категория 3"),
//            PieModel(totalValue: 0.3, currentValue: 0.9, color: .yellow, title: "Категория 4")
//        ]
    )

    Button(action: {
//        value = PieModel(totalValue: 0.3, currentValue: Double.random(in: 0...1), color: .red, title: "Категория 1")

        value2 = [ PieModel(totalValue: 0.3, currentValue: Double.random(in: 0...1), color: .red, title: "Категория 1"),
                    PieModel(totalValue: 0.4, currentValue: 0.3, color: .green, title: "Категория 2"),
                    PieModel(totalValue: 0.3, currentValue: 1.0, color: .blue, title: "Категория 3"),
                    PieModel(totalValue: 0.3, currentValue: 0.9, color: .yellow, title: "Категория 4")
                ]
    }, label: {Text(("sdsd"))})
}
