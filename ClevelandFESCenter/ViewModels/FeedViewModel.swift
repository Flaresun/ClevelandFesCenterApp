//
//  FeedVie.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/9/26.
//

import Foundation
import SwiftData
internal import Combine
@MainActor
final class FeedViewModel: ObservableObject {
    @Published var posts: [AppPost] = []
    @Published var usersByUUID: [String: AppUser] = [:]
    @Published var isLoading = false

    func reloadFeed() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let users = try await UserService.shared.fetchUsers()
            usersByUUID = Dictionary(uniqueKeysWithValues: users.map { ($0.uuid, $0) })

            var fetchedPosts = try await UserPostService.shared.fetchPosts()
            fetchedPosts.sort { $0.createdAt > $1.createdAt }

            posts = fetchedPosts
            print("✅ Reloaded \(posts.count) posts")

        } catch {
            print("❌ Failed to reload feed:", error)
        }
    }

    func user(for post: AppPost) -> AppUser? {
        usersByUUID[post.authorUUID]
    }
}
