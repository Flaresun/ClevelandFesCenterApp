//
//  HTMLWebView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//

import SwiftUI
import WebKit

struct HTMLWebView: UIViewRepresentable {
    let html: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
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
                padding: 0;
                margin: 0;
            }
            iframe {
                max-width: 100%;
            }
            img {
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
}
