//
//  WebView.swift
//  TestUISwift
//
//  Created by artem on 25.03.2025.
//

import WebKit
import SwiftUI

// MARK: - WebView
struct WebView: UIViewRepresentable {
    let url: URL
    private weak var navigationDelegate: WKNavigationDelegate?
    private weak var uiDelegate: WKUIDelegate?

    init(url: URL, navigationDelegate: WKNavigationDelegate? = nil, uiDelegate: WKUIDelegate? = nil) {
        self.url = url
        self.navigationDelegate = navigationDelegate
        self.uiDelegate = uiDelegate
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = navigationDelegate
        webView.uiDelegate = uiDelegate
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {

    }
}
