//
//  SignUpView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var viewModel = SignUpViewModel()
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(ErrorStore.self) private var errorStore
    
    var body: some View {
        ZStack {
            LiquidBackgroundView()
            
            VStack(spacing: 24) {
                if viewModel.isAwaitingConfirmation {
                    confirmationView
                } else {
                    signUpForm
                }
            }
        }
        .overlay(alignment: .top) {
            ErrorBannerView()
        }
    }
    
    
    private var signUpForm: some View {
        VStack(spacing: 24) {
            handle
            
            wordmark
            
            fields
            
            signUpButton
            
            footer
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .padding(.top, 16)
    }
    
    
    private var confirmationView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "envelope.badge.checkmark")
                .font(.system(size: 64))
                .foregroundStyle(.primary)
            
            VStack(spacing: 8) {
                Text("Check your email")
                    .font(.custom("Georgia", size: 28))
                    .foregroundStyle(.primary)
                
                Text("We sent a confirmation link to\n\(email)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                dismiss()
            } label: {
                Text("Back to sign in")
                    .font(.body)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                    .background(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)
            .padding(.top, 16)
            
            Spacer()
        }
    }
    
    
    private var handle: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color(.tertiaryLabel))
            .frame(width: 36, height: 4)
            .padding(.top, 8)
    }
    
    private var wordmark: some View {
        VStack(spacing: 6) {
            Text("Reverie")
                .font(.custom("Georgia", size: 36))
                .foregroundStyle(.primary)
            
            Text("Create your account")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 8)
    }
    
    private var fields: some View {
        VStack(spacing: 8) {
            inputField(
                placeholder: "Username",
                text: $username,
                error: viewModel.usernameError,
                contentType: .username,
                capitalization: .never
            )
            
            inputField(
                placeholder: "Email",
                text: $email,
                error: viewModel.emailError,
                contentType: .emailAddress,
                keyboardType: .emailAddress,
                capitalization: .never
            )
            
            inputField(
                placeholder: "Password",
                text: $password,
                error: viewModel.passwordError,
                contentType: .newPassword,
                isSecure: true
            )
            
            inputField(
                placeholder: "Confirm password",
                text: $confirmPassword,
                error: viewModel.confirmPasswordError,
                contentType: .newPassword,
                isSecure: true
            )
        }
    }
    
    private var signUpButton: some View {
        Button {
            Task {
                await viewModel.signUp(
                    username: username,
                    email: email,
                    password: password,
                    confirmPassword: confirmPassword
                )
            }
        } label: {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Create account")
                        .font(.body)
                        .fontWeight(.medium)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(.white)
            .background(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(viewModel.isLoading)
    }
    
    private var footer: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .foregroundStyle(.secondary)
            Button("Sign in") {
                dismiss()
            }
            .foregroundStyle(.primary)
        }
        .font(.footnote)
    }
    
    
    private func inputField(
        placeholder: String,
        text: Binding<String>,
        error: String?,
        contentType: UITextContentType,
        keyboardType: UIKeyboardType = .default,
        capitalization: TextInputAutocapitalization = .sentences,
        isSecure: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Group {
                if isSecure {
                    SecureField(placeholder, text: text)
                } else {
                    TextField(placeholder, text: text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(capitalization)
                        .autocorrectionDisabled()
                }
            }
            .textContentType(contentType)
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(error != nil ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
            }
            .onChange(of: text.wrappedValue) { viewModel.clearErrors() }
            
            if let error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.leading, 4)
            }
        }
    }
}

#Preview {
    SignUpView()
        .environment(ErrorStore.shared)
}
