//
//  UserPostService.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/9/26.
//
//
//
import Foundation
import PhotosUI
import _PhotosUI_SwiftUI
import SwiftUI

final class UserPostService {

    static let shared = UserPostService()

    private let baseURL = URL(string: "https://fescenter.org/test/wp-json/wp/v2/")!
    private let session: URLSession
    private let authHeader: String?

    private init() {
        self.session = .shared
        let username = "fescenter"
        let appPassword = "4ttm xLpg zN0K m7Gy 0CBR I46P"
        let credentials = "\(username):\(appPassword)"
        self.authHeader = "Basic \(Data(credentials.utf8).base64EncodedString())"
    }

    // MARK: - Create Post
    func createPost(
        authorUUID: String,
        text: String?,
        mediaIDs: [Int]
    ) async throws -> AppPost {

        let url = baseURL.appendingPathComponent("app_posts")
        print("📡 Creating post at:", url.absoluteString)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if let authHeader {
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        }

        // 🔑 ACF TEXT FIELD → STRING OR ""
        let mediaIDsString = mediaIDs
            .map(String.init)
            .joined(separator: ",")

        let body: [String: Any] = [
            "status": "publish",
            "title": "App Post",
            "content": text ?? "",
            "acf": [
                "uuid": UUID().uuidString,
                "author_uuid": authorUUID,
                "text_content": text ?? "",
                "media_ids": mediaIDsString,   // ✅ STRING
                "like_count": "0",             // keep as string if ACF text
                "comment_count": "0",
                "created_at": ISO8601DateFormatter().string(from: Date())
            ]
        ]

        let jsonData = try JSONSerialization.data(withJSONObject: body)
        if let jsonStr = String(data: jsonData, encoding: .utf8) {
            print("📄 Post body JSON:", jsonStr)
        }

        request.httpBody = jsonData

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        let responseBody = String(data: data, encoding: .utf8) ?? "No body"
        print("📄 Create Post Response:", http.statusCode, responseBody)

        guard (200...299).contains(http.statusCode) else {
            throw NSError(
                domain: "CreatePost",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: responseBody]
            )
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(AppPost.self, from: data)
    }

    
    // MARK: - Fetch Posts
    func fetchPosts() async throws -> [AppPost] {
        var components = URLComponents(url: baseURL.appendingPathComponent("app_posts"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "per_page", value: "95"),
            URLQueryItem(name: "_ts", value: String(Int(Date().timeIntervalSince1970)))
        ]
        guard let url = components.url else { throw URLError(.badURL) }

        print("📡 Fetching posts from:", url.absoluteString)
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "No body"
            print("❌ Fetch Posts Failed:", http.statusCode, body)
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let isoFormatter = ISO8601DateFormatter()
            if let date = isoFormatter.date(from: dateStr) { return date }

            // fallback: "yyyy-MM-dd HH:mm:ss"
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = fallbackFormatter.date(from: dateStr) { return date }

            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date string: \(dateStr)")
        }

        return try decoder.decode([AppPost].self, from: data)
    }


    // MARK: - Upload Media
    func uploadMedia(item: PhotosPickerItem) async throws -> Int {
        guard let data = try await item.loadTransferable(type: Data.self) else {
            throw URLError(.cannotDecodeContentData)
        }

        let url = baseURL.appendingPathComponent("media")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.addValue(authHeader!, forHTTPHeaderField: "Authorization")
        
        // WordPress requires a filename in Content-Disposition
        let filename = "upload-\(UUID().uuidString).jpg"
        request.addValue("attachment; filename=\"\(filename)\"", forHTTPHeaderField: "Content-Disposition")

        let (responseData, response) = try await session.upload(for: request, from: data)
        
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(http.statusCode) else {
            let body = String(data: responseData, encoding: .utf8) ?? "No body"
            print("❌ Media upload failed:", http.statusCode, body)
            throw NSError(domain: "UploadMedia", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: body])
        }

        let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any]
        guard let id = json?["id"] as? Int else {
            throw NSError(domain: "UploadMedia", code: 0, userInfo: [NSLocalizedDescriptionKey: "No media ID returned"])
        }
        return id
    }



    // MARK: - Likes
    func likePost(postUUID: String, userUUID: String) async throws {
        // TODO: Implement with app_post_likes CPT
        print("👍 Like post:", postUUID, "by:", userUUID)
    }

    // MARK: - Comments
    func createComment(postUUID: String, userUUID: String, text: String) async throws {
        // TODO: Implement with app_post_comments CPT
        print("💬 Comment on:", postUUID, "by:", userUUID)
    }
}
