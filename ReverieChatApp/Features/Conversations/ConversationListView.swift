//
//  ConversationListView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import SwiftUI
import ProgressiveBlurHeader

struct ConversationListView: View {

    @State private var viewModel = ConversationViewModel()
    @Environment(AppRouter.self) private var router

    var body: some View {
        StickyBlurHeader(
            maxBlurRadius: 8,
            fadeExtension: 40,
            tintOpacityTop: 0.5,
            tintOpacityMiddle: 0.35
        ) {
            HStack {
                Text("Reverie")
                    .font(.custom("Georgia", size: 24))
                    .foregroundStyle(.primary)

                Spacer()

                Button {
                    // TODO: new conversation
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(.primary)
                        .font(.system(size: 17))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)

        } content: {
            LazyVStack(spacing: 0) {
                if !viewModel.conversationsFor(.channel).isEmpty {
                    sectionHeader("Channels")

                    ForEach(viewModel.conversationsFor(.channel)) { conversation in
                        ConversationRowView(conversation: conversation)
                            .padding(.horizontal, 16)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                router.push(.chat(conversation: conversation))
                            }
                        Divider()
                            .padding(.leading, 72)
                    }
                }

                if !viewModel.conversationsFor(.dm).isEmpty {
                    sectionHeader("Direct messages")
                        .padding(.top, 8)

                    ForEach(viewModel.conversationsFor(.dm)) { conversation in
                        ConversationRowView(conversation: conversation)
                            .padding(.horizontal, 16)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                router.push(.chat(conversation: conversation))
                            }
                        Divider()
                            .padding(.leading, 72)
                    }
                }
            }
            .padding(.bottom, 32)
        }
        .overlay(alignment: .leading) {
            AuroraStripeView()
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
        .task {
            await viewModel.loadConversations()
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.footnote)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        ConversationListView()
            .environment(AppRouter.shared)
    }
}
