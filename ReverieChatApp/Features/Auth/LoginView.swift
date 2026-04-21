//
//  LoginView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import SwiftUI

struct LoginView: View {
    
    @State private var viewModel = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUp: Bool = false
    
    var body: some View {
        ZStack {
            LiquidBackgroundView()
            
            VStack(spacing: 24) {
                Spacer()
                wordmark
                Spacer()
                fields
                loginButton
                divider
                appleButton
                footer
                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }
    
    
    private var wordmark: some View {
        VStack(spacing: 6) {
            Text("Reverie")
                .font(.custom("Georgia", size: 36))
                .foregroundStyle(.primary)
            
            Text("Sign in to continue")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var fields: some View {
        VStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(viewModel.emailError != nil ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                    }
                    .onChange(of: email) { viewModel.clearErrors() }
                
                if let error = viewModel.emailError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.leading, 4)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(viewModel.passwordError != nil ? Color.red.opacity(0.6) : Color.clear, lineWidth: 1)
                    }
                    .onChange(of: password) { viewModel.clearErrors() }
                
                if let error = viewModel.passwordError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.leading, 4)
                }
            }
        }
    }
    
    private var loginButton: some View {
        Button {
            Task {
                await viewModel.signIn(email: email, password: password)
            }
        } label: {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Sign in")
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
    
    private var divider: some View {
        HStack {
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(.tertiary)
            Text("or")
                .font(.caption)
                .foregroundStyle(.tertiary)
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(.tertiary)
        }
    }
    
    private var appleButton: some View {
        Button {
            Task {
                await viewModel.signInWithApple()
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "apple.logo")
                Text("Sign in with Apple")
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(.primary)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(viewModel.isLoading)
    }
    
    private var footer: some View {
        HStack(spacing: 4) {
            Text("No account?")
                .foregroundStyle(.secondary)
            Button("Sign up") {
                showSignUp = true
            }
            .foregroundStyle(.primary)
        }
        .font(.footnote)
        .sheet(isPresented: $showSignUp) {
            SignUpView()
                .environment(ErrorStore.shared)
        }
    }
}

#Preview {
    LoginView()
}
