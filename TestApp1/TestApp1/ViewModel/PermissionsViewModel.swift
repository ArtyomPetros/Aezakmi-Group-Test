//
//  PermissionsViewModel.swift
//  TestApp1
//
//  Created by Артём Петросян on 14.09.2024.
//

import SwiftUI
import Photos

class PermissionsViewModel: ObservableObject {
    @Published var isPickerPresented: Bool = false
    @Published var selectedItem: MediaItem?
    @Published var status: Bool? = nil
    
    init() {
        checkAuthorizationStatus()
    }
    
    func checkAuthorizationStatus() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            self.status = nil
        case .authorized, .limited:
            self.status = true
        case .denied, .restricted:
            self.status = false
        @unknown default:
            self.status = false
        }
    }
    
    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    self?.status = true
                } else {
                    self?.status = false
                }
            }
        }
    }
    
    func handleSelection(_ media: MediaItem) {
        selectedItem = media
        isPickerPresented = false
    }
    
    func closeEditor() {
        selectedItem = nil
        isPickerPresented = true
    }
}

