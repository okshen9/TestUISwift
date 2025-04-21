import SwiftUI

// Вместо определения структуры здесь будем использовать определение из UniversalPieSliceData.swift
// ВНИМАНИЕ: Эта структура перенесена в файл UniversalPieSliceData.swift

struct UniversalPieChartView: View {
    @ObservedObject var viewModel: UniversalPieChartViewModel
    
    // Анимационное состояние для переходов
    @State private var animationAmount: Double = 0
    
    // Размер диаграммы
    var size: CGFloat = 250
    var centerCircleSize: CGFloat = 100
    
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
        ZStack {
            // Круговая диаграмма
            ForEach(0..<slices.count, id: \.self) { i in
                UniversalPieSlice(slice: slices[i])
                    .scaleEffect(animationAmount)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.onSegmentTapped(slices[i].model)
                            resetAnimation()
                        }
                    }
            }
            
            // Центральный круг
            Circle()
                .fill(Color.white)
                .frame(width: centerCircleSize, height: centerCircleSize)
                .shadow(radius: 2)
                .onTapGesture {
                    withAnimation(.spring()) {
                        viewModel.onCenterTapped()
                        resetAnimation()
                    }
                }
            
            // Текст в центре
            VStack {
                Text(viewModel.currentTitle)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 5)
                
                Text(String(format: "%.1f%%", viewModel.totalFillPercentage))
                    .font(.title3)
                    .fontWeight(.bold)
                
                if !viewModel.navigationStack.isEmpty {
                    Text("↩︎ Назад")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                }
            }
            .frame(width: centerCircleSize - 20)
        }
        .frame(width: size, height: size)
        .onAppear {
            animationAmount = 1
        }
    }
    
    private func resetAnimation() {
        animationAmount = 0
        withAnimation(.easeInOut(duration: 0.5)) {
            animationAmount = 1
        }
    }
}

// Компонент UniversalPieSlice перенесен в отдельный файл UniversalPieSlice.swift
// для предотвращения конфликтов и дублирования кода

// Расширение для предпросмотра
struct UniversalPieChartView_Previews: PreviewProvider {
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
        
        return UniversalPieChartView(viewModel: viewModel)
            .frame(width: 300, height: 300)
            .previewLayout(.sizeThatFits)
    }
} 