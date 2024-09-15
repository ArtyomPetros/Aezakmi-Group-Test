//
//  PasswordRecoveryView.swift
//  TestApp1
//
//  Created by Артём Петросян on 14.09.2024.
//

import SwiftUI
import FirebaseAuth

struct PasswordRecoveryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var message: String?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Восстановление пароля")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding()
                
                TextField("Введите ваш Email", text: $email)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
                    .padding()
                
                Button(action: sendPasswordReset) {
                    Text("Отправить инструкции")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Color"))
                        )
                        .padding(.horizontal)
                }
                
                if let message = message {
                    Text(message)
                        .foregroundColor(.white)
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Закрыть")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
    
    private func sendPasswordReset() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                message = "Ошибка: \(error.localizedDescription)"
            } else {
                message = "Инструкции по восстановлению пароля отправлены на ваш Email."
            }
        }
    }
}
