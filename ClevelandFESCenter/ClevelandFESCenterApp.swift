//
//  ClevelandFESCenterApp.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

import SwiftUI
import SwiftData

@main
struct ClevelandFESCenterApp: App {
    @AppStorage("currentUserID") private var currentUserID: String?
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            EventModel.self,
            CenterResourceModel.self,
            PressReleaseModel.self,
            UserModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    

    var body: some Scene {
        WindowGroup {
            if currentUserID == nil {
                LoginView()
            } else {
                HomeView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
