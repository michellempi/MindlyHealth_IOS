//
//  ContentView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isRegisterView: Bool = false

    var body: some View {
        if authVM.isSignedIn {
            MainView()
        } else {
            if isRegisterView {
                RegisterView(isRegisterView: $isRegisterView)
                    .onAppear {
                        authVM.falseCredential = false
                    }
                    .transition(.move(edge: .trailing))
            } else {
                LoginView(isRegisterView: $isRegisterView)
                    .onAppear {
                        authVM.falseCredential = false
                    }
                    .transition(.move(edge: .leading))
            }
        }
    
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
