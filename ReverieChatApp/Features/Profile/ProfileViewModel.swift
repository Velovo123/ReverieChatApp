//
//  ProfileViewModel.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation
import Supabase

@Observable
final class ProfileViewModel: BaseViewModel {

    let userId: String
    var user: User? = nil
    var isMuted: Bool = false

    var conversation: Conversation?

    init(userId: String, conversation: Conversation? = nil) {
        self.userId = userId
        self.conversation = conversation
    }


    func loadUser() async {
        await withLoading {
            let fetchedUser: User = try await supabase
                .from("users")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            user = fetchedUser
        }
        loadMuteState()
    }


    private var muteKey: String {
        "muted_\(userId)_\(conversation?.id ?? "")"
    }

    func loadMuteState() {
        isMuted = UserDefaults.standard.bool(forKey: muteKey)
    }

    func toggleMute() {
        isMuted.toggle()
        UserDefaults.standard.set(isMuted, forKey: muteKey)
    }


    var canClearConversation: Bool {
        conversation?.type == .dm
    }

    func clearConversation() async {
        guard let conversation else { return }
        await withLoading {
            try await supabase
                .from("messages")
                .delete()
                .eq("conversation_id", value: conversation.id)
                .execute()
        }
    }


    func signOut() async {
        do {
            try await AuthService.shared.signOut()
            User.current = nil
            AppRouter.shared.isAuthenticated = false
            AppRouter.shared.popToRoot()
        } catch {
            handle(error)
        }
    }
}
