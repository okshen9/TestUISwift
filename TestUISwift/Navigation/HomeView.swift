//
//  HomeView.swift
//  TestUISwift
//
//  Created by artem on 27.03.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack {
            Button("К деталям") {
                navigationManager.navigate(to: .detail(itemId: 42))
            }
            Button("К настройкам") {
                navigationManager.navigate(to: .settings)
            }
            Button("К логину") {
                navigationManager.replace(with: .login) // Замена стека
            }
            Button("Fykjuby") {
                navigationManager.replace(with: .unlogin)
            }
            Button("Home") {
                navigationManager.replace(with: .home)
            }
        }
        .navigationTitle("Главная")
    }
}

struct DetailView: View {
    let itemId: Int
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack {
            Text("Детали для элемента \(itemId)")
            Button("Назад") {
                navigationManager.pop()
            }
        }
        .navigationTitle("Детали")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Настройки")
            .navigationTitle("Настройки")
    }
}

struct LoginView: View {
    var body: some View {
        Text("Экран логина")
            .navigationTitle("Вход")
    }
}

struct UnloginView: View {
    var body: some View {
        Text("Экран неавторизованного доступа")
            .navigationTitle("Неавторизованный доступ")
    }
}
