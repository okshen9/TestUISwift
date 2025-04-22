import SwiftUI

// Основной View для нескольких сегментов
struct SimpleFirst: View {
    let slices: [PieModel]
    let segmentSpacing: Double
    let cornerRadius: CGFloat
    
    // Анимируемое состояние для плавных переходов
    @State private var animatableSlices: [PieModel] = []
    @State private var id = UUID()
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @State private var isChangingStructure = false
    
    init(slices: [PieModel], segmentSpacing: Double = 0.03, cornerRadius: CGFloat = 10) {
        self.slices = slices
        self.segmentSpacing = segmentSpacing
        self.cornerRadius = cornerRadius
    }
    
    private var normalizedSlices: [(model: PieModel, normalizedValue: Double)] {
        let total = animatableSlices.map(\.totalValue).reduce(0, +) 
        let totalSpacing = segmentSpacing * Double(animatableSlices.count)
        let available = 1 - totalSpacing
        return animatableSlices.map { slice in
            let nv = (slice.totalValue / total) * available
            return (slice, nv)
        }
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                // Диаграмма с анимацией масштаба и прозрачности
                ZStack {
                    // Используем id для явного обновления всего содержимого
                    ForEach(normalizedSlices, id: \.model.id) { entry in
                        let idx = animatableSlices.firstIndex(where: { $0.id == entry.model.id }) ?? 0
                        let start = calculateStartAngle(index: idx)
                        let norm = entry.normalizedValue
                        let bgEnd = start + .degrees(360 * norm)
                        let fgPortion = entry.model.currentValue * norm
                        let fgEnd = start + .degrees(360 * fgPortion)

                        // Фоновый слой
                        PieSimpleSliceView(
                            model: .init(
                                color: entry.model.color.lighten(),
                                startAngle: start,
                                endAngle: bgEnd,
                                cornerRadius: cornerRadius
                            )
                        )
                        .id("\(entry.model.id)-bg")

                        // Слой прогресса
                        PieSimpleSliceView(
                            model: .init(
                                color: entry.model.color,
                                startAngle: start,
                                endAngle: fgEnd,
                                cornerRadius: cornerRadius
                            )
                        )
                        .id("\(entry.model.id)-fg")
                    }
                    
                    // Центральный круг
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 1.5)
                    
                    let present = (animatableSlices.reduce(0.0) { $0 + $1.currentValue }) / Double(animatableSlices.isEmpty ? 1 : animatableSlices.count)
                    Text("Выполнено \(Int(present * 100))%")
                        .fontWeight(.semibold)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .id(id) // Используем id для обновления всего ZStack
            }
            .frame(width: 300, height: 300)
            .padding()
            
            // Легенда
            VStack(alignment: .leading, spacing: 10) {
                ForEach(animatableSlices) { slice in
                    HStack {
                        Circle()
                            .fill(slice.color)
                            .frame(width: 20, height: 20)
                        Text(slice.title)
                        Text("(\(Int(slice.totalValue * 100))%)")
                            .foregroundColor(.secondary)
                    }
                    .id("\(slice.id)-legend")
                    .transition(AnyTransition.opacity.combined(with: .slide))
                }
            }
            .opacity(opacity)
            .padding()
        }
        .onChange(of: slices) { oldValue, newValue in
            // Определяем тип изменения
            if hasSameStructureButDifferentValues(oldValue, newValue) {
                // Только изменение прогресса - плавная анимация
                withAnimation(.easeInOut(duration: 0.7)) {
                    animatableSlices = newValue
                }
            } else {
                // Изменение структуры - анимируем исчезновение всей диаграммы
                isChangingStructure = true
                
                // Анимация уменьшения и исчезновения
                withAnimation(.easeInOut(duration: 0.4)) {
                    scale = 0.1
                    opacity = 0
                }
                
                // После исчезновения обновляем данные
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    animatableSlices = newValue
                    id = UUID() // Принудительное обновление структуры диаграммы
                    
                    // Анимация появления и увеличения
                    withAnimation(.spring(duration: 0.6, bounce: 0.3)) {
                        scale = 1.0
                        opacity = 1.0
                    }
                    
                    isChangingStructure = false
                }
            }
        }
        .onAppear {
            // При первом появлении анимируем с нуля
            scale = 0.1
            opacity = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(duration: 0.8)) {
                    animatableSlices = slices
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
    }

    private func calculateStartAngle(index: Int) -> Angle {
        let previousTotal = normalizedSlices.prefix(index).reduce(0) { $0 + $1.normalizedValue }
        let offset = previousTotal + Double(index) * segmentSpacing
        return .degrees(360 * offset)
    }
    
    private func hasSameStructureButDifferentValues(_ old: [PieModel], _ new: [PieModel]) -> Bool {
        guard old.count == new.count else { return false }
        
        for i in 0..<old.count {
            if i >= old.count || i >= new.count { return false }
            if old[i].id != new[i].id || old[i].title != new[i].title || old[i].color != new[i].color {
                return false
            }
        }
        
        return true
    }
}

// Создадим расширение для анимируемого PieModel
// Это позволит SwiftUI анимировать свойства этого типа
extension PieModel: Animatable {
    public var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(currentValue, totalValue) }
        set {
            currentValue = newValue.first
            totalValue = newValue.second
        }
    }
}

#Preview {
    @Previewable @State var value = PieModel(totalValue: 0.3, currentValue: 0.2, color: .red, title: "Категория 1")

    @Previewable @State var value2 = [
        PieModel(totalValue: 0.3, currentValue: 0.2, color: .red, title: "Категория 1"),
        PieModel(totalValue: 0.4, currentValue: 0.3, color: .green, title: "Категория 2"),
        PieModel(totalValue: 0.3, currentValue: 1.0, color: .blue, title: "Категория 3"),
        PieModel(totalValue: 0.3, currentValue: 0.9, color: .yellow, title: "Категория 4")
    ]

    VStack {
        SimpleFirst(slices: value2)
        Spacer()
        HStack {
            Button(action: {
                // Генерируем случайные значения для прогресса
                value2 = value2.map { model in
                    var newModel = model
                    newModel.currentValue = Double.random(in: 0...1)
                    return newModel
                }
            }, label: { Text("Изменить значения") })
            
            Button(action: {
                // Изменяем структуру (добавляем/удаляем элементы)
                if value2.count > 3 {
                    value2 = [
                        PieModel(totalValue: 0.5, currentValue: 0.6, color: .red, title: "Категория 1"),
                        PieModel(totalValue: 0.5, currentValue: 0.8, color: .blue, title: "Категория 3")
                    ]
                } else {
                    value2 = [
                        PieModel(totalValue: 0.3, currentValue: 0.2, color: .red, title: "Категория 1"),
                        PieModel(totalValue: 0.4, currentValue: 0.3, color: .green, title: "Категория 2"),
                        PieModel(totalValue: 0.3, currentValue: 1.0, color: .blue, title: "Категория 3"),
                        PieModel(totalValue: 0.3, currentValue: 0.9, color: .yellow, title: "Категория 4")
                    ]
                }
            }, label: { Text("Изменить структуру") })
        }
    }
}
