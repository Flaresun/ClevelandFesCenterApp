//
//  WPImage.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/9/26.
//

import Foundation
import SwiftData

struct WPImage: Decodable, Identifiable {
    let id: Int
    let sourceURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case sourceURL = "source_url"
    }
}
