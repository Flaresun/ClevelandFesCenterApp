//
//  Untitled.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//

import Foundation

final class PostService {
    static let shared = PostService()
    private init() {}

    private let baseURL =
    "https://fescenter.org/test/wp-json/wp/v2/posts?per_page=100"

    func fetchPosts() async throws -> [WPPost] {
        let url = URL(string: baseURL)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([WPPost].self, from: data)
    }
}
