//
//  RegisterView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Binding var isRegisterView: Bool  // binding dari ContentView
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, email, password
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                                    // Header Section
                                    VStack(alignment: .leading, spacing: 8) {
                                        
                                        Text("Create Account")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.primary)
                                            .padding(.top, 100)
                                        
                                        Text("Join MindlyHealth to get started")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 24)
                                    .padding(.top, max(40, geometry.safeAreaInsets.top + 20))
                                    .padding(.bottom, 40)
                    
                    // Form Section
                    VStack(spacing: 16) {
                        // Name Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Full Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            TextField("Enter your full name", text: $authVM.userModel.name)
                                .textFieldStyle(CustomTextFieldStyle())
                                .autocapitalization(.words)
                                .textContentType(.name)
                                .focused($focusedField, equals: .name)
                                .onSubmit {
                                    focusedField = .email
                                }
                        }
                        
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
                            
                            SecureField("Create a password", text: $authVM.userModel.password)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.newPassword)
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
                                Text("Registration failed. Please try again.")
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
                        // Register Button
                        Button(
                            action: {
                                focusedField = nil
                                Task {
                                    await authVM.signUp()
                                    if !authVM.falseCredential {
                                        authVM.checkUserSession()
                                        authVM.userModel = UserModel()
                                    }
                                }
                            }
                        ) {
                            HStack {
                                Text("Create Account")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 20)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(authVM.userModel.name.isEmpty ||
                                 authVM.userModel.email.isEmpty ||
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
                        
                        // Login Button
                        Button(action: {
                            focusedField = nil
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isRegisterView = false
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text("Already have an account?")
                                    .foregroundStyle(.secondary)
                                Text("Sign In")
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

// Custom TextField Style sesuai HIG
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.quaternary, lineWidth: 1)
            )
    }
}

#Preview {
    RegisterView(isRegisterView: .constant(true))
        .environmentObject(AuthViewModel())
}
