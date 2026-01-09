//
//  PostMediaGrid.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/9/26.
//


import SwiftUI

struct PostMediaGrid: View {

    let mediaIDs: [Int]

    @State private var media: [WPImage] = []
    @State private var isLoading = true

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(media) { item in
                        AsyncImage(url: item.sourceURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 150)
                        .clipped()
                        .cornerRadius(12)
                    }
                }
            }
        }
        .task {
            await loadMedia()
        }
    }

    @MainActor
    private func loadMedia() async {
        do {
            media = try await withThrowingTaskGroup(of: WPImage.self) { group in
                for id in mediaIDs {
                    group.addTask {
                        try await MediaService.shared.fetchMedia(id: id)
                    }
                }

                var results: [WPImage] = []
                for try await item in group {
                    results.append(item)
                }
                return results
            }
            isLoading = false
        } catch {
            print("❌ Failed to load media:", error)
        }
    }
}
