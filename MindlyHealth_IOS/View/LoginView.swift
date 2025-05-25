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

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)

            TextField("Email", text: $authVM.userModel.email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $authVM.userModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            if authVM.falseCredential {
                Text("Invalid Username and Password")
                    .fontWeight(.medium)
                    .foregroundColor(Color.red)
            }
            Button(
                action: {
                    Task {
                        await authVM.signIn()
                        if !authVM.falseCredential {
                            authVM.checkUserSession()
                            authVM.userModel = UserModel()
                        }
                    }
                }
            ) {
                Text("Login").frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .buttonStyle(.borderedProminent)

            Button(
                action: {
                    withAnimation {
                        isRegisterView = true
                    }
                }
            ) {
                Text("Don't have an account?").font(.system(size: 15))
                    .fontWeight(
                        .medium
                    )
                    .foregroundStyle(.black)
                Text("Register").font(.system(size: 15))
                    .fontWeight(
                        .medium)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView(isRegisterView: .constant(false))
        .environmentObject(AuthViewModel())
}

