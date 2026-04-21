//
//  ErrorStore.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation

@Observable
final class ErrorStore {
    static let shared = ErrorStore()
    private init() {}

    var currentError: AppError? = nil

    func post(_ error: AppError) {
        currentError = error
    }

    func post(_ error: Error) {
        currentError = AppError.from(error)
    }

    func clear() {
        currentError = nil
    }
}
