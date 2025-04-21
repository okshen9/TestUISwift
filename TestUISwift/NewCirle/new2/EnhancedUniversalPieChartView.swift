import SwiftUI
// Не нужно явно импортировать, так как структура определена в проекте, а не в модуле

struct EnhancedUniversalPieChartView: View {
    @ObservedObject var viewModel: UniversalPieChartViewModel
    
    // Анимация
    @State private var animationAmount: Double = 0
    @State private var selectedSliceIndex: Int? = nil
    
    // Настройки размера
    var size: CGFloat = 250
    var padding: CGFloat = 20
    var progressCircleSize: CGFloat = 60
    
    // Вычисляем данные для сегментов диаграммы
    private var slices: [UniversalPieSliceData] {
        let models = viewModel.currentModels
        
        // Если нет моделей, возвращаем пустой массив
        guard !models.isEmpty else { return [] }
        
        // Для равных секций просто делим 360 градусов на количество моделей
        let anglePerSlice = 360.0 / Double(models.count)
        
        // Создаем сегменты
        var slices: [UniversalPieSliceData] = []
        
        for (index, model) in models.enumerated() {
            let startAngle = Double(index) * anglePerSlice
            let endAngle = startAngle + anglePerSlice
            
            // Добавляем данные о сегменте
            slices.append(UniversalPieSliceData(
                model: model,
                startAngle: startAngle,
                endAngle: endAngle
            ))
        }
        
        return slices
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Верхняя информационная панель
            generalInfoView
                .padding(.horizontal)
                .padding(.top)
            
            // Диаграмма
            ZStack {
                // Отрисовка секций
                ForEach(0..<slices.count, id: \.self) { i in
                    EnhancedUniversalPieSlice(
                        slice: slices[i],
                        isSelected: selectedSliceIndex == i,
                        offsetDistance: 10
                    )
                    .scaleEffect(animationAmount)
                    .onTapGesture {
                        handleSliceTap(index: i)
                    }
                }
                
                // Центральный круг с прогрессом
                progressCircleView
                    .frame(width: progressCircleSize, height: progressCircleSize)
                    .onTapGesture {
                        handleCenterTap()
                    }
            }
            .frame(width: size - padding * 2, height: size - padding * 2)
            .padding()
            
            // Детальная информация о выбранном сегменте
            if let selectedIndex = selectedSliceIndex, selectedIndex < slices.count {
                detailView(for: slices[selectedIndex].model)
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .frame(width: size)
        .padding(.vertical)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                animationAmount = 1
            }
        }
    }
    
    // MARK: - Component Views
    
    private var generalInfoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleView
            
            BreadcrumbView(
                navigationStack: viewModel.navigationStack,
                onNavigate: { index in
                    withAnimation {
                        viewModel.navigateToIndex(index)
                        resetSelection()
                    }
                }
            )
            .frame(height: 25)
            .padding(.bottom, 4)
        }
    }
    
    private var titleView: some View {
        Text(viewModel.currentTitle)
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
    }
    
    private var progressCircleView: some View {
        ZStack {
            progressBackgroundCircle
            progressFillCircle
            progressText
        }
    }
    
    private var progressBackgroundCircle: some View {
        Circle()
            .stroke(Color.gray.opacity(0.2), lineWidth: 8)
    }
    
    private var progressFillCircle: some View {
        Circle()
            .trim(from: 0, to: CGFloat(viewModel.totalFillPercentage) / 100)
            .stroke(progressGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
            .rotationEffect(.degrees(-90))
            .shadow(radius: 2)
    }
    
    private var progressText: some View {
        Text(String(format: "%.0f%%", viewModel.totalFillPercentage))
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.primary)
    }
    
    private var progressGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.purple]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private func detailView(for model: PieModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            detailTitleView(for: model)
            detailStatsView(for: model)
            
            if model.hasSubModels {
                detailActionButton(for: model)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    private func detailTitleView(for model: PieModel) -> some View {
        HStack {
            Circle()
                .fill(model.color)
                .frame(width: 12, height: 12)
            
            Text(model.title)
                .font(.headline)
                .lineLimit(1)
        }
    }
    
    private func detailStatsView(for model: PieModel) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Заполнение: \(String(format: "%.1f%%", model.fillPercentageValue))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func detailActionButton(for model: PieModel) -> some View {
        Button(action: {
            withAnimation {
                viewModel.onSegmentTapped(model)
                resetSelection()
            }
        }) {
            HStack {
                Text("Просмотреть подкатегории")
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Interaction Handlers
    
    private func handleSliceTap(index: Int) {
        withAnimation(.spring()) {
            if selectedSliceIndex == index {
                selectedSliceIndex = nil
            } else {
                selectedSliceIndex = index
            }
        }
    }
    
    private func handleCenterTap() {
        withAnimation(.spring()) {
            viewModel.onCenterTapped()
            resetSelection()
        }
    }
    
    private func resetSelection() {
        selectedSliceIndex = nil
        animationAmount = 0
        withAnimation(.easeInOut(duration: 0.5)) {
            animationAmount = 1
        }
    }
}

// MARK: - BreadcrumbView

struct BreadcrumbView: View {
    var navigationStack: [PieModel]
    var onNavigate: (Int) -> Void
    
    var body: some View {
        if navigationStack.isEmpty {
            EmptyView()
        } else {
            breadcrumbContent
        }
    }
    
    private var breadcrumbContent: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(0..<navigationStack.count, id: \.self) { index in
                    Button(action: {
                        onNavigate(index)
                    }) {
                        HStack(spacing: 4) {
                            if index > 0 {
                                separatorView
                            }
                            
                            titleView(for: navigationStack[index], index: index)
                            
                            if index < navigationStack.count - 1 {
                                moreIndicator
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private var separatorView: some View {
        Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundColor(.gray)
    }
    
    private func titleView(for model: PieModel, index: Int) -> some View {
        Text(model.title)
            .font(.subheadline)
            .lineLimit(1)
            .foregroundColor(index == navigationStack.count - 1 ? .primary : .blue)
    }
    
    private var moreIndicator: some View {
        EmptyView()
    }
}

// MARK: - Preview

struct EnhancedUniversalPieChartView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UniversalPieChartViewModel()
        
        // Создаем тестовые данные с процентами заполнения
        let subSubModels1 = [
            PieModel(fillPercentage: 0.7, color: .orange, title: "Подподкатегория 1.1.1"),
            PieModel(fillPercentage: 0.4, color: .yellow, title: "Подподкатегория 1.1.2")
        ]
        
        let subModels1 = [
            PieModel(fillPercentage: 0.6, subModels: subSubModels1, color: .green, title: "Подкатегория 1.1"),
            PieModel(fillPercentage: 0.3, color: .blue, title: "Подкатегория 1.2")
        ]
        
        let subModels2 = [
            PieModel(fillPercentage: 0.5, color: .purple, title: "Подкатегория 2.1"),
            PieModel(fillPercentage: 0.8, color: .pink, title: "Подкатегория 2.2")
        ]
        
        let models = [
            PieModel(fillPercentage: 0.5, subModels: subModels1, color: .red, title: "Категория 1"),
            PieModel(fillPercentage: 0.7, subModels: subModels2, color: .blue, title: "Категория 2"),
            PieModel(fillPercentage: 0.2, color: .green, title: "Категория 3"),
            PieModel(fillPercentage: 0.9, color: .orange, title: "Категория 4")
        ]
        
        viewModel.models = models
        
        return EnhancedUniversalPieChartView(viewModel: viewModel)
            .frame(width: 350, height: 700)
            .previewLayout(.sizeThatFits)
    }
} 
