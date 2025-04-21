import SwiftUI
import Charts

/// Варианты анимации для переключения между диаграммами
enum ChartTransitionAnimation: String, CaseIterable, Identifiable {
    case fade = "Затухание"
    case scale = "Масштабирование"
    case slide = "Сдвиг"
    case flip = "Переворот"
    case combined = "Комбинированный"
    
    var id: String { rawValue }
    
    /// Возвращает анимацию перехода
    var transition: AnyTransition {
        switch self {
        case .fade:
            return .opacity
        case .scale:
            return .scale
        case .slide:
            return .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            )
        case .flip:
            return .asymmetric(
                insertion: .opacity.combined(with: .offset(x: 0, y: 50)),
                removal: .opacity.combined(with: .offset(x: 0, y: -50))
            )
        case .combined:
            return .asymmetric(
                insertion: .scale.combined(with: .opacity),
                removal: .scale.combined(with: .opacity)
            )
        }
    }
    
    /// Возвращает длительность анимации
    var duration: Double {
        switch self {
        case .fade, .scale:
            return 0.3
        case .slide, .flip, .combined:
            return 0.5
        }
    }
    
    /// Возвращает пружинную анимацию с настраиваемыми параметрами
    func animation() -> Animation {
        switch self {
        case .fade, .scale:
            return .easeInOut(duration: duration)
        case .slide, .flip, .combined:
            return .spring(response: duration, dampingFraction: 0.7)
        }
    }
}

/// Модель для категории с иерархическими данными
struct CategoryData: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let color: Color
    let value: Double
    let total: Double
    var subcategories: [CategoryData]
    
    /// Процент выполнения категории (от 0 до 1)
    var progress: Double {
        total > 0 ? min(value / total, 1.0) : 0
    }
    
    /// Имеет ли категория дочерние элементы
    var hasSubcategories: Bool {
        !subcategories.isEmpty
    }
    
    // Реализация Equatable для корректной работы анимаций
    static func == (lhs: CategoryData, rhs: CategoryData) -> Bool {
        lhs.id == rhs.id
    }
}

/// Компонент круговой диаграммы для отображения категорий с возможностью навигации по иерархии
struct CategoryChart: View {
    // MARK: - Properties
    
    /// Источник данных для диаграммы
    let dataSource: CategoryData
    
    /// Текущая отображаемая категория
    @State private var currentCategory: CategoryData
    
    /// Путь навигации по категориям
    @State private var navigationPath: [CategoryData] = []
    
    /// Выбранная категория для показа тоста
    @State private var selectedNonNavigableCategory: CategoryData?
    @State private var showToast = false
    
    /// Тип анимации для переходов
    @State private var transitionAnimation: ChartTransitionAnimation = .combined
    
    // MARK: - Initializers
    
    init(dataSource: CategoryData) {
        self.dataSource = dataSource
        self._currentCategory = State(initialValue: dataSource)
    }
    
    init(dataSource: CategoryData, animation: ChartTransitionAnimation) {
        self.dataSource = dataSource
        self._currentCategory = State(initialValue: dataSource)
        self._transitionAnimation = State(initialValue: animation)
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 0) {
            // Инструменты переключения анимации (только для предпросмотра)
            #if DEBUG
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                animationPickerView
            }
            #endif
            
            // Основное содержимое: диаграмма или сообщение о пустой категории
            ZStack {
                if currentCategory.hasSubcategories {
                    chartView
                        .transition(transitionAnimation.transition)
                } else {
                    emptyStateView
                        .transition(.opacity)
                }
            }
            .animation(transitionAnimation.animation(), value: currentCategory.id)
            
