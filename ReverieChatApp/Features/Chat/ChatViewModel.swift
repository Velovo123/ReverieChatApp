//
//  ChatViewModel.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation

@Observable
final class ChatViewModel: BaseViewModel {

    let conversationId: String
    var messages: [Message] = []
    var draft: String = ""
    var isTyping: Bool = false

    private let messageService: MessageServiceProtocol
    private let realtimeService: RealtimeService

    init(
        conversationId: String,
        messageService: MessageServiceProtocol = MessageService.shared
    ) {
        self.conversationId = conversationId
        self.messageService = messageService
        self.realtimeService = RealtimeService(conversationId: conversationId)
    }


    func loadMessages() async {
        await withLoading {
            messages = try await messageService.fetchMessages(
                conversationId: conversationId
            )
        }
    }

    func sendMessage() async {
        guard !draft.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let content = draft
        draft = ""

        do {
            let message = try await messageService.sendMessage(
                conversationId: conversationId,
                content: content
            )
            messages.append(message)
        } catch {
            handle(error)
            draft = content
        }
    }

    func subscribeToRealtime() async {
        await realtimeService.unsubscribe()
        await realtimeService.subscribe { [weak self] message in
            guard let self else { return }
            if !messages.contains(where: { $0.id == message.id }) {
                messages.append(message)
            }
        }
    }
}
