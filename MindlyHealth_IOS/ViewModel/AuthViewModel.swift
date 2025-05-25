//
//  AuthViewModel.swift
//  MindlyHealth_IOS
//
//  Created by Michelle Wijaya on 21/05/25.
//

import FirebaseAuth
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?  //buat ngecek di firebase apakah ada yg login (bawaan dr firebase)
    @Published var isSignedIn: Bool
    @Published var userModel: UserModel  //untuk form register

    @Published var falseCredential: Bool

    init() {
        self.user = nil
        self.isSignedIn = false
        self.falseCredential = false
        self.userModel = UserModel()
        self.checkUserSession()
    }

    func checkUserSession() {
        self.user = Auth.auth().currentUser
        self.isSignedIn = self.user != nil
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }

    //kalo ga pake async: nanti kl firebase blm ngeload ga akan terjadi apapun
    func signIn() async {
        do {
            _ = try await Auth.auth().signIn(
                withEmail: userModel.email, password: userModel.password)
            DispatchQueue.main.async {
                self.falseCredential = false
            }
        } catch {
            DispatchQueue.main.async {
                self.falseCredential = true
            }
        }
    }

    func signUp() async {
        do {
            let _ = try await Auth.auth().createUser(
                withEmail: userModel.email, password: userModel.password)
            self.falseCredential = false  //sign up successful
        } catch {
            print("Sign Up Error: \(error.localizedDescription)")
            self.falseCredential = true  //sign up failed
        }
    }

}
