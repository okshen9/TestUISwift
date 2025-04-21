import SwiftUI
import Combine

class UniversalPieChartViewModel: ObservableObject {
    /// Стек для навигации по уровням моделей
    @Published var navigationStack: [PieModel] = []
    
    /// Модели верхнего уровня
    @Published var models: [PieModel] = []
    
    /// Текущие модели для отображения
    var currentModels: [PieModel] {
        if navigationStack.isEmpty {
            return models
        } else if let lastModel = navigationStack.last,
                  let subModels = lastModel.subModels {
            return subModels
        } else {
            return []
        }
    }
    
    /// Текущий заголовок диаграммы
    var currentTitle: String {
        if navigationStack.isEmpty {
            return "Все категории"
        } else if let lastModel = navigationStack.last {
            return lastModel.title
        } else {
            return "Диаграмма"
        }
    }
    
    /// Общий процент заполнения для текущего отображения
    var totalFillPercentage: Double {
        let models = currentModels
        guard !models.isEmpty else { 
            return navigationStack.last?.fillPercentageValue ?? 0 
        }
        
        // Вычисляем среднее арифметическое заполнения всех секций
        let sumFillPercentages = models.reduce(0.0) { $0 + $1.fillPercentage }
        return (sumFillPercentages / Double(models.count)) * 100
    }
    
    /// Уровень вложенности навигации (начиная с 0)
    var currentLevel: Int {
        return navigationStack.count
    }
    
    /// Действие при нажатии на центр диаграммы - возврат к предыдущему уровню
    func onCenterTapped() {
        if !navigationStack.isEmpty {
            // Удаляем последний элемент из стека навигации
            _ = navigationStack.popLast()
        }
    }
    
    /// Действие при нажатии на сегмент диаграммы
    func onSegmentTapped(_ model: PieModel) {
        if model.hasSubModels {
            // Добавляем модель в стек навигации
            navigationStack.append(model)
        }
    }
    
    /// Навигация к конкретному индексу в стеке навигации
    /// Например, при нажатии на элемент хлебных крошек
    func navigateToIndex(_ index: Int) {
        guard index >= 0 && index < navigationStack.count else { return }
        
        // Обрезаем стек навигации до указанного индекса (включительно)
        navigationStack = Array(navigationStack.prefix(index + 1))
    }
    
    /// Получить родительскую модель для текущего уровня
    func getParentModel() -> PieModel? {
        guard navigationStack.count > 1 else {
            return nil
        }
        return navigationStack[navigationStack.count - 2]
    }
    
    /// Сбросить навигацию и вернуться на верхний уровень
    func resetNavigation() {
        navigationStack = []
    }
    
    /// Получить путь навигации в виде текста
    func getNavigationPath() -> String {
        let titles = navigationStack.map { $0.title }
        if titles.isEmpty {
            return "Главная"
        } else {
            return titles.joined(separator: " > ")
        }
    }
} 