import SwiftUI

/// Демонстрационное представление для тестирования различных реализаций PieChart
struct PieChartDemoView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            Picker("Выберите вариант диаграммы", selection: $selectedTab) {
                Text("Базовая").tag(0)
                Text("Универсальная").tag(1)
                Text("Улучшенная").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            ScrollView {
                VStack(spacing: 24) {
                    switch selectedTab {
                    case 0:
                        basicPieChartDemo
                    case 1:
                        universalPieChartDemo
                    case 2:
                        enhancedPieChartDemo
                    default:
                        Text("Нет доступных диаграмм")
                    }
                    
                    // Примеры заполнения секций
                    fillPercentageExamples
                }
                .padding()
            }
        }
    }
    
    // Демонстрация базовой диаграммы
    var basicPieChartDemo: some View {
        VStack(spacing: 20) {
            Text("Базовая диаграмма").font(.headline)
            
            // Здесь будет базовая реализация диаграммы
            Text("Базовая реализация с относительными размерами секций")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    // Демонстрация универсальной диаграммы
    var universalPieChartDemo: some View {
        VStack(spacing: 20) {
            Text("Универсальная диаграмма").font(.headline)
            
            UniversalPieChartView(viewModel: createUniversalViewModel())
                .frame(width: 300, height: 300)
            
            Text("Универсальная реализация с равными секциями и разным заполнением")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    // Демонстрация улучшенной диаграммы
    var enhancedPieChartDemo: some View {
        VStack(spacing: 20) {
            Text("Улучшенная диаграмма").font(.headline)
            
            EnhancedUniversalPieChartView(viewModel: createUniversalViewModel())
                .frame(width: 300, height: 400)
            
            Text("Улучшенная реализация с равными секциями, разным заполнением и интерактивностью")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    // Примеры различных процентов заполнения
    var fillPercentageExamples: some View {
        VStack(spacing: 16) {
            Text("Примеры заполнения секторов").font(.headline)
            
            HStack(spacing: 20) {
                fillPercentageExample(percentage: 0.25, color: .blue, title: "25%")
                fillPercentageExample(percentage: 0.5, color: .green, title: "50%")
                fillPercentageExample(percentage: 0.75, color: .orange, title: "75%")
                fillPercentageExample(percentage: 1.0, color: .red, title: "100%")
            }
            .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    // Отдельный пример заполнения сектора
    func fillPercentageExample(percentage: Double, color: Color, title: String) -> some View {
        let sliceData = UniversalPieSliceData(
            model: PieModel(fillPercentage: percentage, color: color, title: title),
            startAngle: 0,
            endAngle: 90
        )
        
        return VStack {
            ZStack {
                // Фоновый прямоугольник
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(radius: 1)
                    .frame(width: 60, height: 60)
                
                // Сектор диаграммы
                UniversalPieSlice(slice: sliceData)
                    .frame(width: 50, height: 50)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
    
    // Создание ViewModel для универсальной диаграммы
    func createUniversalViewModel() -> UniversalPieChartViewModel {
        let viewModel = UniversalPieChartViewModel()
        
        // Подподкатегории для первой категории
        let subSubModels1 = [
            PieModel(fillPercentage: 0.7, color: .orange, title: "Подподкатегория 1.1.1"),
            PieModel(fillPercentage: 0.4, color: .yellow, title: "Подподкатегория 1.1.2")
        ]
        
        // Подкатегории для первой категории
        let subModels1 = [
            PieModel(fillPercentage: 0.6, subModels: subSubModels1, color: .green, title: "Подкатегория 1.1"),
            PieModel(fillPercentage: 0.3, color: .blue, title: "Подкатегория 1.2")
        ]
        
        // Подкатегории для второй категории
        let subModels2 = [
            PieModel(fillPercentage: 0.5, color: .purple, title: "Подкатегория 2.1"),
            PieModel(fillPercentage: 0.8, color: .pink, title: "Подкатегория 2.2")
        ]
        
        // Основные категории
        let models = [
            PieModel(fillPercentage: 0.5, subModels: subModels1, color: .red, title: "Категория 1"),
            PieModel(fillPercentage: 0.7, subModels: subModels2, color: .blue, title: "Категория 2"),
            PieModel(fillPercentage: 0.2, color: .green, title: "Категория 3"),
            PieModel(fillPercentage: 0.9, color: .orange, title: "Категория 4")
        ]
        
        viewModel.models = models
        return viewModel
    }
}

struct PieChartDemoView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartDemoView()
    }
} 
