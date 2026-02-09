//
//  ContentView.swift
//  WebViewUserAgentTest
//
//  Created by Cilla on 23/1/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = WebViewStore()
    @State private var address = "https://www.google.com"

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text("URL:")
                    .font(.body)

                TextField("Enter URL", text: $address)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
                    .submitLabel(.go)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .onSubmit { loadAddress() }

                Button("Go") { loadAddress() }
            }
            .padding()
            .background(.ultraThinMaterial)

            WebView(webView: store.webView, address: $address)
                .ignoresSafeArea(edges: .bottom)
        }
        .onAppear { loadAddress() }
    }

    private func loadAddress() {
        var text = address.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty { return }

        // If user types "google.com", treat it as https://google.com
        if !text.contains("://") {
            text = "https://" + text
        }

        guard let url = URL(string: text) else { return }
        store.webView.load(URLRequest(url: url))
        address = text
    }
}

#Preview {
    ContentView()
}
