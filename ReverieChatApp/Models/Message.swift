//
//  Message.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation

struct Message: Codable, Identifiable, Hashable {
    let id: String
    let conversationId: String
    let senderId: String
    let content: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case conversationId = "conversation_id"
        case senderId = "sender_id"
        case content
        case createdAt = "created_at"
    }

    var isFromCurrentUser: Bool {
        senderId == User.current?.id
    }
}
