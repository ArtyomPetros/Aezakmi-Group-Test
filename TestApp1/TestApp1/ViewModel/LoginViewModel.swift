//
//  LoginViewModel.swift
//  TestApp1
//
//  Created by Артём Петросян on 14.09.2024.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import Firebase

class LoginViewModel: ObservableObject {
    @AppStorage("uid") var userID: String = ""
    @AppStorage("log_Status") var log_Status = false
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var showPasswordRecovery: Bool = false
    
    func loginWithEmail() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let authResult = authResult {
                    withAnimation {
                        self?.userID = authResult.user.uid
                        self?.log_Status = true
                    }
                }
            }
        }
    }
    
    func loginWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        isLoading = true
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { [weak self] user, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = user?.user, let idToken = user.idToken else { return }
                
                let accessToken = user.accessToken
                let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { res, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let user = res?.user else { return }
                    
                    withAnimation {
                        self?.userID = user.uid
                        self?.log_Status = true
                    }
                }
            }
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
}
