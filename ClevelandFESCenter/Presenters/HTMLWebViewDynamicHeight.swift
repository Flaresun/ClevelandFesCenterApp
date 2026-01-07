//
//  HTMLWebViewDynamicHeight.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//
import SwiftUI
import WebKit

struct HTMLWebViewDynamicHeight: UIViewRepresentable {
    let html: String
    @State private var height: CGFloat = .zero

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false // Important
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let styledHTML = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body {
                font-family: -apple-system;
                font-size: 17px;
                line-height: 1.5;
                margin: 0;
                padding: 0;
            }
            iframe, img {
                max-width: 100%;
                height: auto;
            }
        </style>
        </head>
        <body>
        \(html)
        </body>
        </html>
        """
        webView.loadHTMLString(styledHTML, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLWebViewDynamicHeight
        init(parent: HTMLWebViewDynamicHeight) { self.parent = parent }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.scrollHeight") { (height, _) in
                if let h = height as? CGFloat {
                    DispatchQueue.main.async {
                        self.parent.height = h
                    }
                }
            }
        }
    }
}
