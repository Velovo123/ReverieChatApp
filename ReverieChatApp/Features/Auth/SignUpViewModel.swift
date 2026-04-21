//
//  SignUpViewModel.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation

@Observable
final class SignUpViewModel: BaseViewModel {

    private let authService: AuthServiceProtocol
    var isAwaitingConfirmation: Bool = false

    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }


    var usernameError: String? = nil
    var emailError: String? = nil
    var passwordError: String? = nil
    var confirmPasswordError: String? = nil


    private func validateUsername(_ username: String) -> String? {
        let trimmed = username.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "Username is required" }
        if trimmed.count < 3 { return "Username must be at least 3 characters" }
        if trimmed.contains(" ") { return "Username cannot contain spaces" }
        return nil
    }

    private func validateEmail(_ email: String) -> String? {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "Email is required" }
        if !trimmed.contains("@") || !trimmed.contains(".") { return "Enter a valid email address" }
        return nil
    }

    private func validatePassword(_ password: String) -> String? {
        if password.isEmpty { return "Password is required" }
        if password.count < 8 { return "Password must be at least 8 characters" }
        return nil
    }

    private func validateConfirmPassword(_ password: String, _ confirm: String) -> String? {
        if confirm.isEmpty { return "Please confirm your password" }
        if password != confirm { return "Passwords do not match" }
        return nil
    }

    private func validateFields(
        username: String,
        email: String,
        password: String,
        confirmPassword: String
    ) -> Bool {
        usernameError = validateUsername(username)
        emailError = validateEmail(email)
        passwordError = validatePassword(password)
        confirmPasswordError = validateConfirmPassword(password, confirmPassword)
        return usernameError == nil
            && emailError == nil
            && passwordError == nil
            && confirmPasswordError == nil
    }

    func clearErrors() {
        usernameError = nil
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
    }


    func signUp(
        username: String,
        email: String,
        password: String,
        confirmPassword: String
    ) async {
        guard validateFields(
            username: username,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        ) else { return }

        await withLoading {
            try await authService.signUp(
                email: email,
                password: password,
                username: username
            )
            isAwaitingConfirmation = true
        }
    }
}
