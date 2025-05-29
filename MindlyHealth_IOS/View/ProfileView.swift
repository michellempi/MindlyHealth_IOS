//
//  ProfileView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showingLogoutAlert = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                
                    VStack(spacing: 16) {
                  
                        ZStack {
                            Circle()
                                .fill(.blue.gradient)
                                .frame(width: 100, height: 100)
                            
                            Text(String(authVM.currentName.prefix(1).uppercased()))
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.top, 40)
                        
                        VStack(spacing: 4) {
                            Text(authVM.currentName.isEmpty ? "User" : authVM.currentName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            Text(authVM.currentEmail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, max(60, geometry.safeAreaInsets.top + 40))
                    .padding(.bottom, 40)
                    
                   
                    VStack(spacing: 16) {
                        
                        HStack {
                            Text("Account Information")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                        
                        VStack(spacing: 12) {
                           
                            ProfileInfoRow(
                                icon: "person.fill",
                                title: "Full Name",
                                value: authVM.currentName.isEmpty ? "Not provided" : authVM.currentName,
                                iconColor: .blue
                            )
                            
                            Divider()
                                .padding(.horizontal, 56)
                            
                     
                            ProfileInfoRow(
                                icon: "envelope.fill",
                                title: "Email Address",
                                value: authVM.currentEmail,
                                iconColor: .green
                            )
                        }
                        .padding(.vertical, 16)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 40)
                    
                   
                    VStack(spacing: 16) {
                     
                        HStack {
                            Text("Account Actions")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                        
                        VStack(spacing: 12) {
                          
                           
                           
                            Button(action: {
                                showingLogoutAlert = true
                            }) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(.red.opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "power")
                                            .font(.system(size: 18))
                                            .foregroundStyle(.red)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Sign Out")
                                            .font(.body)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.red)
                                        
                                        Text("Sign out of your account")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(.plain)
                        }
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, max(40, geometry.safeAreaInsets.bottom + 20))
                }
            }
            .frame(minHeight: geometry.size.height)
        }
        .background(.regularMaterial)
        .ignoresSafeArea()
        .alert("Sign Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                authVM.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out of your account?")
        }
    }
}


struct ProfileInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
