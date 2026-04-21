//
//  RealtimeService.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation
import Supabase

final class RealtimeService: @unchecked Sendable {

    private let conversationId: String
    private var channel: RealtimeChannelV2?

    init(conversationId: String) {
        self.conversationId = conversationId
    }

    func subscribe(onMessage: @escaping @Sendable (Message) -> Void) async {
        let channelName = "messages:\(conversationId):\(UUID().uuidString)"
        let channel = supabase.realtimeV2.channel(channelName)

        let insertions = channel.postgresChange(
            InsertAction.self,
            table: "messages",
            filter: .eq("conversation_id", value: conversationId)
        )

        try? await channel.subscribeWithError()
        self.channel = channel

        Task {
            for await insertion in insertions {
                let record = insertion.record

                guard
                    let id = record["id"]?.stringValue,
                    let convId = record["conversation_id"]?.stringValue,
                    let senderId = record["sender_id"]?.stringValue,
                    let content = record["content"]?.stringValue,
                    let createdAtStr = record["created_at"]?.stringValue
                else { continue }

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                let createdAt = formatter.date(from: createdAtStr) ?? Date()

                let message = Message(
                    id: id,
                    conversationId: convId,
                    senderId: senderId,
                    content: content,
                    createdAt: createdAt
                )
                onMessage(message)
            }
        }
    }
    
    
    func unsubscribe() async {
        if let channel {
            await supabase.realtimeV2.removeChannel(channel)
        }
        channel = nil
    }
}
