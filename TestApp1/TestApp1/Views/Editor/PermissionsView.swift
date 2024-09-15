//
//  PermissionsView.swift
//  TestApp1
//
//  Created by Артём Петросян on 14.09.2024.
//

import SwiftUI

struct PermissionsView: View {
    @StateObject private var viewModel = PermissionsViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        
                        Image("Pencil")
                            .resizable()
                            .frame(width: 150, height: 150)
                        
                        Text(viewModel.status == true ? "Редактировать фотографии" : "Доступ к фотографиям")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.light)
                            .padding(.bottom, 8)
                        
                        Button(action: {
                            if viewModel.status == true {
                                viewModel.isPickerPresented = true
                            } else if viewModel.status == nil {
                                viewModel.requestAuthorization()
                            }
                        }, label: {
                            Group {
                                if !viewModel.isPickerPresented {
                                    Text(viewModel.status == true ? "Рисунок" : "Получить разрешение")
                                } else {
                                    ProgressView().foregroundColor(.light)
                                }
                            }
                            .buttonStyle(with: geometry)
                        })
                        .disabled(viewModel.status == false)
                        
                        NavigationLink(destination: FilterView()) {
                            Text("Перейти к фильтрам")
                                .buttonStyle(with: geometry)
                        }
                    }
                    
                    if let selectedItem = viewModel.selectedItem {
                        EditorView(media: selectedItem, onClose: {
                            viewModel.closeEditor()
                        })
                    }
                }
            }
            .sheet(isPresented: $viewModel.isPickerPresented) {
                ImagePicker(didFinishSelection: { media in
                    viewModel.handleSelection(media)
                })
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

extension View {
    func buttonStyle(with geometry: GeometryProxy) -> some View {
        self
            .fixedSize()
            .frame(width: geometry.size.width - 96)
            .font(.system(size: 17, weight: .bold))
            .padding()
            .background(Color("Color"))
            .cornerRadius(8)
            .foregroundColor(.light)
    }
}

struct PermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView()
    }
}
