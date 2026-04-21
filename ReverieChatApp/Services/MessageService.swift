//
//  MessageService.swift
//  Reverie
//
//  Created on 20/04/2026.
//

import Foundation
import Supabase


protocol MessageServiceProtocol {
    func fetchMessages(conversationId: String) async throws -> [Message]
    func sendMessage(conversationId: String, content: String) async throws -> Message
}


final class MessageService: MessageServiceProtocol {

    static let shared = MessageService()
    private init() {}

    func fetchMessages(conversationId: String) async throws -> [Message] {
        do {
            let messages: [Message] = try await supabase
                .from("messages")
                .select()
                .eq("conversation_id", value: conversationId)
                .order("created_at", ascending: true)
                .execute()
                .value
            return messages
        } catch {
            throw AppError.network(error.localizedDescription)
        }
    }

    func sendMessage(conversationId: String, content: String) async throws -> Message {
        guard let currentUserId = User.current?.id else {
            throw AppError.auth("Not authenticated")
        }

        do {
            let message: Message = try await supabase
                .from("messages")
                .insert([
                    "conversation_id": conversationId,
                    "sender_id": currentUserId,
                    "content": content
                ])
                .select()
                .single()
                .execute()
                .value
            return message
        } catch {
            throw AppError.network(error.localizedDescription)
        }
    }
}
