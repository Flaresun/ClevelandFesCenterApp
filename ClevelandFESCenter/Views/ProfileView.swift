//
//  ProfileView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/9/26.
//


import SwiftUI

struct ProfileView: View {
    @AppStorage("currentUserID") private var currentUserID: String?
    @State private var currentUser: AppUser? = nil
    @State var path: NavigationPath
    @State private var isShowingCreatePost = false

    var body: some View {
        VStack(spacing: 20) {
            if let user = currentUser {
                Text("Hello, \(user.firstName) \(user.lastName)!")
                    .font(.title)
                    .bold()
            } else {
                Text("Hello!")
            }
            
            Button("Create Post") {
                // Only toggle the sheet
                isShowingCreatePost = true
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .sheet(isPresented: $isShowingCreatePost) {
            // This is what shows when isShowingCreatePost is true
            CreatePostView()
                .presentationDetents([.medium, .large])
        }
        .onAppear {
            Task { @MainActor in
                await loadCurrentUser()
            }
        }
        .navigationTitle("Profile")
    }

    @MainActor
    private func loadCurrentUser() async {
        guard let id = currentUserID else { return }
        do {
            let users = try await UserService.shared.fetchUsers()
            currentUser = users.first { $0.uuid == id }
        } catch {
            print("❌ Failed to load current user:", error)
        }
    }
}
