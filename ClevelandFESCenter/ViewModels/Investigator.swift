//
//  InvestigatorStruct.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/7/26.
//import Foundation
import Foundation

struct Investigator: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String
    let link: URL

    let role: String?
    let imageURL: URL?
    let number: String?
    let email: String?
    let location: String?
    let projectStage: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, link, acf
    }

    enum ACFKeys: String, CodingKey {
        case role
        case profile_img
        case number
        case email
        case location
        case project_stage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        link = try container.decode(URL.self, forKey: .link)

        let acf = try? container.nestedContainer(keyedBy: ACFKeys.self, forKey: .acf)

        role = try? acf?.decode(String.self, forKey: .role)
        number = try? acf?.decode(String.self, forKey: .number)
        email = try? acf?.decode(String.self, forKey: .email)
        location = try? acf?.decode(String.self, forKey: .location)
        projectStage = try? acf?.decode(String.self, forKey: .project_stage)

        if let imgString = try? acf?.decode(String.self, forKey: .profile_img),
           let url = URL(string: imgString) {
            imageURL = url
        } else {
            imageURL = nil
        }
    }
}

