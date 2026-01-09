//
//  AppPost.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/9/26.
//


import Foundation

struct AppPost: Codable, Identifiable {
    let id: Int
    let uuid: String
    let authorUUID: String
    let title: String?
    let textContent: String?
    let mediaIDs: [Int]
    let likeCount: Int
    let commentCount: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case acf
    }

    enum ACFKeys: String, CodingKey {
        case uuid
        case authorUUID = "author_uuid"
        case title
        case textContent = "text_content"
        case mediaIDs = "media_ids"
        case likeCount = "like_count"
        case commentCount = "comment_count"
        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)

        let acf = try container.nestedContainer(keyedBy: ACFKeys.self, forKey: .acf)
        uuid = try acf.decode(String.self, forKey: .uuid)
        authorUUID = try acf.decode(String.self, forKey: .authorUUID)
        title = try acf.decodeIfPresent(String.self, forKey: .title)
        textContent = try acf.decodeIfPresent(String.self, forKey: .textContent)

        // Decode mediaIDs as string, then split into Int array
        if let mediaString = try acf.decodeIfPresent(String.self, forKey: .mediaIDs),
           !mediaString.isEmpty {
            mediaIDs = mediaString
                .split(separator: ",")
                .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        } else {
            mediaIDs = []
        }

        likeCount = Int(try acf.decodeIfPresent(String.self, forKey: .likeCount) ?? "0") ?? 0
        commentCount = Int(try acf.decodeIfPresent(String.self, forKey: .commentCount) ?? "0") ?? 0
        createdAt = try acf.decode(Date.self, forKey: .createdAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)

        var acf = container.nestedContainer(keyedBy: ACFKeys.self, forKey: .acf)

        try acf.encode(uuid, forKey: .uuid)
        try acf.encode(authorUUID, forKey: .authorUUID)
        try acf.encode(textContent, forKey: .textContent)

        // 🔥 Encode back as string for WP
        let mediaString = mediaIDs.map(String.init).joined(separator: ",")
        try acf.encode(mediaString, forKey: .mediaIDs)

        try acf.encode(likeCount, forKey: .likeCount)
        try acf.encode(commentCount, forKey: .commentCount)
        try acf.encode(createdAt, forKey: .createdAt)
    }
}
