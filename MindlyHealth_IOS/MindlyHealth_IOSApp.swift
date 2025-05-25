//
//  MindlyHealth_IOSApp.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import Firebase
import FirebaseAppCheck
import SwiftUI

@main
struct MindlyHealth_IOSApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()

        #if DEBUG
            let providerFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authViewModel)
        }
    }
}
