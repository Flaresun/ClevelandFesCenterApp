//
//  Untitled.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/8/26.
//

import SwiftUI
internal import Combine

class CurrentUserManager: ObservableObject {
    @AppStorage("currentUserUUID") private var currentUserUUID: String?
    @Published var currentUser: AppUser?

    func setCurrentUser(_ user: AppUser) {
        self.currentUser = user
        self.currentUserUUID = user.uuid
    }

    func loadCurrentUser() async {
        guard let uuid = currentUserUUID else { return }
        do {
            let users = try await UserService.shared.fetchUsers()
            self.currentUser = users.first { $0.uuid == uuid }
        } catch {
            print("Failed to fetch current user:", error)
        }
    }
}
