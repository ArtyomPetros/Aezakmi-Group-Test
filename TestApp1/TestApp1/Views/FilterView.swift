//
//  Crop.swift
//  TestApp1
//
//  Created by Артём Петросян on 14.09.2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct FilterView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters = false

    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview

    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()

    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                Spacer()

                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                            .border(Color.gray, width: 1)
                            .shadow(radius: 5)
                    } else {
                        ContentUnavailableView("Нет фото", systemImage: "photo.badge.plus", description: Text("Выберите фото"))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)

                Spacer()

                HStack {
                    Text("Уровень")
                        .foregroundColor(.white)
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
                        .tint(.gray)
                }

                HStack {
                    Button("Изменить фильтры", action: changeFilter)
                        .fixedSize()
                        .font(.system(size: 17, weight: .bold))
                        .padding()
                        .background(Color("Color"))
                        .cornerRadius(8)
                        .foregroundColor(.light)

                    Spacer()

                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Ваше фото", image: processedImage)) {
                            Text("Отправить")
                                .fixedSize()
                                .font(.system(size: 17, weight: .bold))
                                .padding()
                                .background(Color("Color"))
                                .cornerRadius(8)
                                .foregroundColor(.light)
                        }
                    }
                }

            }
            .padding([.horizontal, .bottom])
            .background(Color.black)
            .navigationTitle("Фильтры")
            .foregroundColor(.white)
            .confirmationDialog("Выберите фильтр", isPresented: $showingFilters) {
                Button("Кристаллизоваться") { setFilter(CIFilter.crystallize() )}
                Button("Размытие по Гауссу") { setFilter(CIFilter.gaussianBlur() )}
                Button("Пикселизированный") { setFilter(CIFilter.pixellate() )}
                Button("Оттенок сепии") { setFilter(CIFilter.sepiaTone() )}
                Button("Нерезкая маска") { setFilter(CIFilter.unsharpMask() )}
                Button("Виньетка") { setFilter(CIFilter.vignette() )}
                Button("Отмена", role: .cancel) { }
            }
        }
        .preferredColorScheme(.dark)
    }

    func changeFilter() {
        showingFilters = true
    }

    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }

            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }

    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()

        filterCount += 1

        if filterCount >= 20 {
            requestReview()
        }
    }
}

#Preview {
    FilterView()
}
