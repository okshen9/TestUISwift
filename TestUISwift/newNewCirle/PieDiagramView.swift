////
////  PieDiagramView.swift
////  TestUISwift
////
////  Created by artem on 21.04.2025.
////
//
//import SwiftUI
//
//
//struct PieDiagramView: View {
//    let categories: [Category]
//    @State private var navigationStack: [any ChartItem] = []
//    
//    var currentLevelItems: [any ChartItem] {
//        navigationStack.last?.subItems ?? categories.map { $0 }
//    }
//    
//    var body: some View {
//        VStack {
//            PieChart(
//                items: currentLevelItems,
//                centerText: navigationStack.last?.title ?? "Total",
//                currentPercentage: calculatePercentage(),
//                onSegmentTap: { item in
//                    if item.subItems?.isEmpty == false {
//                        navigationStack.append(item)
//                    }
//                },
//                onCenterTap: {
//                    if !navigationStack.isEmpty {
//                        navigationStack.removeLast()
//                    }
//                }
//            )
//            .frame(width: 300, height: 300)
//        }
//    }
//    
//    private func calculatePercentage() -> Double {
//        let total = currentLevelItems.reduce(0) { $0 + $1.totalValue }
//        let current = currentLevelItems.reduce(0) { $0 + $1.currentValue }
//        return (current / total) * 100
//    }
//}
//
//#Preview{
//    let categories = [
//        Category(
//            title: "Category 1",
//            color: .blue,
//            totalValue: 100,
//            currentValue: 60,
//            subCat: [
//                SubCat(
//                    title: "SubCat 1",
//                    color: .green,
//                    totalValue: 60,
//                    currentValue: 30,
//                    subSubCat: [
//                        SubSubCat(
//                            title: "SubSubCat 1",
//                            color: .orange,
//                            totalValue: 30,
//                            currentValue: 15,
//                            subSubSubCat: nil
//                        )
//                    ]
//                )
//            ]
//        )
//    ]
//    return PieDiagramView(categories: categories)
//}
