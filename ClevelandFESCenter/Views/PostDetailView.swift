//
//  PostDetailView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//

import SwiftUI
import WebKit

struct PostDetailView: View {
    let post: WPPost

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(stripHTML(post.title.rendered))
                    .font(.title2)
                    .bold()

                // Date
                Text(formatDate(post.date))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Divider()

                // HTML content in WKWebView
                HTMLWebViewDynamicHeight(html: post.content.rendered)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    func stripHTML(_ html: String) -> String {
        html
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func formatDate(_ dateStr: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: dateStr) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return dateStr
    }
}
