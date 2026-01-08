//
//  UserService.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/8/26.
//

import Foundation

class UserService {
    static let shared = UserService()
    
    private let baseURL = URL(string: "https://fescenter.org/test/wp-json/wp/v2/")!
    
    private let session: URLSession
    private let authHeader: String? // Base64 username:app-password
    
    private init() {
        self.session = URLSession.shared
        // Replace with your app WP credentials
        let username = "fescenter"
        let appPassword = "4ttm xLpg zN0K m7Gy 0CBR I46P"
        let credentials = "\(username):\(appPassword)"
        self.authHeader = "Basic \(Data(credentials.utf8).base64EncodedString())"
    }
    
    // MARK: - Create user
    func createUser(uuid: String,firstName: String,lastName: String) async throws -> AppUser {

        let url = baseURL.appendingPathComponent("app_users")
        print("📡 Creating user at:", url.absoluteString)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let auth = authHeader else {
            print("❌ Missing Authorization Header")
            throw URLError(.userAuthenticationRequired)
        }
        request.addValue(auth, forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "title": "\(firstName) \(lastName)",
            "status": "publish",

            // ✅ ACF fields MUST be under "acf"
            "acf": [
                "uuid": uuid,
                "fname": firstName,
                "lname": lastName,
                "created_at": ISO8601DateFormatter().string(from: Date())
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("❌ JSON Serialization Failed:", error)
            throw error
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            print("❌ Network Request Failed:", error)
            throw error
        }

        guard let http = response as? HTTPURLResponse else {
            print("❌ Invalid HTTP Response")
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(http.statusCode) else {
            let responseBody = String(data: data, encoding: .utf8) ?? "No body"
            print("❌ WP Create User Failed")
            print("Status Code:", http.statusCode)
            print("Response Body:", responseBody)
            throw URLError(.badServerResponse)
        }

        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(AppUser.self, from: data)
            print("✅ User Created:", user.uuid)
            return user
        } catch {
            print("❌ JSON Decode Failed")
            print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
            throw error
        }
    }

    
    // MARK: - Fetch all users
    func fetchUsers() async throws -> [AppUser] {

        var components = URLComponents(
            url: baseURL.appendingPathComponent("app_users"),
            resolvingAgainstBaseURL: false
        )!

        components.queryItems = [
            URLQueryItem(name: "per_page", value: "10")
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        do {
            return try JSONDecoder().decode([AppUser].self, from: data)
        } catch {
            print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
            throw error
        }
    }


}
