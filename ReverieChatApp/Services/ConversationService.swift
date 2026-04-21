//
//  ConversationService.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation
import Supabase


protocol ConversationServiceProtocol {
    func fetchConversations() async throws -> [Conversation]
    func createChannel(name: String) async throws -> Conversation
    func createDM(with userId: String) async throws -> Conversation
}


final class ConversationService: ConversationServiceProtocol {

    static let shared = ConversationService()
    private init() {}

    func fetchConversations() async throws -> [Conversation] {
        guard let currentUserId = User.current?.id else {
            throw AppError.auth("Not authenticated")
        }

        do {
            let conversations: [Conversation] = try await supabase
                .from("conversations")
                .select("*, conversation_members!inner(user_id)")
                .eq("conversation_members.user_id", value: currentUserId)
                .execute()
                .value

            return conversations
        } catch {
            throw AppError.network(error.localizedDescription)
        }
    }

    func createChannel(name: String) async throws -> Conversation {
        guard let currentUserId = User.current?.id else {
            throw AppError.auth("Not authenticated")
        }

        do {
            let conversation: Conversation = try await supabase
                .from("conversations")
                .insert([
                    "name": name,
                    "type": "channel"
                ])
                .select()
                .single()
                .execute()
                .value

            try await supabase
                .from("conversation_members")
                .insert([
                    "conversation_id": conversation.id,
                    "user_id": currentUserId
                ])
                .execute()

            return conversation
        } catch {
            throw AppError.network(error.localizedDescription)
        }
    }

    func createDM(with userId: String) async throws -> Conversation {
        guard let currentUserId = User.current?.id else {
            throw AppError.auth("Not authenticated")
        }

        do {
            let conversation: Conversation = try await supabase
                .from("conversations")
                .insert([
                    "name": "DM",
                    "type": "dm"
                ])
                .select()
                .single()
                .execute()
                .value

            try await supabase
                .from("conversation_members")
                .insert([
                    ["conversation_id": conversation.id, "user_id": currentUserId],
                    ["conversation_id": conversation.id, "user_id": userId]
                ])
                .execute()

            return conversation
        } catch {
            throw AppError.network(error.localizedDescription)
        }
    }
}


struct ConversationMember: Codable {
    let conversationId: String

    enum CodingKeys: String, CodingKey {
        case conversationId = "conversation_id"
    }
}
