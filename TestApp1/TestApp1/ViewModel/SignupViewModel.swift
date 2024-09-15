//
//  SignupViewModel.swift
//  TestApp1
//
//  Created by Артём Петросян on 14.09.2024.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Firebase

class SignupViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @AppStorage("uid") var userID: String = ""
    @AppStorage("log_Status") var log_Status = false
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    func signup() {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            
            if let authResult = authResult {
                print("User created with UID: \(authResult.user.uid)")
                self.userID = authResult.user.uid
                self.log_Status = true
                
                self.sendEmailVerification()
            }
        }
    }
    
    private func sendEmailVerification() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.sendEmailVerification { error in
            if let error = error {
                print("Error sending email verification: \(error.localizedDescription)")
                return
            }
            print("Email verification sent.")
        }
    }
    
    func handleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        isLoading = true
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { [weak self] user, error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = user?.user, let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { res, error in
                self.isLoading = false
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = res?.user else { return }
                print(user)
                withAnimation {
                    self.log_Status = true
                }
            }
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}")
        return emailRegex.evaluate(with: email)
    }
    
    func isValidPassword() -> Bool {
        return isValidPassword(password)
    }
}
