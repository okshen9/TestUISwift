import SwiftUI

/// Главное демонстрационное представление для запуска улучшенной круговой диаграммы
struct EnhancedPieChartDemo: View {
    @State private var showDemoExplanation = true
    
    var body: some View {
        NavigationView {
            VStack {
                headerView
                
                if showDemoExplanation {
                    explanationView
                }
                
                // Основная демонстрация
                TabView {
                    demoView(title: "Равные секции с разным заполнением", content: equalSectionsDemo)
                    demoView(title: "Интерактивность и навигация", content: interactivityDemo)
                    demoView(title: "Визуальные компоненты", content: visualComponentsDemo)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Spacer()
            }
            .navigationTitle("Круговая диаграмма")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: toggleButton)
        }
    }
    
    // Кнопка для показа/скрытия пояснения
    private var toggleButton: some View {
        Button(action: {
            withAnimation {
                showDemoExplanation.toggle()
            }
        }) {
            Image(systemName: showDemoExplanation ? "info.circle.fill" : "info.circle")
        }
    }
    
    // Заголовок
    private var headerView: some View {
        VStack {
            Text("Улучшенная круговая диаграмма")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    // Пояснение к демонстрации
    private var explanationView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Особенности диаграммы:")
                .font(.headline)
            
            bulletPoint(text: "Равные секции с разным процентом заполнения")
            bulletPoint(text: "Секторы выделяются при нажатии на них")
            bulletPoint(text: "Поддержка навигации по вложенным категориям")
            bulletPoint(text: "Индикаторы наличия подкатегорий")
            bulletPoint(text: "Визуальные улучшения и эффекты")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal)
        .transition(.opacity)
    }
    
    // Пункт списка с маркером
    private func bulletPoint(text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.body)
            Text(text)
                .font(.body)
        }
    }
    
    // Контейнер для демонстрации
    private func demoView<Content: View>(title: String, content: Content) -> some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
                .padding(.top)
            
            content
            
            Spacer()
        }
        .padding()
    }
    
    // Демонстрация равных секций с разным заполнением
    private var equalSectionsDemo: some View {
        VStack(spacing: 30) {
            // Диаграмма
            EnhancedUniversalPieChartView(viewModel: createViewModel())
                .frame(width: 300, height: 350)
            
            // Пояснение
            Text("Каждая секция имеет одинаковый размер, но разное заполнение в зависимости от значения fillPercentage.")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .padding(.horizontal)
        }
    }
    
    // Демонстрация интерактивности
    private var interactivityDemo: some View {
        VStack(spacing: 20) {
            Text("Нажмите на сектор для его выделения и просмотра деталей")
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            EnhancedUniversalPieChartView(viewModel: createViewModel())
                .frame(width: 300, height: 350)
            
            Text("Для перехода к подкатегориям нажмите на кнопку 'Просмотреть подкатегории' в деталях сектора")
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    // Демонстрация визуальных компонентов
    private var visualComponentsDemo: some View {
        VStack(spacing: 30) {
            // Примеры заполнения
            HStack(spacing: 20) {
                fillExample(percentage: 0.25, title: "25%")
                fillExample(percentage: 0.5, title: "50%")
                fillExample(percentage: 0.75, title: "75%")
                fillExample(percentage: 1.0, title: "100%")
            }
            
            Text("Индикатор в виде белой точки показывает наличие подкатегорий")
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Индикатор подкатегорий
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 100, height: 100)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .offset(x: 0, y: -35)
                
                Text("Индикатор")
                    .font(.caption)
                    .offset(y: 50)
            }
            .padding(.vertical)
        }
    }
    
    // Пример заполнения сектора
    private func fillExample(percentage: Double, title: String) -> some View {
        let model = PieModel(fillPercentage: percentage, color: .blue, title: title)
        let sliceData = UniversalPieSliceData(
            model: model,
            startAngle: 0,
            endAngle: 90
        )
        
        return VStack {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .shadow(radius: 1)
                    .frame(width: 60, height: 60)
                
                UniversalPieSlice(slice: sliceData)
                    .frame(width: 50, height: 50)
            }
            
            Text(title)
                .font(.caption)
        }
    }
    
    // Создание ViewModel для диаграммы
    private func createViewModel() -> UniversalPieChartViewModel {
        let viewModel = UniversalPieChartViewModel()
        
        // Создаем вложенные модели
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
        
        // Основные категории
        let models = [
            PieModel(fillPercentage: 0.25, subModels: subModels1, color: .red, title: "Категория 1"),
            PieModel(fillPercentage: 0.50, subModels: subModels2, color: .blue, title: "Категория 2"),
            PieModel(fillPercentage: 0.75, color: .green, title: "Категория 3"),
            PieModel(fillPercentage: 1.00, color: .orange, title: "Категория 4")
        ]
        
        viewModel.models = models
        return viewModel
    }
}

struct EnhancedPieChartDemo_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedPieChartDemo()
    }
} 