//
//  NavigationManager.swift
//  TestUISwift
//
//  Created by artem on 27.03.2025.
//
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()

    func navigate(to route: Route) {
            path.append(route)
            print("Navigated to: \(route), Path: \(path)")
        }

        func pop() {
            if !path.isEmpty {
                path.removeLast()
                print("Popped, Path: \(path)")
            }
        }

        func popToRoot() {
            path = NavigationPath()
            print("Popped to root, Path: \(path)")
        }

        func replace(with route: Route) {
            path = NavigationPath([route])
            print("Replaced with: \(route), Path: \(path)")
        }
}
