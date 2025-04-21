import SwiftUI

struct SimpleFirst: View {
    let slices: [PieModel]
    @State private var selectedSlice: PieModel?
    
    // Настраиваемые параметры
    let segmentSpacing: Double // Отступ между сегментами (0.0 - 1.0)
    
    init(slices: [PieModel], segmentSpacing: Double = 0.02) {
        self.slices = slices
        self.segmentSpacing = segmentSpacing
    }
    
    private var normalizedSlices: [(model: PieModel, normalizedValue: Double)] {
        let totalValue = slices.reduce(0.0) { $0 + $1.totalValue }
        let totalSpacing = segmentSpacing * Double(slices.count)
        let availableSpace = 1.0 - totalSpacing
        
        return slices.map { slice in
            let normalizedValue = (slice.totalValue / totalValue) * availableSpace
            return (slice, normalizedValue)
        }
    }
    
    var body: some View {
        VStack {
            // Круговая диаграмма
            ZStack {
                ForEach(Array(normalizedSlices.enumerated()), id: \.element.model.id) { index, sliceData in
                    let startAngle = calculateStartAngle(for: index)
                    let endAngle = startAngle + .degrees(360 * sliceData.normalizedValue)
                    
                    ZStack {
                        // Фоновый слой
                        PieSimpleSliceView(
                            simpleSliceModel: .init(
                                color: sliceData.model.color.opacity(0.3),
                                value: sliceData.normalizedValue,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                cornerRadius: 0
                            )
                        )
                        
                        // Передний слой с текущим значением
                        PieSimpleSliceView(
                            simpleSliceModel: .init(
                                color: sliceData.model.color,
                                value: sliceData.model.currentvlue * sliceData.normalizedValue,
                                startAngle: startAngle,
                                endAngle: startAngle + .degrees(360 * sliceData.model.currentvlue * sliceData.normalizedValue),
                                cornerRadius: 0
                            )
                        )
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedSlice = sliceData.model
                        }
                    }
                }
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
    
    private func calculateStartAngle(for index: Int) -> Angle {
        let previousValues = normalizedSlices.prefix(index).reduce(0.0) { $0 + $1.normalizedValue }
        return .degrees(360 * (previousValues + Double(index) * segmentSpacing))
    }
}

// Предварительный просмотр
struct SimpleFirst_Previews: PreviewProvider {
    static var previews: some View {
        SimpleFirst(
            slices: [
                PieModel(totalValue: 0.3, currentvlue: 0.2, subModel: nil, color: .red, title: "Категория 1"),
                PieModel(totalValue: 0.4, currentvlue: 0.3, subModel: nil, color: .blue, title: "Категория 2"),
                PieModel(totalValue: 0.3, currentvlue: 0.9, subModel: nil, color: .green, title: "Категория 3")
            ],
            segmentSpacing: 0.02 // 2% отступ между сегментами
        )
    }
}

#Preview("Multi Slice Pie Chart") {

}
