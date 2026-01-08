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

                Text(stripHTML(post.title.rendered))
                    .font(.title2)
                    .bold()

                Text(formatDate(post.date))
                    .font(.caption)
                    .foregroundColor(.secondary)

                HTMLWebView(html: post.content.rendered)
                    .frame(minHeight: 400)

            }
            .padding()
        }
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
    }

    func stripHTML(_ html: String) -> String {
        html
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func formatDate(_ isoDate: String) -> String {
        // Try ISO8601 with .withInternetDateTime first
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: isoDate) {
            return formatToReadable(date)
        }

        // Fallback: Use custom DateFormatter for "yyyy-MM-dd'T'HH:mm:ss"
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        customFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = customFormatter.date(from: isoDate) {
            return formatToReadable(date)
        }

        // Fallback: return original string if parsing fails
        return isoDate
    }

    // Helper to convert Date → human-readable string
    private func formatToReadable(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium   // e.g., "Sep 22, 2025"
        formatter.timeStyle = .short    // e.g., "10:55 AM"
        return formatter.string(from: date)
    }
}
