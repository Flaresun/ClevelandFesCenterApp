//
//  AppUser.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/8/26.
//
import Foundation

struct AppUser: Codable, Identifiable, Hashable {

    let id: Int
    let acf: AppUserACF
    
    var uuid: String {
        acf.uuid ?? ""
    }
    
    var firstName: String {
        acf.fname ?? ""
    }

    var lastName: String {
        acf.lname ?? ""
    }

    var createdAt: Date? {
        guard let createdAt = acf.createdAt else { return nil }
        return ISO8601DateFormatter().date(from: createdAt)
    }
}

struct AppUserACF: Codable, Hashable {
    let uuid: String?
    let fname: String?
    let lname: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case uuid
        case fname
        case lname
        case createdAt = "created_at"
    }
}
