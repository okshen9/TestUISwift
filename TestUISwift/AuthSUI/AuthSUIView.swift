//
//  AuthSUIView.swift
//  TestUISwift
//
//  Created by artem on 25.03.2025.
//

import SwiftUI
import WebKit

struct AuthSUIView: View {
    @StateObject private var viewModel = AuthSUIViewModel()

    @State private var showTerms = false
    @State private var showPrivacy = false

    var body: some View {
        ZStack {
            Color.blue.opacity(0.1)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                if !viewModel.showWebView {
                    Image("man")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(4)
                        .padding(.top, 80)

                    Spacer()
                }
                contentView
            }

            if viewModel.showWebView {
                WebView(url: URL(string: Constant.tgBotdev)!,
                        navigationDelegate: viewModel,
                        uiDelegate: viewModel)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
            }
        }
        .sheet(isPresented: $showTerms, content: {
            WebView(url: URL(string: "https://paymastermind.ru/privacy")!)
        })
    }

    private var contentView: some View {
        VStack(spacing: 16) {
            Text("Добро Пожаловать")
                .font(.system(size: 18, weight: .bold))
            //TODO
                .foregroundColor(.black)

            telegramButton

            Spacer()

            LinkedText(
                text: "Продолжая пользование приложением, я соглашаюсь с Порядком и условиями обработки персональных данных и Политикой конфиденциальности компании",
                links: [
                    "Порядком и условиями обработки персональных данных": .terms,
                    "Политикой конфиденциальности компании": .privacy
                ],
                action: { linkType in
                    switch linkType {
                    case .terms: showTerms = true
                    case .privacy: showPrivacy = true
                    }
                }
            )
//            .onTapGesture {
//                showTerms = true
//            }
            .font(.system(size: 12))
            //TODO
            .foregroundColor(.black)
//            .foregroundColor(.subtitleText)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
        .padding()
        // TODO
        .background(Color.blue.opacity(0.1))
//        .background(Color.secondbackGraund)
        .cornerRadius(20)
        .padding(.horizontal)
    }

    private var telegramButton: some View {
        Button(action: {
            withAnimation {
                viewModel.showWebView = true
            }
        }) {
            HStack {
                Image(.tg)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(4)

                Text("Войти через Telegram")
                    .foregroundColor(.primary)
            }
            .padding()
//            .background(Color.tgColor)
            .background(Color.blue)
            .cornerRadius(16)
        }
    }
}

extension AuthSUIView {
    enum Constant {
        static let tgImageWidth = CGFloat(32)
        static let tgBotdev = "https://oauth.telegram.org/auth?bot_id=7585753405&origin=https%3A%2F%2Fappmastermind.ru&embed=1&return_to=http%3A%2F%2Fappmastermind.ru%2Fauth%2Fauthentication"
    }
}

#Preview {
    AuthSUIView()
}
