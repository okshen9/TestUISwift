import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    /// процент от общего значения Category
    let totalValue: Double
    /// текущее заполенение конкретной Category
    let currentValue: Double
    let subCat: [SubCat]?
    let color: Color
    let title: String
    
    var fillPercentage: Double {
        return currentValue / totalValue * 100
    }
}

struct SubCat: Identifiable {
    let id = UUID()
    /// процент от общего значения всех SubCat
    let totalValue: Double
    /// текущее заполенение конкретной SubCat
    let currentValue: Double
    let subSubCat: [SubSubCat]?
    let color: Color
    let title: String
    
    var fillPercentage: Double {
        return currentValue / totalValue * 100
    }
}

struct SubSubCat: Identifiable {
    let id = UUID()
    /// процент от общего значения SubSubCat
    let totalValue: Double
    /// текущее заполенение конкретной SubSubCat
    let currentValue: Double
    let subSubSubCat: [SubSubSubCat]?
    let color: Color
    let title: String
    
    var fillPercentage: Double {
        return currentValue / totalValue * 100
    }
}

struct SubSubSubCat: Identifiable {
    let id = UUID()
    /// процент от общего значения SubSubSubCat
    let totalValue: Double
    /// текущее заполенение конкретной SubSubSubCat
    let currentValue: Double
    let color: Color
    let title: String
    
    var fillPercentage: Double {
        return currentValue / totalValue * 100
    }
} 