            // Дополнительная информация о категории (значения)
            categoryInfoView
                .padding(.top)
        }
        .overlay(
            // Тост для отображения информации о выбранной категории без подкатегорий
            ZStack {
                if showToast, let category = selectedNonNavigableCategory {
                    VStack {
                        Text(category.name)
                            .font(.headline)
                        
                        Text("\(Int(category.progress * 100))% (\(Int(category.value))/\(Int(category.total)))")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground).opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.bottom, 50)
                    .transition(.opacity)
                    .onAppear {
                        // Скрыть тост через 2 секунды
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
                }
            }, alignment: .bottom
        )
        // Отображение хлебных крошек в виде оверлея
        .overlay(
            breadcrumbsView
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)),
            alignment: .bottom
        )
    }
    
    // MARK: - Subviews
    
    #if DEBUG
    /// Переключатель анимаций для предпросмотра
    private var animationPickerView: some View {
        Picker("Анимация", selection: $transitionAnimation) {
            ForEach(ChartTransitionAnimation.allCases) { animation in
                Text(animation.rawValue).tag(animation)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    #endif
    
    /// Хлебные крошки для навигации
    private var breadcrumbsView: some View {
        Group {
            if !navigationPath.isEmpty {
                HStack {
                    ForEach(Array(navigationPath.enumerated()), id: \.1.id) { index, category in
                        if index > 0 {
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(category.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    if !navigationPath.isEmpty {
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text(currentCategory.name)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color(UIColor.systemBackground).opacity(0.8))
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                )
            }
        }
    }
    
    /// Представление диаграммы
    private var chartView: some View {
        PieChartViewOld(
            data: currentCategory.subcategories,
            categoryName: currentCategory.name,
            hasParent: !navigationPath.isEmpty,
            onCategorySelected: handleCategorySelection,
            onCenterTapped: navigateUp
        )
        .frame(height: 300)
        .padding()
    }
    
    /// Пустое состояние, когда нет подкатегорий
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.pie")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("Нет подкатегорий")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("В категории '\(currentCategory.name)' отсутствуют дочерние элементы")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if !navigationPath.isEmpty {
                Button(action: navigateUp) {
                    Label("Вернуться назад", systemImage: "arrow.left")
                }
                .padding(.top, 8)
            }
        }
        .frame(height: 300)
        .padding()
    }
    
    /// Информация о текущей категории
    private var categoryInfoView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Text("\(Int(currentCategory.progress * 100))%")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .animation(.spring(), value: currentCategory.progress)
            }
            
            HStack(spacing: 4) {
                Text("\(Int(currentCategory.value))")
                    .fontWeight(.medium)
                
                Text("из")
                    .foregroundColor(.secondary)
                
                Text("\(Int(currentCategory.total))")
                    .fontWeight(.medium)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.bottom)
    }
    
    // MARK: - Actions
    
    /// Обработка выбора категории
    private func handleCategorySelection(_ category: CategoryData) {
        if category.hasSubcategories {
            // Если есть подкатегории, переходим к ним
            withAnimation {
                navigationPath.append(currentCategory)
                currentCategory = category
            }
        } else {
            // Если нет подкатегорий, показываем тост
            selectedNonNavigableCategory = category
            withAnimation {
                showToast = true
            }
        }
    }
    
    /// Навигация на уровень вверх
    private func navigateUp() {
        guard let previousCategory = navigationPath.popLast() else { return }
        withAnimation {
            currentCategory = previousCategory
        }
    }
}

/// Компонент круговой диаграммы
struct PieChartViewOld: View {
    // MARK: - Properties
    
    /// Данные для диаграммы
    let data: [CategoryData]
    
    /// Имя текущей категории (для отображения в центре)
    let categoryName: String
    
    /// Имеет ли текущая категория родителя (для отображения кнопки назад)
    let hasParent: Bool
    
    /// Обработчик выбора категории
    let onCategorySelected: (CategoryData) -> Void
    
    /// Обработчик нажатия на центр
    let onCenterTapped: () -> Void
    
    /// Минимальный угол для отображения метки (в градусах)
    private let minimumAngleForLabel: Double = 20.0
    
    /// Состояние анимации для изменения данных
    @State private var animationProgress: Double = 0
    
    // MARK: - Private Properties
    
