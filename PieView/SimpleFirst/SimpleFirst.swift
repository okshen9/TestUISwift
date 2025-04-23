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
    
    // Состояние для навигации по иерархии моделей
    @State private var currentLevel: Int = 0
    @State private var navigationHistory: [[PieModel]] = []
    @State private var currentTitle: String = "Главная"
    
    // Название диаграммы
    let diagramTitle: String
    
    init(slices: [PieModel], segmentSpacing: Double = 0.03, cornerRadius: CGFloat = 10, title: String = "Главная") {
        self.slices = slices
        self.segmentSpacing = segmentSpacing
        self.cornerRadius = cornerRadius
        self.diagramTitle = title
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
            // Заголовок с текущим уровнем
            Text(currentTitle)
                .font(.headline)
                .padding(.top)

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
                        .contentShape(PieSliceShape(
                            startAngle: start,
                            endAngle: bgEnd,
                            cornerRadius: cornerRadius
                        ))
                        .onTapGesture {
                            navigateToSubmodels(of: entry.model)
                        }
                        .overlay {
                            if entry.model.subModel != nil && !(entry.model.subModel?.isEmpty ?? true) {
                                // Вычисляем позицию для индикатора
                                let midAngle = (start + bgEnd) / 2
                                let radius = min(geometry.size.width, geometry.size.height) / 2.5
                                let indicatorX = geometry.size.width / 2 + cos(midAngle.radians) * radius
                                let indicatorY = geometry.size.height / 2 + sin(midAngle.radians) * radius
                                
                                ZStack {
                                    // Светящийся круг
                                    Circle()
                                        .fill(entry.model.color.opacity(0.3))
                                        .blur(radius: 4)
                                        .frame(width: 30, height: 30)
                                
                                    // Индикатор в виде круга со стрелкой
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 22, height: 22)
                                        .overlay {
                                            Image(systemName: "chevron.down")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(entry.model.color)
                                                .rotationEffect(.radians(midAngle.radians - .pi/2))
                                        }
                                        .shadow(color: .black.opacity(0.2), radius: 2)
                                }
                                .position(x: indicatorX, y: indicatorY)
                            }
                        }

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
                        .contentShape(PieSliceShape(
                            startAngle: start,
                            endAngle: fgEnd,
                            cornerRadius: cornerRadius
                        ))
                        .onTapGesture {
                            navigateToSubmodels(of: entry.model)
                        }
                    }
                    
                    // Центральный круг
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 1.5)
                        .shadow(color: .black.opacity(0.1), radius: 2)
                        .contentShape(Circle())
                        .onTapGesture {
                            navigateToParentLevel()
                        }
                    
                    let present = (animatableSlices.reduce(0.0) { $0 + $1.currentValue }) / Double(animatableSlices.isEmpty ? 1 : animatableSlices.count)
                    VStack(spacing: 6) {
                        if currentLevel > 0 {
                            // Индикатор перехода на уровень выше в центре
                            ZStack {
                                // Светящийся эффект
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 30, height: 30)
                                    .blur(radius: 4)
                                
                                // Иконка
                                Circle()
                                    .fill(.white)
                                    .frame(width: 26, height: 26)
                                    .overlay {
                                        Image(systemName: "arrow.up")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.blue)
                                    }
                                    .shadow(color: .black.opacity(0.2), radius: 1)
                            }
                            .frame(maxWidth: 20, maxHeight: 20)
                        }
                        
                        // Название текущего уровня
                        Text(currentLevel == 0 ? diagramTitle : currentTitle)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.7)
                        
                        Text("Выполнено \(Int(present * 100))%")
                            .fontWeight(.semibold)
                    }
                    .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 1.5)
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
                        
                        // Индикатор наличия дочерних моделей
                        if slice.subModel != nil && !(slice.subModel?.isEmpty ?? true) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .id("\(slice.id)-legend")
                    .transition(AnyTransition.opacity.combined(with: .slide))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        navigateToSubmodels(of: slice)
                    }
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
                    navigationHistory = [[]] // Инициализируем историю навигации
                    currentLevel = 0
                    currentTitle = diagramTitle // Устанавливаем начальный заголовок
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
    
    // Функция для перехода на уровень ниже к дочерним моделям
    private func navigateToSubmodels(of model: PieModel) {
        guard let subModels = model.subModel, !subModels.isEmpty else { return }
        
        // Сохраняем текущий уровень в историю
        if navigationHistory.count <= currentLevel {
            navigationHistory.append(animatableSlices)
        } else {
            navigationHistory[currentLevel] = animatableSlices
        }
        
        // Переходим на уровень ниже
        withAnimation {
            currentLevel += 1
        }
        currentTitle = model.title
        
        // Анимируем переход
        withAnimation(.easeInOut(duration: 0.4)) {
            scale = 0.1
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            // Обновляем данные с новым уровнем
            animatableSlices = subModels
            id = UUID()
            
            withAnimation(.spring(duration: 0.6, bounce: 0.3)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
    
    // Функция для перехода на уровень выше
    private func navigateToParentLevel() {
        guard currentLevel > 0 else { return }
        
        // Анимируем переход
        withAnimation(.easeInOut(duration: 0.4)) {
            scale = 0.1
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            // Уменьшаем уровень
            currentLevel -= 1
            
            // Обновляем заголовок
            if currentLevel == 0 {
                currentTitle = diagramTitle
            } else {
                // Для промежуточных уровней используем название из модели соответствующего уровня
                if let parentModel = self.navigationHistory.prefix(currentLevel).last?.first(where: { model in
                    model.subModel?.contains(where: { $0.title == self.currentTitle }) ?? false
                }) {
                    currentTitle = parentModel.title
                }
            }
            
            // Восстанавливаем данные предыдущего уровня
            if currentLevel < navigationHistory.count {
                animatableSlices = navigationHistory[currentLevel]
            } else {
                animatableSlices = slices
            }
            
            id = UUID()
            
            withAnimation(.spring(duration: 0.6, bounce: 0.3)) {
                scale = 1.0
                opacity = 1.0
            }
        }
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
        PieModel(
            totalValue: 0.3, 
            currentValue: 0.2, 
            subModel: [
                PieModel(totalValue: 0.5, currentValue: 0.3, color: .orange, title: "Подкатегория 1.1"),
                PieModel(totalValue: 0.5, currentValue: 0.7, color: .pink, title: "Подкатегория 1.2")
            ],
            color: .red, 
            title: "Здоровье"
        ),
        PieModel(
            totalValue: 0.4, 
            currentValue: 0.3, 
            subModel: [
                PieModel(totalValue: 0.3, currentValue: 0.6, color: .mint, title: "Подкатегория 2.1"),
                PieModel(totalValue: 0.3, currentValue: 0.4, color: .teal, title: "Подкатегория 2.2"),
                PieModel(totalValue: 0.4, currentValue: 0.2, color: .cyan, title: "Подкатегория 2.3")
            ],
            color: .green, 
            title: "Бизнес"
        ),
        PieModel(totalValue: 0.3, currentValue: 1.0, color: .blue, title: "Категория 3"),
        PieModel(totalValue: 0.3, currentValue: 0.9, color: .yellow, title: "Категория 4")
    ]

    VStack {
        SimpleFirst(slices: value2, title: "Мои цели")
            .frame(height: 400)
        Spacer()
        HStack {
            Button(action: {
                // Генерируем случайные значения для прогресса
                value2 = value2.map { model in
                    var newModel = model
                    newModel.currentValue = Double.random(in: 0...1)
                    
                    // Также обновляем значения в подмоделях, если они есть
                    if var subModels = model.subModel {
                        subModels = subModels.map { subModel in
                            var newSubModel = subModel
                            newSubModel.currentValue = Double.random(in: 0...1)
                            return newSubModel
                        }
                        newModel.subModel = subModels
                    }
                    
                    return newModel
                }
            }, label: { Text("Изменить значения") })
            
            Button(action: {
                // Изменяем структуру (добавляем/удаляем элементы)
                if value2.count > 3 {
                    value2 = [
                        PieModel(
                            totalValue: 0.5, 
                            currentValue: 0.6, 
                            subModel: [
                                PieModel(totalValue: 1.0, currentValue: 0.3, color: .indigo, title: "Подкатегория")
                            ],
                            color: .red, 
                            title: "Здоровье"
                        ),
                        PieModel(totalValue: 0.5, currentValue: 0.8, color: .blue, title: "Категория 3")
                    ]
                } else {
                    value2 = [
                        PieModel(
                            totalValue: 0.3, 
                            currentValue: 0.2, 
                            subModel: [
                                PieModel(totalValue: 0.5, currentValue: 0.3, color: .orange, title: "Подкатегория 1.1"),
                                PieModel(totalValue: 0.5, currentValue: 0.7, color: .pink, title: "Подкатегория 1.2")
                            ],
                            color: .red, 
                            title: "Здоровье"
                        ),
                        PieModel(
                            totalValue: 0.4, 
                            currentValue: 0.3, 
                            subModel: [
                                PieModel(totalValue: 0.3, currentValue: 0.6, color: .mint, title: "Подкатегория 2.1"),
                                PieModel(totalValue: 0.3, currentValue: 0.4, color: .teal, title: "Подкатегория 2.2"),
                                PieModel(totalValue: 0.4, currentValue: 0.2, color: .cyan, title: "Подкатегория 2.3")
                            ],
                            color: .green, 
                            title: "Бизнес"
                        ),
                        PieModel(totalValue: 0.3, currentValue: 1.0, color: .blue, title: "Категория 3"),
                        PieModel(totalValue: 0.3, currentValue: 0.9, color: .yellow, title: "Категория 4")
                    ]
                }
            }, label: { Text("Изменить структуру") })
        }
    }
}
