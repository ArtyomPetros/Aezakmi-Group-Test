//
//  LoginView.swift
//  TestApp1
//
//  Created by Артём Петросян on 13.09.2024.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import Firebase

struct LoginView: View {
    @Binding var currentShowingView: String
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: 0)
                
                Image("Edit")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 600, maxHeight: 90)
                
                Text("Вход")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                
                Text("Пожалуйста, войдите, чтобы продолжить")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .padding(.top, -5)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Image(systemName: "at")
                    TextField("Email", text: $viewModel.email)
                    
                    Spacer()
                    
                    if viewModel.email.count != 0 {
                        Image(systemName: viewModel.email.isValidEmail() ? "checkmark" : "xmark")
                            .foregroundColor(viewModel.email.isValidEmail() ? .green : .red)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $viewModel.password)
                    
                    Spacer()
                    
                    if viewModel.password.count != 0 {
                        Image(systemName: viewModel.isValidPassword(viewModel.password) ? "checkmark" : "xmark")
                            .foregroundColor(viewModel.isValidPassword(viewModel.password) ? .green : .red)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                
                Button("У Вас еще нет аккаунта?") {
                    withAnimation {
                        currentShowingView = "signup"
                    }
                }
                .foregroundColor(.white.opacity(0.7))
                
                Button("Забыли пароль?") {
                    viewModel.showPasswordRecovery = true
                }
                .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Button("Войти") {
                    viewModel.loginWithEmail()
                }
                .foregroundColor(.white)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("Color")))
                .padding(.horizontal)
                
                Button(action: {
                    viewModel.loginWithGoogle()
                }) {
                    HStack(spacing: 15) {
                        Image("Google")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                        
                        Text("Войти через Google")
                            .font(.title3)
                            .bold()
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("Color")))
                    .padding(.horizontal)
                }
            }
            .padding()
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .sheet(isPresented: $viewModel.showPasswordRecovery) {
            PasswordRecoveryView()
        }
    }
}
