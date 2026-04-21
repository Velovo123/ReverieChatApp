//
//  ProfileView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import SwiftUI
import ProgressiveBlurHeader

struct ProfileView: View {

    let userId: String
    let conversation: Conversation?
    @State private var viewModel: ProfileViewModel
    @State private var showClearConfirmation: Bool = false
    @Environment(AppRouter.self) private var router

    init(userId: String, conversation: Conversation? = nil) {
        self.userId = userId
        self.conversation = conversation
        self._viewModel = State(
            wrappedValue: ProfileViewModel(userId: userId, conversation: conversation)
        )
    }

    var body: some View {
        StickyBlurHeader(
            maxBlurRadius: 8,
            fadeExtension: 40,
            tintOpacityTop: 0.5,
            tintOpacityMiddle: 0.35
        ) {
            header
        } content: {
            VStack(spacing: 24) {
                avatar
                info
                Divider()
                actions
            }
            .padding(24)
            .padding(.top, -24)
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
        .task {
            await viewModel.loadUser()
        }
        .confirmationDialog(
            "Clear conversation?",
            isPresented: $showClearConfirmation,
            titleVisibility: .visible
        ) {
            Button("Clear for everyone", role: .destructive) {
                Task { await viewModel.clearConversation() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all messages for both participants.")
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

            Spacer()

            Text("Profile")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)

            Spacer()

            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.clear)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    private var avatar: some View {
        ZStack {
            Circle()
                .fill(Color.teal.opacity(0.2))
                .frame(width: 90, height: 90)

            Text(viewModel.user?.initials ?? "?")
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(.teal)
        }
    }

    private var info: some View {
        VStack(spacing: 6) {
            if let user = viewModel.user {
                Text(user.username)
                    .font(.title3)
                    .fontWeight(.medium)

                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 140, height: 20)

                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 100, height: 16)
            }
        }
    }

    private var actions: some View {
        VStack(spacing: 0) {
            actionRow(
                icon: viewModel.isMuted ? "bell.fill" : "bell.slash",
                title: viewModel.isMuted ? "Unmute notifications" : "Mute notifications"
            ) {
                viewModel.toggleMute()
            }

            if viewModel.canClearConversation {
                Divider().padding(.leading, 52)

                actionRow(
                    icon: "trash",
                    title: "Clear conversation",
                    tint: .red
                ) {
                    showClearConfirmation = true
                }
            }

            Divider().padding(.leading, 52)

            actionRow(
                icon: "rectangle.portrait.and.arrow.right",
                title: "Sign out",
                tint: .red
            ) {
                Task.detached {
                    try? await AuthService.shared.signOut()
                    await MainActor.run {
                        User.current = nil
                        AppRouter.shared.isAuthenticated = false
                        AppRouter.shared.popToRoot()
                    }
                }
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func actionRow(
        icon: String,
        title: String,
        tint: Color = .primary,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundStyle(tint)
                    .frame(width: 24)

                Text(title)
                    .foregroundStyle(tint)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(userId: "1", conversation: Conversation.mocks[2])
            .environment(AppRouter.shared)
    }
}
