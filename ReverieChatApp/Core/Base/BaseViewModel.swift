//
//  BaseViewModel.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation

@Observable
class BaseViewModel {

    private(set) var isLoading: Bool = false

    func handle(_ error: Error) {
        ErrorStore.shared.post(error)
    }

    func withLoading(_ task: () async throws -> Void) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await task()
        } catch is CancellationError {
            // cancellation is expected, not an error
        } catch {
            handle(error)
        }
    }
}
