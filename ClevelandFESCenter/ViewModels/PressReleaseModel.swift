//
//  PressReleaseModel.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

import Foundation
import SwiftData

@Model
final class PressReleaseModel {
    var id: UUID
    var headline: String
    var summary: String
    var author: String
    var publishDate: Date
    var isLive: Bool
    var createdAt: Date

    init(
        headline: String,
        summary: String,
        author: String,
        publishDate: Date,
        isLive: Bool = false
    ) {
        self.id = UUID()
        self.headline = headline
        self.summary = summary
        self.author = author
        self.publishDate = publishDate
        self.isLive = isLive
        self.createdAt = Date()
    }
}
