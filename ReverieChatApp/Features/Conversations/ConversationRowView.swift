//
//  ConversationRowView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import SwiftUI

struct ConversationRowView: View {

    let conversation: Conversation

    var body: some View {
        HStack(spacing: 12) {
            avatar
            content
        }
        .padding(.vertical, 8)
    }

    private var avatar: some View {
        Circle()
            .fill(conversation.avatarColor.opacity(0.2))
            .frame(width: 44, height: 44)
            .overlay {
                Text(conversation.avatarLabel)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(conversation.avatarColor)
            }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(conversation.displayName)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)

            Text(conversation.type == .channel ? "Tap to open channel" : "Tap to open chat")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
