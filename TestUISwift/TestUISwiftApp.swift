//
//  TestUISwiftApp.swift
//  TestUISwift
//
//  Created by artem on 27.11.2024.
//

import SwiftUI

@main
struct TestUISwiftApp: App {
    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationManager.path) {
                Image(.callkitIconVkteams)
                Image(.icQrCode)
                HomeView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .home:
                            HomeView()
                        case .detail(let itemId):
                            DetailView(itemId: itemId)
                        case .settings:
                            SettingsView()
                        case .login:
                            LoginView()
                        case .unlogin:
                            UnloginView()
                        }
                    }
            }
            .environmentObject(navigationManager)
        }
    }
}
