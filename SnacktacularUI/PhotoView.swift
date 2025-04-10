//
//  PhotoView.swift
//  SnacktacularUI
//
//  Created by Daniel Harris on 08/04/2025.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    @State var spot: Spot // Passed in from SpotDetailView
    @State private var photo = Photo()
    @State private var data = Data() // We need to take image & convert it to data to save it
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            selectedImage
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            Text("by: \(photo.reviewer), on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
            
                .toolbar{
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            Task{
                                await PhotoViewModel.saveImage(spot: spot, photo: photo, data: data)
                                dismiss()
                            }
                        }
                    }
                }
                .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
                .onChange(of: selectedPhoto) {
                    // turn selectedPhoto into usable Image View
                    Task{
                        do{
                            if let image = try await
                                selectedPhoto?.loadTransferable(type: Image.self) {
                                selectedImage = image
                            }
                            // Get raw date from image so we can save it to FIrebase Storage
                            guard let transferredData = try await selectedPhoto?.loadTransferable(type: Data.self)
                            else {
                                print("😡 ERROR: Could not convert data from selectedPhoto")
                                return
                            }
                            data = transferredData
                        } catch {
                            print("😡 Could not create Image from selectedPhoto. \(error.localizedDescription)")
                            
                        }
                        
                    }
                    
                    
                    
                }
            padding()
        }
    }
}

#Preview {
    PhotoView(spot: Spot())
}
