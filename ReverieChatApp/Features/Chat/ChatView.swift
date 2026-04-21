//
//  ChatView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import SwiftUI
import ProgressiveBlurHeader

struct ChatView: View {

    let conversationId: String
    let conversation: Conversation

    @State private var viewModel: ChatViewModel
    @Environment(AppRouter.self) private var router

    init(conversation: Conversation) {
        self.conversationId = conversation.id
        self._viewModel = State(
            wrappedValue: ChatViewModel(conversationId: conversation.id)
        )
        self.conversation = conversation
    }

    var body: some View {
        ZStack {
            DotGridView()

            VStack(spacing: 0) {
                StickyBlurHeader(
                    maxBlurRadius: 8,
                    fadeExtension: 40,
                    tintOpacityTop: 0.5,
                    tintOpacityMiddle: 0.35
                ) {
                    header
                } content: {
                    LazyVStack(spacing: 4) {
                        ForEach(viewModel.messages) { message in
                            MessageBubbleView(message: message)
                                .padding(.horizontal, 12)
                                .id(message.id)
                        }

                        if viewModel.isTyping {
                            TypingIndicatorView()
                                .padding(.horizontal, 12)
                                .id("typing")
                        }
                    }
                    .padding(.top, -24)
                    .padding(.vertical, 12)
                    .padding(.bottom, 8)
                }

                inputBar
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadMessages()
            await viewModel.subscribeToRealtime()
        }
    }


    private var header: some View {
        HStack(spacing: 12) {
            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.primary)
            }

            Circle()
                .fill(conversation.avatarColor.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay {
                    Text(conversation.avatarLabel)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(conversation.avatarColor)
                }

            VStack(alignment: .leading, spacing: 1) {
                Text(conversation.displayName)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
                Text("Online")
                    .font(.caption2)
                    .foregroundStyle(.green)
            }

            Spacer()

            Button {
                if let userId = User.current?.id {
                    router.push(.profile(userId: userId, conversation: conversation))
                }
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 17))
                    .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Message...", text: $viewModel.draft, axis: .vertical)
                .lineLimit(1...5)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Button {
                Task { await viewModel.sendMessage() }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(
                        viewModel.draft.isEmpty ? Color(.tertiaryLabel) : Color.accentColor
                    )
            }
            .disabled(viewModel.draft.isEmpty)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    NavigationStack {
        ChatView(conversation: Conversation.mocks[0])
            .environment(AppRouter.shared)
    }
}
