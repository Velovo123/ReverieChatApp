//
//  ErrorBannerView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import SwiftUI

struct ErrorBannerView: View {

    @Environment(ErrorStore.self) private var errorStore
    @State private var task: Task<Void, Never>? = nil

    var body: some View {
        if let error = errorStore.currentError {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(.white)
                    .font(.system(size: 16))

                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.system(size: 13, weight: .medium))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.systemRed))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .transition(
                .move(edge: .top)
                .combined(with: .opacity)
            )
            .onAppear { scheduleAutoDismiss() }
            .onTapGesture { dismiss() }
        }
    }


    private func scheduleAutoDismiss() {
        task?.cancel()
        task = Task {
            try? await Task.sleep(for: .seconds(3))
            guard !Task.isCancelled else { return }
            dismiss()
        }
    }

    private func dismiss() {
        task?.cancel()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            errorStore.clear()
        }
    }
}

#Preview {
    VStack {
        ErrorBannerView()
            .environment(ErrorStore.shared)
        Spacer()
    }
    .task {
        ErrorStore.shared.post(.network("No internet connection"))
    }
}
