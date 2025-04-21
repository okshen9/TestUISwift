//
//  CustomWrapper.swift
//  TestUISwift
//
//  Created by artem on 04.03.2025.
//

import SwiftUI
import Combine

extension Binding {
    init(_ source: Binding<Value?>, default defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}

extension Binding {
    func orDefault<T>(_ defaultValue: T) -> Binding<T> where Value == Optional<T> {
        return Binding<T>.init(
            get: { self.wrappedValue.self ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