    /// Вычисление сегментов диаграммы
    private var chartSegments: [ChartSegment] {
        guard !data.isEmpty else { return [] }
        
        var segments: [ChartSegment] = []
        var startAngle: Double = 0
        let total = calculateTotal()
        
        // Сначала вычисляем размер каждого сектора пропорционально значению
        for category in data {
            // Защита от деления на ноль
            guard total > 0 else { continue }
            
            // Рассчитываем угол для сегмента на основе пропорционального значения
            let angle = 360 * (category.value / total)
            
            segments.append(ChartSegment(
                id: category.id,
                category: category,
                startAngle: startAngle,
                endAngle: startAngle + angle,
                shouldShowLabel: angle >= minimumAngleForLabel // Показывать метку только если сектор достаточно большой
            ))
            
            startAngle += angle
        }
        
        return segments
    }
    
    /// Вычисление общей суммы для пропорционального отображения
    private func calculateTotal() -> Double {
        let sum = data.reduce(0) { $0 + $1.value }
        return sum > 0 ? sum : 1 // Избегаем деления на ноль
    }
    
    // MARK: - View
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фон (серый круг)
                Circle()
                    .fill(Color(UIColor.systemGray5))
                
                // Круговая диаграмма
                ForEach(chartSegments) { segment in
                    PieSliceOld(
                        startAngle: segment.startAngle,
                        endAngle: segment.startAngle + (segment.endAngle - segment.startAngle) * animationProgress
                    )
                    .fill(segment.category.color)
                    .overlay(
                        PieSliceOld(
                            startAngle: segment.startAngle,
                            endAngle: segment.startAngle + (segment.endAngle - segment.startAngle) * animationProgress
                        )
                        .stroke(Color.white, lineWidth: 2)
                    )
                    .onTapGesture {
                        onCategorySelected(segment.category)
                    }
                }
                
                // Название категорий (только для достаточно больших секторов)
                ForEach(chartSegments.filter { $0.shouldShowLabel }) { segment in
                    PieSliceLabel(
                        text: segment.category.name,
                        progress: segment.category.progress,
                        angle: (segment.startAngle + segment.endAngle * animationProgress) / 2,
                        radius: min(geometry.size.width, geometry.size.height) / 3
                    )
                    .opacity(animationProgress)
                }
                
                // Внутренний круг и центральные элементы
                Circle()
                    .fill(Color(UIColor.systemBackground))
                    .frame(width: min(geometry.size.width, geometry.size.height) / 2)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .onTapGesture {
                        if hasParent {
                            onCenterTapped()
                        }
                    }
                
                // Название категории и иконка назад в центре
                VStack(spacing: 4) {
                    if hasParent {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(categoryName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.primary)
                }
                .frame(width: min(geometry.size.width, geometry.size.height) / 3)
                .contentShape(Rectangle())
                .onTapGesture {
                    if hasParent {
                        onCenterTapped()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animationProgress = 1.0
                }
            }
            .onChange(of: data) { _ in
                // Сбрасываем и запускаем анимацию при изменении данных
                animationProgress = 0
                withAnimation(.easeInOut(duration: 1.0)) {
                    animationProgress = 1.0
                }
            }
        }
    }
}

/// Структура для сегмента круговой диаграммы
struct ChartSegment: Identifiable {
    let id: UUID
    let category: CategoryData
    let startAngle: Double
    let endAngle: Double
    let shouldShowLabel: Bool
}

/// Компонент для отрисовки сегмента круговой диаграммы
struct PieSliceOld: Shape {
    let startAngle: Double
    var endAngle: Double
    
    // Для анимации изменения формы
    var animatableData: Double {
        get { endAngle }
        set { endAngle = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let startAngleRadians = startAngle * .pi / 180
        let endAngleRadians = endAngle * .pi / 180
        
        var path = Path()
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: Angle(radians: startAngleRadians),
            endAngle: Angle(radians: endAngleRadians),
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
}

/// Компонент для отображения названия категории в диаграмме
struct PieSliceLabel: View {
    let text: String
    let progress: Double
    let angle: Double
    let radius: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                .position(
                    x: geometry.size.width / 2 + cos(angle * .pi / 180) * radius,
                    y: geometry.size.height / 2 + sin(angle * .pi / 180) * radius
                )
                .lineLimit(1)
                .fixedSize()
        }
    }
}

// MARK: - Preview

