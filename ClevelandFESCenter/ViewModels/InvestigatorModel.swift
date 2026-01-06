//
//  InvestigatorModel.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

import Foundation
import SwiftData

@Model
final class InvestigatorModel {
    var id: UUID
    var firstName: String
    var lastName: String
    var badgeNumber: String
    var department: String
    var email: String
    var createdAt: Date

    init(
        firstName: String,
        lastName: String,
        badgeNumber: String,
        department: String,
        email: String
    ) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.badgeNumber = badgeNumber
        self.department = department
        self.email = email
        self.createdAt = Date()
    }
}
