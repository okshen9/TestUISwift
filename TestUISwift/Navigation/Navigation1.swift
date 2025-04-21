//
//  Navigation1.swift
//  TestUISwift
//
//  Created by artem on 27.03.2025.
//

import Foundation
import SwiftUI

struct ContentView1: View {
    @State private var path = NavigationPath()

        var body: some View {
            NavigationStack(path: $path) {
                VStack {
                    Button("Перейти к экрану 1") {
                        path.append(1) // Добавляем экран в стек
                    }
                    Button("Перейти к экрану 2") {
                        path.append(2)
                        path.append(1)
                    }
                }
                .navigationTitle("Главная")
                .navigationDestination(for: Int.self) { value in
                    Text("Экран \(value)")
                }
            }
        }
    }

#Preview {
    ContentView1()
        .environmentObject(NavigationManager())

}
