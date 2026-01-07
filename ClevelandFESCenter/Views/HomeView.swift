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

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)

                Text(welcomeMessage)
                    .foregroundStyle(.secondary)

                VStack(spacing: 16) {
                    NavigationLink("Events", destination: EventView())
                    NavigationLink( "Investigators", destination: InvestigatorListView())
                    NavigationLink("Press Release", destination: PostListView())
                    NavigationLink("Center Resource", destination: CenterResourceView())
                }
                .padding(.horizontal)
            }
        }
    }

    private var currentUser: UserModel? {
        guard let idString = currentUserID,
              let id = UUID(uuidString: idString) else {
            return nil
        }
        return users.first { $0.id == id }
    }

    private var welcomeMessage: String {
        if let user = currentUser {
            return "Welcome, \(user.firstName) \(user.lastName)! Choose where to go."
        } else {
            return "Welcome!Choose where to go."
        }
    }
}



#Preview {
    LoginView()
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

