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

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)

                Text("Cleveland FES Center")
                    .font(.title)
                    .bold()

                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)

                Button {
                    login()
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!formIsValid)

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView()
            }
        }
    }

    private var formIsValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty
    }

    private func login() {
        // Check if user already exists
        let descriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate {
                $0.firstName == firstName && $0.lastName == lastName
            }
        )

        if let existingUser = try? modelContext.fetch(descriptor).first {
            currentUserID = existingUser.id.uuidString
            print("Existing user:", existingUser.firstName, existingUser.lastName, existingUser.id)
        } else {
            let newUser = UserModel(firstName: firstName, lastName: lastName)
            modelContext.insert(newUser)
            currentUserID = newUser.id.uuidString
            print("New user:", newUser.firstName, newUser.lastName, newUser.id)
        }

        isLoggedIn = true
    }
}
