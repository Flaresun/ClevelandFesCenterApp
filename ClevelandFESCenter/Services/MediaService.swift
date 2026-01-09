//
//  MediaService.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/9/26.
//

import Foundation

final class MediaService {
    static let shared = MediaService()
    private init() {}

    func fetchMedia(id: Int) async throws -> WPImage {
        let url = URL(string: "https://fescenter.org/test/wp-json/wp/v2/media/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WPImage.self, from: data)
    }
}
