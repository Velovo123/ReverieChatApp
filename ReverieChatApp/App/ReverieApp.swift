//
//  ReverieApp.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import SwiftUI
import Supabase

@main
struct ReverieApp: App {

    @State private var router = AppRouter.shared
    @State private var errorStore = ErrorStore.shared
    @State private var isCheckingSession = true

    var body: some Scene {
        WindowGroup {
            Group {
                if isCheckingSession {
                    splashView
                } else if router.isAuthenticated {
                    NavigationStack(path: $router.path) {
                        ConversationListView()
                            .navigationDestination(for: Route.self) { route in
                                switch route {
                                case .conversationList:
                                    ConversationListView()
                                case .chat(let conversation):
                                    ChatView(conversation: conversation)
                                case .profile(let userId, let conversation):
                                    ProfileView(userId: userId, conversation: conversation)
                                }
                            }
                    }
                } else {
                    LoginView()
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: errorStore.currentError == nil)
            .overlay(alignment: .top) {
                ErrorBannerView()
            }
            .environment(router)
            .environment(errorStore)
            .task {
                await checkExistingSession()
            }
        }
    }


    private var splashView: some View {
        VStack {
            Spacer()
            Text("Reverie")
                .font(.custom("Georgia", size: 42))
                .foregroundStyle(.primary)
            Spacer()
        }
    }


    private func checkExistingSession() async {
        defer { isCheckingSession = false }

        guard let session = try? await supabase.auth.session else {
            return
        }

        guard !session.isExpired else {
            return
        }

        do {
            let user: User = try await supabase
                .from("users")
                .select()
                .eq("id", value: session.user.id.uuidString)
                .single()
                .execute()
                .value
            User.current = user
            router.isAuthenticated = true
        } catch {
            try? await supabase.auth.signOut()
        }
    }
}
