//
//  AuthSUIViewModel.swift
//  TestUISwift
//
//  Created by artem on 25.03.2025.
//

import Foundation
import Combine
import SwiftUI
import WebKit

// MARK: - ViewModel
final class AuthSUIViewModel: NSObject, ObservableObject {
    @Published var showWebView = false

//    private let service = ServiceBuilder()

    func validateWebRequest(url: URL?) -> String? {
        guard let urlString = url?.absoluteString,
              let range = urlString.range(of: Constants.tgAuthResult) else { return nil }

        return String(urlString[range.upperBound...])
    }

//    func telegramCallBack(tgKey: String) {
//        Task {
//            let authQueryModel = AuthQueryModel(tgData: tgKey)
//            guard let result = await getAuthProfile(authQueryModel: authQueryModel) else { return }
//
//            await MainActor.run {
////                UserRepository.shared.setAuthUser(result)
//                handleNavigation(for: result.authUserDto)
//            }
//        }
//    }
//
//    private func handleNavigation(for user: AuthUserDtoResult?) {
//        guard let user else { return }
//
//        let roles = user.roles ?? []
//        if roles.contains(.admin) || roles.contains(.user) {
//            // Navigate to main
//        } else {
//            // Navigate to user form
//        }
//    }
//
//    private func getAuthProfile(authQueryModel: AuthQueryModel) async -> AuthTGRequestModel? {
//        // Implementation
//    }
}


extension AuthSUIViewModel: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           let tgKey = validateWebRequest(url: url) {
            //                viewModel.telegramCallBack(tgKey: tgKey)
            print("Uspech")
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.isHidden = true
        webView.endEditing(true)
        withAnimation {
            showWebView = false
        }
    }
}


extension AuthSUIViewModel {
    enum Constants {
        static let queryParamQuestion = "#"
        static let tgAuthResult = "tgAuthResult="
    }
}
