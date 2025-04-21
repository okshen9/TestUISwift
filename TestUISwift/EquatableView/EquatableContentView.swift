//
//  EquatableContentView.swift
//  TestUISwift
//
//  Created by artem on 10.03.2025.
//

import Foundation
import SwiftUI


struct EquatableContentView: View {
    @State private var text: String = "Hello, World!"
    @State private var backgroundColor: Color = .blue
    @State private var value: Int = 0
    @State private var counter: Int = 0

    var body: some View {
        VStack {
            // Используем EquatableView для оптимизации
            EquatableView(content: MyEquatableView(value: value, name: text))

            Button("Change Text") {
                text = "Text changed \(counter)"
                counter += 1
            }

            Button("Change Background") {
                backgroundColor = [.red, .green, .yellow, .orange].randomElement()!
                value += 1
            }

            Text("Counter: \(counter)")
        }
        .padding()
    }
    
//    func netWorkTest(_ complite: @escaping (Result<Int, MyError>)) -> Void {
//        
//    }
}

enum MyError: Error {
    case some
}
