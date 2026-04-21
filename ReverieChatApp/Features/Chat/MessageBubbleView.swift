//
//  MessageBubbleView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import SwiftUI

struct MessageBubbleView: View {

    let message: Message

    private var isFromMe: Bool { message.senderId == User.current?.id }

    var body: some View {
        HStack {
            if isFromMe { Spacer(minLength: 60) }

            Text(message.content)
                .font(.system(size: 15))
                .foregroundStyle(isFromMe ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isFromMe ? Color.accentColor : Color(.systemBackground).opacity(0.92))
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )

            if !isFromMe { Spacer(minLength: 60) }
        }
    }
}
