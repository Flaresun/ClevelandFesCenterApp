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

struct HomeView: View {
    @StateObject private var feedVM = FeedViewModel()
    @AppStorage("currentUserID") private var currentUserID: String?
    @State private var currentUser: AppUser? = nil
    @Binding var path: NavigationPath

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let user = currentUser {
                    Text("Welcome, \(user.firstName) \(user.lastName)!").foregroundStyle(.secondary)
                } else {
                    Text("Welcome!").foregroundStyle(.secondary)
                }

                Divider()

                ForEach(feedVM.posts) { post in
                    PostCardView(post: post, author: feedVM.user(for: post))
                        .padding(.bottom, 8)
                }
            }
            .padding()
        }
        .refreshable {
            await feedVM.reloadFeed()
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        path.append(NavigationModel.profile)
                    } label: {
                        Label("Profile", systemImage: "plus")
                    }

                    Button {
                        path.append(NavigationModel.events)
                    } label: {
                        Label("Events", systemImage: "calendar")
                    }

                    Button {
                        path.append(NavigationModel.investigators)
                    } label: {
                        Label("Investigators", systemImage: "person.3")
                    }

                    Button {
                        path.append(NavigationModel.posts)
                    } label: {
                        Label("News & Updates", systemImage: "newspaper")
                    }

                    Divider()

                    Button(role: .destructive) {
                        currentUserID = nil
                        path.removeLast(path.count)
                    } label: {
                        Label("Log Out", systemImage: "arrow.backward")
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                }
            }
        }
        .task {
            await loadCurrentUser()
            await feedVM.reloadFeed()
        }
    }

    @MainActor
    private func loadCurrentUser() async {
        guard let id = currentUserID else { return }
        let users = try? await UserService.shared.fetchUsers()
        currentUser = users?.first { $0.uuid == id }
    }
}
