//
//  AuthService.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Foundation
import Supabase


protocol AuthServiceProtocol {
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, username: String) async throws
    func signOut() async throws
    func currentUser() async -> User?
}


final class AuthService: AuthServiceProtocol {

    static let shared = AuthService()
    private init() {}

    func signIn(email: String, password: String) async throws -> User {
        do {
            let session = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            return try await fetchProfile(userId: session.user.id.uuidString)
        } catch {
            throw AppError.auth(error.localizedDescription)
        }
    }

    func signUp(email: String, password: String, username: String) async throws {
        do {
            try await supabase.auth.signUp(
                email: email,
                password: password,
                data: ["username": AnyJSON.string(username)]
            )
        } catch {
            throw AppError.auth(error.localizedDescription)
        }
    }
    
    
    func signOut() async throws {
        do {
            try await supabase.auth.signOut()
        } catch {
            throw AppError.auth(error.localizedDescription)
        }
    }

    func currentUser() async -> User? {
        guard let session = try? await supabase.auth.session else { return nil }
        return try? await fetchProfile(userId: session.user.id.uuidString)
    }


    private func fetchProfile(userId: String) async throws -> User {
        let user: User = try await supabase
            .from("users")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
            .value
        return user
    }
}
