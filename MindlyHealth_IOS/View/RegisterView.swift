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

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)

            TextField("Name", text: $authVM.userModel.name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .autocapitalization(.words)

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
                Text("Registration failed. Try again.")
                    .fontWeight(.medium)
                    .foregroundColor(Color.red)
            }

            // Register Button
            Button(
                action: {
                    Task {
                        await authVM.signUp()
                        if !authVM.falseCredential {
                            authVM.checkUserSession()
                            authVM.userModel = UserModel()
                        }
                    }
                }
            ) {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .buttonStyle(.borderedProminent)

            Button(action: {
                withAnimation {
                    isRegisterView = false
                }
            }) {
                Text("Already have an account?")
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
                Text("Login")
                    .font(.system(size: 15))
                    .fontWeight(.medium)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    RegisterView(isRegisterView: .constant(true))
        .environmentObject(AuthViewModel())
}
