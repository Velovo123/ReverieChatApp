//
//  Presence.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation

struct Presence: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let isOnline: Bool
    let isTyping: Bool
    let lastSeen: Date?
}
