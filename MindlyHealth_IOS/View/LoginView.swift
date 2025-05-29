//
//  LoginView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Binding var isRegisterView: Bool
    @FocusState private var focusedField: Field?
    @State private var showValidationError = false
    @State private var validationMessage = ""
    
    enum Field {
        case email, password
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    
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
                    
                    
                    VStack(spacing: 16) {
                        
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
                                .onChange(of: authVM.userModel.email) { _ in
                                    if showValidationError {
                                        showValidationError = false
                                    }
                                }
                                .onChange(of: authVM.userModel.email) { _ in
                                    if showValidationError {
                                        showValidationError = false
                                    }
                                }
                        }
                        
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
                                .onChange(of: authVM.userModel.password) { _ in
                                    if showValidationError {
                                        showValidationError = false
                                    }
                                }
                                .onChange(of: authVM.userModel.password) { _ in
                                    if showValidationError {
                                        showValidationError = false
                                    }
                                }
                        }
                      
                        if showValidationError {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                                Text(validationMessage)
                                    .font(.footnote)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.orange.opacity(0.1))
                            .cornerRadius(8)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                        
                   
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
                    
                    VStack(spacing: 16) {
                        
                        Button(
                            action: {
                                focusedField = nil
                                
                                
                                if authVM.userModel.email.isEmpty && authVM.userModel.password.isEmpty {
                                    validationMessage = "Enter your Email and Password first to Sign In"
                                    showValidationError = true
                                } else if authVM.userModel.email.isEmpty {
                                    validationMessage = "Enter your Email first"
                                    showValidationError = true
                                } else if authVM.userModel.password.isEmpty {
                                    validationMessage = "Enter your Password first"
                                    showValidationError = true
                                } else {
                                    showValidationError = false
                                    Task {
                                        await authVM.signIn()
                                        if !authVM.falseCredential {
                                            authVM.checkUserSession()
                                            authVM.userModel = UserModel()
                                        }
                                    }
                                }
                            }
                        ) {
                            HStack {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                        }
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .controlSize(.large)
                        
                       
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
        .animation(.easeInOut(duration: 0.2), value: showValidationError)
        .animation(.easeInOut(duration: 0.2), value: showValidationError)
    }
}

#Preview {
    LoginView(isRegisterView: .constant(false))
        .environmentObject(AuthViewModel())
}
