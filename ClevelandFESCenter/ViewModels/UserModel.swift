//
//  UserModel.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

//
//  InvestigatorModel.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

import Foundation
import SwiftData

@Model
final class UserModel {
    var id: UUID
    var firstName: String
    var lastName: String
    var createdAt: Date

    init(
        firstName: String,
        lastName: String,
    ) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.createdAt = Date()
    }
}
