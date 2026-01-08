//
//  PostListView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//

import SwiftUI

struct PostListView: View {
    @State private var posts: [WPPost] = []
    @State private var errorMessage: String?

    var body: some View {
        List {
            if let errorMessage {
                Text("Error loading posts: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if posts.isEmpty {
                Text("Loading posts…")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(posts) { post in
                    NavigationLink {
                        PostDetailView(post: post)
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            // Featured Image
                            if let featuredID = post.featuredMedia {
                                AsyncFeaturedImage(mediaID: featuredID)
                                    .frame(width: 100, height: 80)
                                    .cornerRadius(8)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 100, height: 80)
                                    .cornerRadius(8)
                            }

                            // Right VStack
                            VStack(alignment: .leading, spacing: 4) {
                                Text(formatDate(post.date))
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text(stripHTML(post.title.rendered))
                                    .font(.headline)
                                    .lineLimit(2)

                                Text(getCategoryNames(post: post).joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text(cleanExcerpt(post.excerpt.rendered))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .navigationTitle("News & Updates")
        .task {
            do {
                posts = try await PostService.shared.fetchPosts()
            } catch {
                print("Error fetching posts:", error)
                errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Helpers

    func stripHTML(_ html: String) -> String {
        html
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func cleanExcerpt(_ html: String) -> String {
        var cleaned = html
        cleaned = cleaned.replacingOccurrences(of: "\\[[^\\]]+\\]", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "&hellip;", with: "…")
        cleaned = cleaned.replacingOccurrences(of: "&amp;", with: "&")
        cleaned = cleaned.replacingOccurrences(of: "&quot;", with: "\"")
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    let categoryMapping: [Int: String] = [
        34: "Art & Design", 2: "Awards", 3: "Cleveland FES Center", 46: "Clinical Trials",
        8: "Events", 7: "FES", 36: "International", 37: "Marketing", 9: "Neural Interface",
        1: "News", 45: "NP seminars", 4: "People", 44: "Press Release", 6: "Prosthetics",
        5: "Research", 32: "Seminars", 35: "Technology", 41: "Videos"
    ]

    func getCategoryNames(post: WPPost) -> [String] {
        post.categories.compactMap { categoryMapping[$0] }
    }

    func formatDate(_ isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: isoDate) {
            return formatToReadable(date)
        }

        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        customFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = customFormatter.date(from: isoDate) {
            return formatToReadable(date)
        }

        return isoDate
    }

    private func formatToReadable(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
