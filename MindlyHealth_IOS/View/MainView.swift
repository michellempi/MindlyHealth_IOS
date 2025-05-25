//
//  MainView.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showLogin: Bool = true
    var body: some View {
        TabView {
            JournalListView()
                .tabItem {
                    Label("Read", systemImage: "book")
                }

            ProfileView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
}
