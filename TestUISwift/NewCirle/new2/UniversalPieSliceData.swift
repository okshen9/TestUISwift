import SwiftUI

/// Данные для отображения сегмента круговой диаграммы
struct UniversalPieSliceData: Identifiable {
    /// Уникальный идентификатор сегмента
    let id = UUID()
    
    /// Модель данных для сегмента
    let model: PieModel
    
    /// Начальный угол сегмента (в градусах)
    let startAngle: Double
    
    /// Конечный угол сегмента (в градусах)
    let endAngle: Double
    
    /// Размер сегмента в градусах
    var degrees: Double {
        return endAngle - startAngle
    }
    
    /// Средний угол сегмента (для размещения меток)
    var midAngle: Double {
        return (startAngle + endAngle) / 2
    }
    
    /// Создает новый экземпляр данных сегмента
    /// - Parameters:
    ///   - model: Модель данных сегмента
    ///   - startAngle: Начальный угол в градусах
    ///   - endAngle: Конечный угол в градусах
    init(model: PieModel, startAngle: Double, endAngle: Double) {
        self.model = model
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
} 