//
//  InvestigatorService.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//

import Foundation

class InvestigatorService {
    static let shared = InvestigatorService()
    private init() {}

    private let baseURL = "https://fescenter.org/test/wp-json/wp/v2/investigator?per_page=50"
    func fetchInvestigators() async throws -> [Investigator] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        print("Bytes:", data.count)

        if let http = response as? HTTPURLResponse {
            print("Total:", http.value(forHTTPHeaderField: "X-WP-Total"))
            print("Pages:", http.value(forHTTPHeaderField: "X-WP-TotalPages"))
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        do {
            let decoded = try JSONDecoder().decode([Investigator].self, from: data)
            
            // Debug: print how many investigators were decoded
            print("Decoded \(decoded.count) investigators")
            for inv in decoded {
                print("Investigator: \(inv.name)")
            }

            return decoded
        } catch {
            print("Error decoding investigators: \(error)")
            return []
        }
    }

}
