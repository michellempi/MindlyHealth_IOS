//
//  RegisterView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Binding var isRegisterView: Bool
    @FocusState private var focusedField: Field?
    @State private var showValidationError = false
    @State private var validationMessage = ""
    
    enum Field {
        case name, email, password
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                                   
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
                                .onChange(of: authVM.userModel.name) { _ in
                                    if showValidationError {
                                        showValidationError = false
                                    }
                                }
                        }
                        
                        
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
                        }
                        
                        
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
                    
                    
                    VStack(spacing: 16) {
                        
                        Button(
                            action: {
                                focusedField = nil
                                
                               
                                let emptyFields = [
                                    (authVM.userModel.name.isEmpty, "Full Name"),
                                    (authVM.userModel.email.isEmpty, "Email"),
                                    (authVM.userModel.password.isEmpty, "Password")
                                ]
                                
                                let missingFields = emptyFields.compactMap { isEmpty, fieldName in
                                    isEmpty ? fieldName : nil
                                }
                                
                                if !missingFields.isEmpty {
                                    if missingFields.count == 3 {
                                        validationMessage = "Enter your Full Name/Email/Password first"
                                    } else if missingFields.count == 2 {
                                        validationMessage = "Enter your \(missingFields.joined(separator: "/")) first"
                                    } else {
                                        validationMessage = "Enter your \(missingFields[0]) first"
                                    }
                                    showValidationError = true
                                } else {
                                    showValidationError = false
                                    Task {
                                        await authVM.signUp()
                                        if !authVM.falseCredential {
                                            authVM.checkUserSession()
                                            authVM.userModel = UserModel()
                                        }
                                    }
                                }
                            }
                        ) {
                            HStack {
                                Text("Create Account")
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
        .animation(.easeInOut(duration: 0.2), value: showValidationError)
    }
}


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
