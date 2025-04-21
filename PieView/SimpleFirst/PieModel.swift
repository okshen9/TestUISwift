//
//  PieModel.swift
//  TestUISwift
//
//  Created by artem on 21.04.2025.
//


import SwiftUI

struct PieModel: Identifiable {
    let id = UUID()
    /// процент от общего значения Category
    var totalValue: Double
    /// текущее заполенение конкретной Category
    var currentvlue: Double
    /// дочерние модели
    var subModel: [PieModel]?
    /// цвет для модели
    var color: Color
    /// название модели
    var title: String
}
