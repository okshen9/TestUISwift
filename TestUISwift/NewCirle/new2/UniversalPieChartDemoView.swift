import SwiftUI

struct UniversalPieChartDemoView: View {
    @StateObject private var viewModel = UniversalPieChartViewModel()
    @State private var useEnhancedVersion = true
    @State private var showNavigationPath = true
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Универсальная Pie Chart")
                .font(.title)
                .padding(.top)
            
            if showNavigationPath {
                Text(viewModel.getNavigationPath())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
            
            if useEnhancedVersion {
                EnhancedUniversalPieChartView(viewModel: viewModel)
                    .frame(height: 300)
                    .padding()
            } else {
                UniversalPieChartView(viewModel: viewModel)
                    .frame(height: 300)
                    .padding()
            }
            
            Text("Уровень вложенности: \(viewModel.currentLevel)")
                .font(.headline)
            
            Text("Заполнение: \(String(format: "%.1f%%", viewModel.totalFillPercentage))")
                .font(.subheadline)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Инструкция:")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack(alignment: .top) {
                    Image(systemName: "1.circle.fill")
                        .foregroundColor(.blue)
                    
                    Text("Нажмите на сегмент, чтобы перейти к его подкатегориям (если они есть)")
                        .font(.caption)
                }
                .padding(.horizontal)
                
                HStack(alignment: .top) {
                    Image(systemName: "2.circle.fill")
                        .foregroundColor(.blue)
                    
                    Text("Нажмите на центр, чтобы вернуться на уровень выше")
                        .font(.caption)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.resetNavigation()
                    }
                }) {
                    Text("На главную")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    withAnimation {
                        setupDemoData()
                    }
                }) {
                    Text("Обновить данные")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.bottom)
            
            HStack {
                Toggle("Расширенная версия", isOn: $useEnhancedVersion)
                Toggle("Путь навигации", isOn: $showNavigationPath)
            }
            .padding(.horizontal, 32)
            .padding(.bottom)
        }
        .onAppear {
            setupDemoData()
        }
    }
    
    private func setupDemoData() {
        // Создаем данные с различной вложенностью для демонстрации
        
        // Уровень 4 (самый глубокий)
        let level4Models = [
            PieModel(totalValue: 25, fillPercentage: 15, subModels: nil, color: .orange, title: "Детализация A"),
            PieModel(totalValue: 35, fillPercentage: 10, subModels: nil, color: .yellow, title: "Детализация B"),
            PieModel(totalValue: 40, fillPercentage: 30, subModels: nil, color: .pink, title: "Детализация C")
        ]
        
        // Уровень 3
        let level3Models1 = [
            PieModel(totalValue: 60, fillPercentage: 30, subModels: level4Models, color: .green, title: "Подгруппа A-1"),
            PieModel(totalValue: 40, fillPercentage: 25, subModels: nil, color: .mint, title: "Подгруппа A-2")
        ]
        
        let level3Models2 = [
            PieModel(totalValue: 70, fillPercentage: 40, subModels: nil, color: .teal, title: "Подгруппа B-1"),
            PieModel(totalValue: 30, fillPercentage: 20, subModels: nil, color: .cyan, title: "Подгруппа B-2")
        ]
        
        // Уровень 2
        let level2Models1 = [
            PieModel(totalValue: 55, fillPercentage: 35, subModels: level3Models1, color: .blue, title: "Группа A"),
            PieModel(totalValue: 45, fillPercentage: 20, subModels: level3Models2, color: .indigo, title: "Группа B")
        ]
        
        let level2Models2 = [
            PieModel(totalValue: 35, fillPercentage: 25, subModels: nil, color: .purple, title: "Группа C"),
            PieModel(totalValue: 65, fillPercentage: 45, subModels: nil, color: .pink, title: "Группа D")
        ]
        
        // Корневой уровень
        let rootModels = [
            PieModel(totalValue: 40, fillPercentage: 20, subModels: level2Models1, color: .red, title: "Категория 1"),
            PieModel(totalValue: 35, fillPercentage: 25, subModels: level2Models2, color: .blue, title: "Категория 2"),
            PieModel(totalValue: 25, fillPercentage: 15, subModels: nil, color: .green, title: "Категория 3")
        ]
        
        // Устанавливаем данные в модель
        viewModel.models = rootModels
        
        // Сбрасываем навигацию
        viewModel.resetNavigation()
    }
}

struct UniversalPieChartDemoView_Previews: PreviewProvider {
    static var previews: some View {
        UniversalPieChartDemoView()
    }
} 
