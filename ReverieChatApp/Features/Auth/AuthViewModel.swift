//
//  AuthViewModel.swift
//  Reverie
//
//  Created on 20/04/2026.
//

import Foundation

@Observable
final class AuthViewModel: BaseViewModel {
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    
    var emailError: String? = nil
    var passwordError: String? = nil
    
    
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
    
    private func validateFields(email: String, password: String) -> Bool {
        emailError = validateEmail(email)
        passwordError = validatePassword(password)
        return emailError == nil && passwordError == nil
    }
    
    func clearErrors() {
        emailError = nil
        passwordError = nil
    }
    
    
    func signIn(email: String, password: String) async {
        guard validateFields(email: email, password: password) else { return }
        await withLoading {
            let user = try await authService.signIn(email: email, password: password)
            User.current = user
            AppRouter.shared.isAuthenticated = true
        }
    }
    
    func signInWithApple() async {
        await withLoading {
            // TODO: implement Sign in with Apple
        }
    }
}
