import SwiftUI

struct PieModel: Identifiable {
    let id = UUID()
    /// Общее значение модели (для определения относительного размера секции)
    /// Если все секции должны быть равного размера, это значение у всех одинаковое
    let totalValue: Double
    /// Процент заполнения конкретной секции (от 0 до 1)
    let fillPercentage: Double
    /// Дочерние модели
    let subModels: [PieModel]?
    /// Цвет для модели
    let color: Color
    /// Название модели
    let title: String
    
    /// Вычисляет заполнение секции в процентах (0-100)
    var fillPercentageValue: Double {
        return fillPercentage * 100
    }
    
    /// Проверяет наличие дочерних моделей
    var hasSubModels: Bool {
        return subModels != nil && !subModels!.isEmpty
    }
    
    /// Создает PieModel с процентным заполнением
    init(totalValue: Double = 1.0, fillPercentage: Double, subModels: [PieModel]? = nil, color: Color, title: String) {
        self.totalValue = totalValue
        self.fillPercentage = max(0, min(1, fillPercentage)) // Ограничиваем значение от 0 до 1
        self.subModels = subModels
        self.color = color
        self.title = title
    }
} 