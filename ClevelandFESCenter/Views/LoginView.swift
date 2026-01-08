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

            Button("Continue") {
                    Task {
                        await login()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!formIsValid)

            Spacer()
        }
        .padding()
    }

    private var formIsValid: Bool { !firstName.isEmpty && !lastName.isEmpty }

    @MainActor
    private func login() async {
        do {
            let users = try await UserService.shared.fetchUsers()
            print(users)
            print(firstName, lastName)
            // Check for existing user
            if let existingUser = users.first(where: {
                $0.firstName.caseInsensitiveCompare(firstName) == .orderedSame &&
                $0.lastName.caseInsensitiveCompare(lastName) == .orderedSame
            }) {
                currentUserID = existingUser.uuid
            } else {
                // Create a new user
                let uuid = UUID().uuidString
                let newUser = try await UserService.shared.createUser(
                    uuid: uuid,
                    firstName: firstName,
                    lastName: lastName
                )
                currentUserID = newUser.uuid
                print("currentUserId \(currentUserID)")
            }
            
            // 4️⃣ Navigate
            path.append(NavigationModel.home)

        } catch {
            print("Login failed:", error)
            // TODO: show user-facing error
        }
    }

}
