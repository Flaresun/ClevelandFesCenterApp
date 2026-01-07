//
//  WPPost.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//

import Foundation

struct WPPost: Identifiable, Decodable {
    let id: Int
    let date: String
    let title: RenderedText
    let excerpt: RenderedText
    let content: RenderedText
    let link: String
    let featuredMedia: Int?
    let categories: [Int] 

    enum CodingKeys: String, CodingKey {
        case id, date, title, excerpt, content, link
        case featuredMedia = "featured_media"
        case categories
    }
}

struct RenderedText: Decodable {
    let rendered: String
}
