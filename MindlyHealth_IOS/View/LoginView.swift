//
//  LoginView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Binding var isRegisterView: Bool  // binding dari ContentView
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Welcome Back")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .padding(.top, 150)
                        
                        Text("Sign in to your MindlyHealth account")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, max(40, geometry.safeAreaInsets.top + 20))
                    .padding(.bottom, 40)
                    
                    // Form Section
                    VStack(spacing: 16) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            TextField("Enter your email", text: $authVM.userModel.email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .textContentType(.emailAddress)
                                .focused($focusedField, equals: .email)
                                .onSubmit {
                                    focusedField = .password
                                }
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            SecureField("Enter your password", text: $authVM.userModel.password)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.password)
                                .focused($focusedField, equals: .password)
                                .onSubmit {
                                    focusedField = nil
                                }
                        }
                        
                        // Error Message
                        if authVM.falseCredential {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.red)
                                Text("Invalid email or password. Please try again.")
                                    .font(.footnote)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.red.opacity(0.1))
                            .cornerRadius(8)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // Action Buttons Section
                    VStack(spacing: 16) {
                        // Login Button
                        Button(
                            action: {
                                focusedField = nil
                                Task {
                                    await authVM.signIn()
                                    if !authVM.falseCredential {
                                        authVM.checkUserSession()
                                        authVM.userModel = UserModel()
                                    }
                                }
                            }
                        ) {
                            HStack {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 20)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(authVM.userModel.email.isEmpty ||
                                 authVM.userModel.password.isEmpty)
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(.quaternary)
                                .frame(height: 1)
                            Text("OR")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 16)
                            Rectangle()
                                .fill(.quaternary)
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)
                        
                        // Register Button
                        Button(action: {
                            focusedField = nil
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isRegisterView = true
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .foregroundStyle(.secondary)
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                            }
                            .font(.subheadline)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, max(20, geometry.safeAreaInsets.bottom))
                }
            }
            .frame(minHeight: geometry.size.height)
        }
        .background(.regularMaterial)
        .ignoresSafeArea()
        .onTapGesture {
            focusedField = nil
        }
        .animation(.easeInOut(duration: 0.2), value: authVM.falseCredential)
    }
}

#Preview {
    LoginView(isRegisterView: .constant(false))
        .environmentObject(AuthViewModel())
}
