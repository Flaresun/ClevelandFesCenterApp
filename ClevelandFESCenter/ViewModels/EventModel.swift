//
//  EventModel.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

import Foundation
import SwiftData

@Model
final class EventModel {
    var id: UUID
    var title: String
    var date: Date
    var location: String
    var details: String
    var createdAt: Date

    init(
        title: String,
        date: Date,
        location: String,
        details: String
    ) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.location = location
        self.details = details
        self.createdAt = Date()
    }
}
