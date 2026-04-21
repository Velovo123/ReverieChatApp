//
//  ConversationViewModel.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation

@Observable
final class ConversationViewModel: BaseViewModel {

    private let conversationService: ConversationServiceProtocol
    var conversations: [Conversation] = []

    init(conversationService: ConversationServiceProtocol = ConversationService.shared) {
        self.conversationService = conversationService
    }


    func loadConversations() async {
        await withLoading {
            conversations = try await conversationService.fetchConversations()
        }
    }

    func conversationsFor(_ type: ConversationType) -> [Conversation] {
        conversations.filter { $0.type == type }
    }
}
