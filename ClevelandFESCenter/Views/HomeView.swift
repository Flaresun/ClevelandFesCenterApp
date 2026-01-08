//
//  HomeView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

//
//  ContentView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

import SwiftUI
import SwiftData
struct HomeView: View {
    @AppStorage("currentUserID") private var currentUserID: String?
    @State private var allUsers: [AppUser] = []
    @State private var currentUser: AppUser? = nil
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: 24) {
            if let user = currentUser {
                Text("Welcome, \(user.firstName) \(user.lastName)! Choose where to go.")
                    .foregroundStyle(.secondary)
            } else {
                Text("Welcome! Choose where to go.")
                    .foregroundStyle(.secondary)
            }

            ScrollView {
                VStack(spacing: 16) {
                    Button("Events") { path.append(NavigationModel.events) }
                    Button("Investigators") { path.append(NavigationModel.investigators) }
                    Button("News & Updates") { path.append(NavigationModel.posts) }
                }
                .padding()
            }
        }
        .navigationTitle("Home")
        .onAppear {
            Task {
                await loadUsers()
            }
        }
    }

    @MainActor
    private func loadUsers() async {
        do {
            let fetchedUsers = try await UserService.shared.fetchUsers()
            allUsers = fetchedUsers
            print("✅ Fetched \(allUsers.count) users")

            if let id = currentUserID {
                currentUser = fetchedUsers.first { $0.uuid == id }
                print("Current user: \(currentUser?.firstName ?? "nil")")
            }
        } catch {
            print("❌ Failed to fetch users:", error)
        }
    }
}
