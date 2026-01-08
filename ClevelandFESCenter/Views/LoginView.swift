//
//  LoginView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//
import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("currentUserID") private var currentUserID: String?
    @Binding var path: NavigationPath

    @State private var firstName = ""
    @State private var lastName = ""

    var body: some View {
        VStack(spacing: 20) {
            Image("logo").resizable().scaledToFit().frame(width: 100)
            Text("Cleveland FES Center").font(.title).bold()
            TextField("First Name", text: $firstName).textFieldStyle(.roundedBorder)
            TextField("Last Name", text: $lastName).textFieldStyle(.roundedBorder)

            Button("Continue") { login() }
                .buttonStyle(.borderedProminent)
                .disabled(!formIsValid)

            Spacer()
        }
        .padding()
    }

    private var formIsValid: Bool { !firstName.isEmpty && !lastName.isEmpty }

    private func login() {
        // Look for existing user
        let descriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate { $0.firstName == firstName && $0.lastName == lastName }
        )

        let user: UserModel
        if let existing = try? modelContext.fetch(descriptor).first {
            user = existing
        } else {
            let newUser = UserModel(firstName: firstName, lastName: lastName)
            modelContext.insert(newUser)
            user = newUser
        }

        currentUserID = user.id.uuidString
        path.append(NavigationModel.home) // push HomeView
    }
}
