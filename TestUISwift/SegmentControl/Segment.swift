//
//  Segment.swift
//  TestUISwift
//
//  Created by artem on 19.04.2025.
//

import SwiftUI

struct Segment: View {
    var lineColor: Color = .black
    let nameSegment: String
//    @Binding var isSelected: Bool
    var body: some View {
        VStack {
            Text(nameSegment)
            lineColor
                .frame(width: .infinity, height: 2)
//                .opacity(isSelected ? 1 : 0)
        }
    }
}

#Preview {
    Segment(nameSegment: "test")//, isSelected: .constant(true))
}
