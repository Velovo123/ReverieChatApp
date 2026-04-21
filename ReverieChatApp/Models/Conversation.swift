//
//  Conversation.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation
import SwiftUI

enum ConversationType: String, Codable {
    case channel
    case dm
}

struct Conversation: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let type: ConversationType
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case createdAt = "created_at"
    }

    var displayName: String {
        switch type {
        case .channel: return "# \(name)"
        case .dm: return name
        }
    }

    var avatarLabel: String {
        switch type {
        case .channel: return "#"
        case .dm: return String(name.prefix(2)).uppercased()
        }
    }

    var avatarColor: Color {
        switch id.hashValue % 4 {
        case 0:  return .teal
        case 1:  return .blue
        case 2:  return .purple
        default: return .pink
        }
    }
}

extension Conversation {
    static let mocks: [Conversation] = [
        Conversation(id: "c1", name: "general", type: .channel, createdAt: .now),
        Conversation(id: "c2", name: "design",  type: .channel, createdAt: .now),
        Conversation(id: "d1", name: "Anna R.", type: .dm,      createdAt: .now),
        Conversation(id: "d2", name: "Max K.",  type: .dm,      createdAt: .now),
    ]
}
