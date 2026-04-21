//
//  User.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: String
    let email: String
    let username: String
    let avatarURL: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
    }

    var initials: String {
        username
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .joined()
    }
}

extension User {
    static var current: User? = nil
}
