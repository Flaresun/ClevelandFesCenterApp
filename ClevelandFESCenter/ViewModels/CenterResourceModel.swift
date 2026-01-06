//
//  CenterResourceModel.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

import Foundation
import SwiftData

@Model
final class CenterResourceModel {
    var id: UUID
    var title: String
    var bodyText: String
    var releaseDate: Date
    var isPublished: Bool
    var createdAt: Date

    init(
        title: String,
        bodyText: String,
        releaseDate: Date,
        isPublished: Bool = false
    ) {
        self.id = UUID()
        self.title = title
        self.bodyText = bodyText
        self.releaseDate = releaseDate
        self.isPublished = isPublished
        self.createdAt = Date()
    }
}
