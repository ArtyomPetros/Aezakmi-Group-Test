//
//  SignupView.swift
//  TestApp1
//
//  Created by Артём Петросян on 13.09.2024.
//

import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignIn

struct SignupView: View {
    @StateObject private var viewModel = SignupViewModel()
    @Binding var currentShowingView: String
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        Spacer(minLength: 0)
                        Image("Edit")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 600, maxHeight: 90)
                        
                        Text("Регистрация")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Пожалуйста, войдите, чтобы продолжить")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .padding(.top, -5)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()
                    
                        HStack {
                            Image(systemName: "at")
                            TextField("Email", text: $viewModel.email)
                            
                            Spacer()
                            
                            if !viewModel.email.isEmpty {
                                Image(systemName: viewModel.isValidEmail() ? "checkmark" : "xmark")
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.isValidEmail() ? .green : .red)
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                        )
                        .padding()
                        
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Password", text: $viewModel.password)
                                
                            Spacer()
                            
                            if !viewModel.password.isEmpty {
                                Image(systemName: viewModel.isValidPassword() ? "checkmark" : "xmark")
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.isValidPassword() ? .green : .red)
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                        )
                        .padding()
                        
                        Button(action: {
                            withAnimation {
                                self.currentShowingView = "login"
                            }
                        }) {
                            Text("У Вас есть аккаунт?")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.signup()
                        } label: {
                            Text("Создать аккаунт")
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
                        
                        Text("Создавая учетную запись, вы соглашаетесь с нашими Условиями обслуживания")
                            .font(.body.bold())
                            .foregroundColor(.gray)
                            .kerning(1.1)
                            .lineSpacing(8)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .padding()
                }
            }
            
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.25)
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 60, height: 60)
                        .background(Color.black)
                        .cornerRadius(10)
                }
            }
        }
    }
}
