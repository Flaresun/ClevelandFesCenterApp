//
//  EventView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

import SwiftUI
import SwiftData

struct EventView: View {
    @AppStorage("currentUserID") private var currentUserID: String?
    @Query private var users: [UserModel]
    
    private var currentUser: UserModel? {
        guard let idString = currentUserID,
              let id = UUID(uuidString: idString) else {
            return nil
        }
        return users.first { $0.id == id }
    }
    private var msg: String {
        if let user = currentUser {
            return "Events, \(user.firstName) \(user.lastName)!"
        } else {
            return "Events"
        }
    }
    
    var body: some View {

        Text(msg)
            .font(.title)
            .foregroundStyle(.secondary)
        
        CalendarView()
    }
}
