//
//  PieChartExampleView.swift
//  TestUISwift
//
//  Created by artem on 15.04.2025.
//

import SwiftUI
import Charts


//struct PieChartExampleView: View {
//    let catData = PetData.catExample
//    let dogData = PetData.dogExamples
//    var catTotal: Double {
//        catData.reduce(0) { $0 + $1.population }
//    }
//
//    var dogTotal: Double {
//        dogData.reduce(0) { $0 + $1.population }
//    }
//
//    var data: [(type: String, amount: Double)] {
//        [(type: "cat", amount: catTotal),
//         (type: "dog", amount: dogTotal)
//        ]
//    }
//
//    var maxPet: String? {
//        data.max { $0.amount < $1.amount }?.type
//    }
//
//    var body: some View {
//        Chart(data, id: \.type) { dataItem in
//            SectorMark(angle: .value("Type", dataItem.amount),
//                       innerRadius: .ratio(0.5),
//                       angularInset: 1.5)
//                .cornerRadius(5)
//                .opacity(dataItem.type == maxPet ? 1 : 0.5)
//        }
//        .frame(height: 200)
//    }
//}
//
//#Preview {
//    PieChartExampleView()
//}
