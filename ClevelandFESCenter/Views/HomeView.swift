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
    @Query private var users: [UserModel]
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: 24) {
            Text(welcomeMessage)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Events") { path.append(NavigationModel.events) }
                    Button("Investigators") { path.append(NavigationModel.investigators) }
                    Button("Press Releases") { path.append(NavigationModel.posts) }
                    Button("Center Resources") { path.append(NavigationModel.resources) }
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
            }
        }
        .navigationDestination(for: NavigationModel.self) { destination in
            switch destination {
            case .home:
                HomeView(path: $path)
            case .events:
                EventView()
            case .investigators:
                InvestigatorListView()
            case .posts:
                PostListView()
            case .resources:
                CenterResourceView()
            default:
                EmptyView()
            }
        }
    }

    private var currentUser: UserModel? {
        guard let idString = currentUserID,
              let id = UUID(uuidString: idString) else { return nil }
        return users.first { $0.id == id }
    }

    private var welcomeMessage: String {
        if let user = currentUser {
            return "Welcome, \(user.firstName) \(user.lastName)! Choose where to go."
        } else {
            return "Welcome! Choose where to go."
        }
    }
}