struct CategoryChart_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(ChartTransitionAnimation.allCases) { animation in
                CategoryChart(dataSource: sampleCategories, animation: animation)
                    .frame(height: 400)
                    .previewDisplayName(animation.rawValue)
            }
        }
        
        CategoryChart(dataSource: sampleCategories)
            .preferredColorScheme(.dark)
            .previewDisplayName("Темная тема")

        CategoryChart(dataSource: sampleCategories)
            .preferredColorScheme(.light)
            .previewDisplayName("Светлая тема")
    }
    
    // Пример данных для предпросмотра с многоуровневой иерархией
    static var sampleCategories: CategoryData {
        CategoryData(
            name: "Проекты 2023",
            color: .blue,
            value: 250,
            total: 400,
            subcategories: [
                CategoryData(
                    name: "Мобильное приложение", 
                    color: .green, 
                    value: 120, 
                    total: 200,
                    subcategories: [
                        CategoryData(
                            name: "UI Дизайн", 
                            color: .orange, 
                            value: 35, 
                            total: 60,
                            subcategories: [
                                CategoryData(
                                    name: "Главный экран",
                                    color: .purple,
                                    value: 15,
                                    total: 20,
                                    subcategories: [
                                        CategoryData(
                                            name: "Кнопки (Пустая)",
                                            color: .red,
                                            value: 5,
                                            total: 7,
                                            subcategories: []
                                        ),
                                        CategoryData(
                                            name: "Навигация (Пустая)",
                                            color: .pink,
                                            value: 3,
                                            total: 5,
                                            subcategories: []
                                        )
                                    ]
                                ),
                                CategoryData(
                                    name: "Страница профиля (Пустая)",
                                    color: .teal,
                                    value: 10,
                                    total: 15,
                                    subcategories: []
                                )
                            ]
                        ),
                        CategoryData(
                            name: "Бэкенд интеграция", 
                            color: .purple, 
                            value: 45, 
                            total: 60,
                            subcategories: [
                                CategoryData(
                                    name: "API клиент",
                                    color: .mint,
                                    value: 20,
                                    total: 25,
                                    subcategories: [
                                        CategoryData(
                                            name: "Авторизация (Пустая)",
                                            color: .indigo,
                                            value: 8,
                                            total: 10,
                                            subcategories: []
                                        ),
                                        CategoryData(
                                            name: "Обработка данных (Пустая)",
                                            color: .gray,
                                            value: 5,
                                            total: 8,
                                            subcategories: []
                                        )
                                    ]
                                ),
                                CategoryData(
                                    name: "Хранилище (Пустая)",
                                    color: .brown,
                                    value: 15,
                                    total: 20,
                                    subcategories: []
                                )
                            ]
                        )
                    ]
                ),
                CategoryData(
                    name: "Веб-сайт", 
                    color: .red, 
                    value: 80, 
                    total: 120,
                    subcategories: [
                        CategoryData(
                            name: "Фронтенд",
                            color: .orange,
                            value: 40,
                            total: 60,
                            subcategories: [
                                CategoryData(
                                    name: "Главная страница (Пустая)",
                                    color: .yellow,
                                    value: 15,
                                    total: 20,
                                    subcategories: []
                                ),
                                CategoryData(
                                    name: "Страница блога (Пустая)",
                                    color: .green,
                                    value: 10,
                                    total: 15,
                                    subcategories: []
                                )
                            ]
                        ),
                        CategoryData(
                            name: "Бэкенд (Пустая)",
                            color: .cyan,
                            value: 30,
                            total: 40,
                            subcategories: []
                        )
                    ]
                ),
                CategoryData(
                    name: "Документация", 
                    color: .cyan, 
                    value: 10, 
                    total: 80,
                    subcategories: [
                        CategoryData(
                            name: "API документация (Пустая)",
                            color: .indigo,
                            value: 20,
                            total: 30,
                            subcategories: []
                        ),
                        CategoryData(
                            name: "Руководство пользователя (Пустая)",
                            color: .teal,
                            value: 15,
                            total: 25,
                            subcategories: []
                        )
                    ]
                )
            ]
        )
    }
} 
