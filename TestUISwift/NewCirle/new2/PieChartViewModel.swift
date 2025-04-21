import SwiftUI
import Combine

enum PieChartDisplayMode {
    case categories
    case subCategories(Category)
    case subSubCategories(SubCat)
    case subSubSubCategories(SubSubCat)
}

class PieChartViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var displayMode: PieChartDisplayMode = .categories
    
    // Текущий массив элементов для отображения, зависит от displayMode
    var currentItems: [Any] {
        switch displayMode {
        case .categories:
            return categories
        case .subCategories(let category):
            return category.subCat ?? []
        case .subSubCategories(let subCat):
            return subCat.subSubCat ?? []
        case .subSubSubCategories(let subSubCat):
            return subSubCat.subSubSubCat ?? []
        }
    }
    
    // Текущий заголовок диаграммы
    var currentTitle: String {
        switch displayMode {
        case .categories:
            return "Все категории"
        case .subCategories(let category):
            return category.title
        case .subSubCategories(let subCat):
            return subCat.title
        case .subSubSubCategories(let subSubCat):
            return subSubCat.title
        }
    }
    
    // Общий процент заполнения для текущего отображения
    var totalFillPercentage: Double {
        switch displayMode {
        case .categories:
            // Среднее заполнение всех категорий
            let totalValues = categories.reduce(0.0) { $0 + $1.totalValue }
            let currentValues = categories.reduce(0.0) { $0 + $1.currentValue }
            return totalValues > 0 ? (currentValues / totalValues) * 100 : 0
            
        case .subCategories(let category):
            guard let subCats = category.subCat, !subCats.isEmpty else {
                return category.fillPercentage
            }
            
            let totalValues = subCats.reduce(0.0) { $0 + $1.totalValue }
            let currentValues = subCats.reduce(0.0) { $0 + $1.currentValue }
            return totalValues > 0 ? (currentValues / totalValues) * 100 : 0
            
        case .subSubCategories(let subCat):
            guard let subSubCats = subCat.subSubCat, !subSubCats.isEmpty else {
                return subCat.fillPercentage
            }
            
            let totalValues = subSubCats.reduce(0.0) { $0 + $1.totalValue }
            let currentValues = subSubCats.reduce(0.0) { $0 + $1.currentValue }
            return totalValues > 0 ? (currentValues / totalValues) * 100 : 0
            
        case .subSubSubCategories(let subSubCat):
            guard let subSubSubCats = subSubCat.subSubSubCat, !subSubSubCats.isEmpty else {
                return subSubCat.fillPercentage
            }
            
            let totalValues = subSubSubCats.reduce(0.0) { $0 + $1.totalValue }
            let currentValues = subSubSubCats.reduce(0.0) { $0 + $1.currentValue }
            return totalValues > 0 ? (currentValues / totalValues) * 100 : 0
        }
    }
    
    // Действие при нажатии на центр диаграммы - возврат к предыдущему уровню
    func onCenterTapped() {
        switch displayMode {
        case .subCategories:
            displayMode = .categories
        case .subSubCategories:
            if case let .subSubCategories(subCat) = displayMode,
               case let .subCategories(category) = findParentDisplayMode(of: subCat) {
                displayMode = .subCategories(category)
            }
        case .subSubSubCategories:
            if case let .subSubSubCategories(subSubCat) = displayMode,
               case let .subSubCategories(subCat) = findParentDisplayMode(of: subSubCat) {
                displayMode = .subSubCategories(subCat)
            }
        default:
            break
        }
    }
    
    // Действие при нажатии на сегмент диаграммы
    func onSegmentTapped(_ item: Any) {
        if let category = item as? Category {
            if let subCats = category.subCat, !subCats.isEmpty {
                displayMode = .subCategories(category)
            }
        } else if let subCat = item as? SubCat {
            if let subSubCats = subCat.subSubCat, !subSubCats.isEmpty {
                displayMode = .subSubCategories(subCat)
            }
        } else if let subSubCat = item as? SubSubCat {
            if let subSubSubCats = subSubCat.subSubSubCat, !subSubSubCats.isEmpty {
                displayMode = .subSubSubCategories(subSubCat)
            }
        }
    }
    
    // Вспомогательный метод для поиска родительского displayMode
    private func findParentDisplayMode(of subCat: SubCat) -> PieChartDisplayMode {
        for category in categories {
            if let subCats = category.subCat, subCats.contains(where: { $0.id == subCat.id }) {
                return .subCategories(category)
            }
        }
        return .categories
    }
    
    private func findParentDisplayMode(of subSubCat: SubSubCat) -> PieChartDisplayMode {
        for category in categories {
            if let subCats = category.subCat {
                for subCat in subCats {
                    if let subSubCats = subCat.subSubCat, subSubCats.contains(where: { $0.id == subSubCat.id }) {
                        return .subSubCategories(subCat)
                    }
                }
            }
        }
        return .categories
    }
} 