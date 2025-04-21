//
//  ObservableCustomWrapper.swift
//  TestUISwift
//
//  Created by artem on 04.03.2025.
//

import Foundation
import SwiftUI


/// Протокол для типов, у которых можно создать «пустой» экземпляр.
protocol EmptyInitializable {
    init()
}

// Поддерживаемые типы – массивы, строки и словари:
extension Array: EmptyInitializable {}
extension String: EmptyInitializable {}
extension Dictionary: EmptyInitializable {}

// Универсальное расширение для опциональных коллекций
extension Binding where Value == Optional<String> {
    
    
    
    /// Преобразует `Binding<Value?>` в `Binding<Value>`, заменяя `nil` на пустую коллекцию
    ///
    ///
    var orEmptyBinding: Binding<Value>{
        Binding<Value>(
            get: {
                self.wrappedValue ?? ""
                
            }, // Возвращает значение или пустую коллекцию
            
            set: {
                self.wrappedValue = $0
            } // Обновляет исходное значение
        )
    }
}


