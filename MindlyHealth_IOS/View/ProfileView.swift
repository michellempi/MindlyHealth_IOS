//
//  ProfileView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack(spacing: 25) {
            Spacer()

            Text("My Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            VStack(alignment: .leading, spacing: 15) {
                // Name
                Text("Name")
                    .font(.headline)
                Text(authVM.currentName)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                // Email
                Text("Email")
                    .font(.headline)
                Text(authVM.currentEmail)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }

            // Logout Button
            Button(action: {
                authVM.signOut()
            }) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
