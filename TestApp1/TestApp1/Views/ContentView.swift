//
//  ContentView.swift
//  TestApp1
//
//  Created by Артём Петросян on 13.09.2024.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct ContentView: View {

    @AppStorage("uid") var userID: String = ""
    @AppStorage("log_Status") var log_Status = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                if log_Status && !userID.isEmpty {
                    // Пользователь вошел в систему и есть uid
                    PermissionsView()
                    
                    Button(action: {
                        // Логика выхода
                        signOut()
                    }) {
                        Text("Выйти")
                            .fixedSize()
                            .font(.system(size: 17, weight: .bold))
                            .padding()
                            .background(Color("Color"))
                            .cornerRadius(8)
                            .foregroundColor(.light)
                    }
                } else {
                    AuthView()
                        .foregroundColor(.white)
                        .onAppear {
                            // Проверка состояния аутентификации
                            updateAuthStatus()
                        }
                }
            }
            .background(Color.black) // Черный фон всего VStack
            .onAppear {
                // Дополнительная проверка состояния при каждом отображении ContentView
                updateAuthStatus()
            }
        }
    }

    private func updateAuthStatus() {
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
            log_Status = true
        } else {
            userID = ""
            log_Status = false
        }
    }

    private func signOut() {
        // Попытка выхода из Google
        GIDSignIn.sharedInstance.signOut()

        // Попытка выхода из Firebase
        do {
            try Auth.auth().signOut()
            userID = ""
            log_Status = false
        } catch {
            print("Ошибка выхода из Firebase: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
