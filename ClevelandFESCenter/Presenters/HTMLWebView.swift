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
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = true 
        return webView
    }


    func updateUIView(_ webView: WKWebView, context: Context) {
        let wrappedHTML = wrapHTML(html)
        webView.loadHTMLString(wrappedHTML, baseURL: nil)
    }

    private func wrapHTML(_ body: String) -> String {
        """
        <!doctype html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body {
                    font-family: -apple-system;
                    font-size: 16px;
                    line-height: 1.6;
                    padding: 0;
                    margin: 0;
                }
                img, iframe {
                    max-width: 100%;
                    height: auto;
                }
                iframe {
                    aspect-ratio: 16 / 9;
                }
            </style>
        </head>
        <body>
            \(stripVCShortcodes(body))
        </body>
        </html>
        """
    }

    private func stripVCShortcodes(_ html: String) -> String {
        html.replacingOccurrences(
            of: "\\[[^\\]]+\\]",
            with: "",
            options: .regularExpression
        )
    }
}
