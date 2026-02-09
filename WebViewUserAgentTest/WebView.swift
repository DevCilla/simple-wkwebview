//
//  WebView.swift
//  WebViewUserAgentTest
//
//  Created by Cilla on 23/1/2026.
//  added remote repository on 09/02/2026
//
import SwiftUI
import WebKit

final class WebViewStore: ObservableObject {
    let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        //config.applicationNameForUserAgent = "myDemoWKWebView"

        let wv = WKWebView(frame: .zero, configuration: config)
        if #available(iOS 16.4, *) { wv.isInspectable = true }
        return wv
    }()
}

struct WebView: UIViewRepresentable {
    let webView: WKWebView
    @Binding var address: String

    func makeCoordinator() -> Coordinator {
        Coordinator(address: $address)
    }

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }

    final class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var address: String

        init(address: Binding<String>) {
            _address = address
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let urlString = webView.url?.absoluteString else { return }
            DispatchQueue.main.async {
                self.address = urlString
            }
        }
    }
}
