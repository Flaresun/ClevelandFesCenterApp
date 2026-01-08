//
//  AppRoot.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/8/26.
//
import SwiftUI
import SwiftData

struct AppRootView: View {
    @AppStorage("currentUserID") private var storedUserID: String?
    @Query private var users: [UserModel]  // all users
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            if let currentUser = currentUser {
                // Only show HomeView if currentUser exists
                HomeView(path: $path)
            } else {
                // Otherwise show Login
                LoginView(path: $path)
            }
        }
    }

    /// Returns the currently logged-in user, or nil if none exists
    private var currentUser: UserModel? {
        guard
            let idString = storedUserID,
            let id = UUID(uuidString: idString)
        else {
            return nil
        }
        return users.first { $0.id == id }
    }
}




#Preview {
    AppRootView()
        .modelContainer(
            for: [
                EventModel.self,
                PressReleaseModel.self,
                CenterResourceModel.self,
                UserModel.self
            ],
            inMemory: true
        )
}
