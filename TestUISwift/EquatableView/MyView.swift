//
//  MyView.swift
//  TestUISwift
//
//  Created by artem on 10.03.2025.
//


import SwiftUI

struct MyEquatableView: Equatable, View {
    let value: Int
    let name: String

    static func == (lhs: MyEquatableView, rhs: MyEquatableView) -> Bool {
        return lhs.value == rhs.value
    }

    var body: some View {
        Text("Value: \(value)")
        Text("name: \(name)")
    }
}
