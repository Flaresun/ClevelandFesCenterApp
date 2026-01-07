//
//  AsyncFeaturedImage.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//

import SwiftUI

struct AsyncFeaturedImage: View {
    let mediaID: Int
    @State private var imageURL: URL?

    var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                    .scaledToFill()
                    .clipped()
            case .failure:
                Rectangle().fill(Color.gray.opacity(0.3))
            @unknown default:
                Rectangle().fill(Color.gray.opacity(0.3))
            }
        }
        .onAppear {
            fetchFeaturedMedia()
        }
    }

    func fetchFeaturedMedia() {
        guard let url = URL(string: "https://fescenter.org/test/wp-json/wp/v2/media/\(mediaID)") else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let sourceURL = json["source_url"] as? String,
                   let url = URL(string: sourceURL) {
                    imageURL = url
                }
            } catch {
                print("Error fetching media:", error)
            }
        }
    }
}
