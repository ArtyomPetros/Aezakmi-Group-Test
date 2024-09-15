//
//  LoadingView.swift
//  TestApp1
//
//  Created by Артём Петросян on 14.09.2024.
//
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.25).edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(width: 60, height: 60)
                .background(Color.black)
                .cornerRadius(10)
        }
    }
}
